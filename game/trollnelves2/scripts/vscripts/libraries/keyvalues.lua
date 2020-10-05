KEYVALUES_VERSION = "1.00"

 -- Change to false to skip loading the base files
LOAD_BASE_FILES = false

--[[
    Simple Lua KeyValues library
    Author: Martin Noya // github.com/MNoya
    Installation:
    - require this file inside your code
    Usage:
    - Your npc custom files will be validated on require, error will occur if one is missing or has faulty syntax.
    - This allows to safely grab key-value definitions in npc custom abilities/items/units/heroes
    
        "some_custom_entry"
        {
            "CustomName" "Barbarian"
            "CustomKey"  "1"
            "CustomStat" "100 200"
        }
        With a handle:
            handle:GetKeyValue() -- returns the whole table based on the handles baseclass
            handle:GetKeyValue("CustomName") -- returns "Barbarian"
            handle:GetKeyValue("CustomKey")  -- returns 1 (number)
            handle:GetKeyValue("CustomStat") -- returns "100 200" (string)
            handle:GetKeyValue("CustomStat", 2) -- returns 200 (number)
        
        Same results with strings:
            GetKeyValue("some_custom_entry")
            GetKeyValue("some_custom_entry", "CustomName")
            GetKeyValue("some_custom_entry", "CustomStat")
            GetKeyValue("some_custom_entry", "CustomStat", 2)
    - Ability Special value grabbing:
        "some_custom_ability"
        {
            "AbilitySpecial"
            {
                "01"
                {
                    "var_type"    "FIELD_INTEGER"
                    "some_key"    "-3 -4 -5"
                }
            }
        }
        With a handle:
            ability:GetAbilitySpecial("some_key") -- returns based on the level of the ability/item
        With string:
            GetAbilitySpecial("some_custom_ability", "some_key")    -- returns "-3 -4 -5" (string)
            GetAbilitySpecial("some_custom_ability", "some_key", 2) -- returns -4 (number)
    Notes:
    - In case a key can't be matched, the returned value will be nil
    - Don't identify your custom units/heroes with the same name or it will only grab one of them.
]]

if not KeyValues then
    KeyValues = {}
end

local split = function(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- Load all the necessary key value files
function LoadGameKeyValues()
    local scriptPath ="scripts/npc/"
    local files = { AbilityKV = {base="npc_abilities",custom="npc_abilities_custom"},
                    ItemKV = {base="items",custom="npc_items_custom"},
                    UnitKV = {base="npc_units",custom="npc_units_custom"},
                    HeroKV = {base="npc_heroes",custom="npc_heroes_custom"}
                  }

    -- Load and validate the files
    for k,v in pairs(files) do
        local file = {}
        if LOAD_BASE_FILES then
            file = LoadKeyValues(scriptPath..v.base..".txt")
        end

        local custom_file = LoadKeyValues(scriptPath..v.custom..".txt")
        if custom_file then
            for k,v in pairs(custom_file) do
                file[k] = v
            end
        else
            print("[KeyValues] Critical Error on "..v.custom..".txt")
            return
        end
        
        GameRules[k] = file --backwards compatibility
        KeyValues[k] = file
    end   

    -- Merge All KVs
    KeyValues.All = {}
    for name,path in pairs(files) do
        for key,value in pairs(KeyValues[name]) do
            if not KeyValues.All[key] then
                KeyValues.All[key] = value
            end
        end
    end

    -- Merge units and heroes (due to them sharing the same class CDOTA_BaseNPC)
    for key,value in pairs(KeyValues.HeroKV) do
        if not KeyValues.UnitKV[key] then
            KeyValues.UnitKV[key] = value
        else
            if type(KeyValues.All[key]) == "table" then
                print("[KeyValues] Warning: Duplicated unit/hero entry for "..key)
            end
        end
    end
end

-- Works for heroes and units on the same table due to merging both tables on game init
function CDOTA_BaseNPC:GetKeyValue(key, level)
    if level then return GetUnitKV(self:GetUnitName(), key, level)
    else return GetUnitKV(self:GetUnitName(), key) end
end

-- Dynamic version of CDOTABaseAbility:GetAbilityKeyValues()
function CDOTABaseAbility:GetKeyValue(key, level)
    if level then return GetAbilityKV(self:GetAbilityName(), key, level)
    else return GetAbilityKV(self:GetAbilityName(), key) end
end

-- Item version
function CDOTA_Item:GetKeyValue(key, level)
    if level then return GetItemKV(self:GetAbilityName(), key, level)
    else return GetItemKV(self:GetAbilityName(), key) end
end

function CDOTABaseAbility:GetAbilitySpecial(key)
    return GetAbilitySpecial(self:GetAbilityName(), key, self:GetLevel())
end

-- Global functions
-- Key is optional, returns the whole table by omission
-- Level is optional, returns the whole value by omission
function GetKeyValue(name, key, level, tbl)
    local t = tbl or KeyValues.All[name]
    if key and t then
        if t[key] and level then
            local s = split(t[key])
            if s[level] then return tonumber(s[level]) or s[level] -- Try to cast to number
            else return tonumber(s[#s]) or s[#s] end
        else return t[key] end
    else return t end
end

function GetUnitKV(unitName, key, level)
    return GetKeyValue(unitName, key, level, KeyValues.UnitKV[unitName])
end

function GetAbilityKV(abilityName, key, level)
    return GetKeyValue(abilityName, key, level, KeyValues.AbilityKV[abilityName])
end

function GetItemKV(itemName, key, level)
    return GetKeyValue(itemName, key, level, KeyValues.ItemKV[itemName])
end

function GetAbilitySpecial(name, key, level)
    local t = KeyValues.All[name]
    if key and t then
        local tspecial = t["AbilitySpecial"]
        if tspecial then
            -- Find the key we are looking for
            for _,values in pairs(tspecial) do
                if values[key] then
                    if not level then return values[key]
                    else
                        local s = split(values[key])
                        if s[level] then return tonumber(s[level]) -- If we match the level, return that one
                        else return tonumber(s[#s]) end -- Otherwise, return the max
                    end
                    break
                end
            end
        end
    else return t end
end

function WriteObjectAsKV(object, indentLevel)
    for key, value in pairs(object) do
        local indentString = string.rep("    ", indentLevel)
        io.write(indentString, "\"", tostring(key), "\"")
        if type(value) == "table" then
            io.write(" {\n")
            WriteObjectAsKV(value, indentLevel+1)
            io.write(indentString, "}\n")
        else
            local numberOfSpaces = 60 - #tostring(key) - 4 * indentLevel
            io.write(string.rep(" ", numberOfSpaces), "\"", value, "\"\n")
        end
    end
end

function GenerateKV()
    for name,info in pairs(KeyValues.All) do
        if type(info) == "table" then
            local isBuilding = info["ConstructionSize"]
            local isBuildingAbility = info["Building"]
            if isBuilding then
                -- Build NetTable with the building properties
                local values = {}

                if info['ConstructionSize'] then
                    values.size = info['ConstructionSize']
                end

                if info['Limit'] then
                    values.limit = info['Limit']
                end

                
                if info['Requirements'] then
                    values.requirements = info["Requirements"]
                end

                if info['Upgrades'] then
                    local count = info['Upgrades']['Count']
                    for i = 1,count do
                        local unit_name = info['Upgrades'][tostring(i)]['unit_name']
                        values[unit_name] = {}
                        values[unit_name].gold_cost = info['Upgrades'][tostring(i)]['gold_cost']
                        values[unit_name].lumber_cost = info['Upgrades'][tostring(i)]['lumber_cost']
                    end
                end

                if info['GoldAmount'] then
                    values.gold_gain = info['GoldAmount']
                end
                CustomNetTables:SetTableValue("buildings", name, values)

            elseif isBuildingAbility then

                if info['UnitName'] then
                    local values = {}
                    values.upgradeUnitName = info['UnitName']
                    values.gold_cost = info['AbilitySpecial']['01']['gold_cost']
                    values.lumber_cost = info['AbilitySpecial']['02']['lumber_cost']
                    CustomNetTables:SetTableValue("buildings",name, values)
                elseif info['OnSpellStart'] then
                    if info['OnSpellStart']['RunScript'] then
                        if info['OnSpellStart']['RunScript']['NewName'] then
                            CustomNetTables:SetTableValue("buildings",name, { upgradeUnitName = info['OnSpellStart']['RunScript']['NewName']})
                        end
                    end
                end

            elseif info["BuyItem"] then
                local itemName = info["ItemName"]
                local bonus_attr
                if GetItemKV(itemName)["AbilitySpecial"]["01"] then
                    for key,value in pairs(GetItemKV(itemName)["AbilitySpecial"]["01"]) do
                        if string.match(key,"bonus") then
                            bonus_attr = key
                        end
                    end
                    local bonus_values = GetItemKV(itemName)["AbilitySpecial"]["01"][bonus_attr]
                    local gold = GetItemKV(itemName)["AbilitySpecial"]["02"]["gold_cost"]
                    local lumber = GetItemKV(itemName)["AbilitySpecial"]["03"]["lumber_cost"]
                    CustomNetTables:SetTableValue("items",name, { bonus_stats = bonus_attr , bonus_value = bonus_values , gold_cost = gold , lumber_cost = lumber })
                else
                    local gold = GetItemKV(itemName)["AbilitySpecial"]["02"]["gold_cost"]
                    local lumber = GetItemKV(itemName)["AbilitySpecial"]["03"]["lumber_cost"]
                    CustomNetTables:SetTableValue("items",name, { gold_cost = gold , lumber_cost = lumber })
                end
            elseif info["LumberAmount"] and info["LumberInterval"] then
                CustomNetTables:SetTableValue("abilities",name, { lumber_interval = info["LumberInterval"],amount = info["LumberAmount"] })
            elseif string.match(name,"train_") then
                CustomNetTables:SetTableValue("abilities",name, { gold_cost = info['AbilitySpecial']['01']['gold_cost'],lumber_cost = info['AbilitySpecial']['02']['lumber_cost'],food_cost = info['AbilitySpecial']['03']['food_cost'] })
            elseif info["RepairSpeed"] then
                CustomNetTables:SetTableValue("abilities",name, { speed = info["RepairSpeed"] })
            end
        end
    end
end

if not KeyValues.All then LoadGameKeyValues() end