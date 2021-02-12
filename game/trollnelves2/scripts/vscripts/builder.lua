require('libraries/util')
require('trollnelves2')
require('stats')
require('wearables')

-- A build ability is used (not yet confirmed)
function Build( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local building_name = ability:GetAbilityKeyValues()['UnitName']
    local hero = caster:IsRealHero() and caster or caster:GetOwner()
    local playerID = hero:GetPlayerOwnerID()
    local gold_cost = ability:GetSpecialValueFor("gold_cost")
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
    
    -- Makes a building dummy and starts panorama ghosting
    BuildingHelper:AddBuilding(event)
    
    -- Additional checks to confirm a valid building position can be performed here
    event:OnPreConstruction(function(vPos)
        
        -- Check for minimum height if defined
        if not BuildingHelper:MeetsHeightCondition(vPos) then
            SendErrorMessage(playerID, "#error_invalid_build_position")
            return false
        end
        
        -- If not enough resources to queue, stop
        if PlayerResource:GetGold(playerID) < gold_cost then
            SendErrorMessage(playerID, "#error_not_enough_gold")
            return false
        end
        if PlayerResource:GetLumber(playerID) < lumber_cost then
            SendErrorMessage(playerID, "#error_not_enough_lumber")
            return false
        end
        return true
    end)
    
    -- Position for a building was confirmed and valid
    event:OnBuildingPosChosen(function(vPos)
        PlayerResource:ModifyGold(hero,-gold_cost)
        PlayerResource:ModifyLumber(hero,-lumber_cost)
        EmitSoundOnClient("DOTA_Item.ObserverWard.Activate", PlayerResource:GetPlayer(playerID))
    end)
    
    -- The construction failed and was never confirmed due to the gridnav being blocked in the attempted area
    event:OnConstructionFailed(function()
        --local playerTable = BuildingHelper:GetPlayerTable(playerID)
        --local name = playerTable.activeBuilding or " "
        --BuildingHelper:print("Failed placement of " .. name)
    end)
    
    -- Cancelled due to ClearQueue
    event:OnConstructionCancelled(function(work)
        local name = work.name
        BuildingHelper:print("Cancelled construction of " .. name)
        -- Refund resources for this cancelled work
        if work.refund and work.refund == true and not work.repair then
            PlayerResource:ModifyGold(hero,gold_cost,true)
            PlayerResource:ModifyLumber(hero,lumber_cost,true)
        end
    end)
    
    --local status, nextCall = ErrorCheck(function() 
        -- A building unit was created
        event:OnConstructionStarted(function(unit)
            BuildingHelper:print("Started construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
            unit.gold_cost = gold_cost
            unit.lumber_cost = lumber_cost
            unit:AddNewModifier(unit,nil,"modifier_phased",{}) 
            -- If it's an item-ability and has charges, remove a charge or remove the item if no charges left
            if ability.GetCurrentCharges and not ability:IsPermanent() then
                local charges = ability:GetCurrentCharges()
                charges = charges-1
                if charges == 0 then
                    ability:RemoveSelf()
                    else
                    ability:SetCurrentCharges(charges)
                end
            end
            --unit:RemoveModifierByName("modifier_invulnerable")
            unit:AddNewModifier(nil, nil, "modifier_stunned", {})
            FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
            caster:AddNewModifier(caster, nil, "modifier_phased", {duration=0.03})
            
            local unitName = unit:GetUnitName()
            ModifyStartedConstructionBuildingCount(hero, unitName, 1)
            table.insert(hero.units, unit)
            AddUpgradeAbilities(unit)
            UpdateSpells(hero)
            local item = CreateItem("item_building_cancel", unit, unit)
            if building_name ~= "flag"  then
                unit:AddItem(item)
            elseif building_name == "flag" then 
                unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
                unit:AddNewModifier(unit, nil, "modifier_phased", {})
            end
            
            for i=0, unit:GetAbilityCount()-1 do
                local ability = unit:GetAbilityByIndex(i)
                if ability then
                    local constructionStartModifiers = GetAbilityKV(ability:GetAbilityName(), "ConstructionStartModifiers")
                    if constructionStartModifiers then
                        for k,modifier in pairs(constructionStartModifiers) do
                            ability:ApplyDataDrivenModifier(unit, unit, modifier, {})
                        end
                    end
                end
            end
        end)
    --end)
    
    
    
    -- A building finished construction
    event:OnConstructionCompleted(function(unit)
        BuildingHelper:print("Completed construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex() .. " " .. tostring(unit))
        unit.state = "complete"
        unit.ancestors = {}
        local item = unit:GetItemInSlot(0)
        if item then
            UTIL_Remove(item)
        end
        
        local unitName = unit:GetUnitName()
        ModifyCompletedConstructionBuildingCount(hero, unitName, 1)
        
        UpdateSpells(hero)
        for _, value in ipairs(hero.units) do
            UpdateUpgrades(value)
        end
        
        -- Give the unit their original attack capability
        unit:RemoveModifierByName("modifier_stunned")
        local itemBuildingDestroy = CreateItem("item_building_destroy", nil, nil)
        if building_name ~= "flag"  then
            unit:AddItem(itemBuildingDestroy)
        elseif building_name == "flag" then 
            unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
            unit:AddNewModifier(unit, nil, "modifier_phased", {})
        end
        unit.attackers = {}
        
        for i=0, unit:GetAbilityCount()-1 do
            local buildingAbility = unit:GetAbilityByIndex(i)
            if buildingAbility then
                local constructionCompleteModifiers = GetAbilityKV(buildingAbility:GetAbilityName(), "ConstructionCompleteModifiers")
                if constructionCompleteModifiers then
                    for k,modifier in pairs(constructionCompleteModifiers) do
                        buildingAbility:ApplyDataDrivenModifier(unit, unit, modifier, {})
                    end
                end
            end
        end
        
        local player = unit:GetPlayerOwner()
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "unit_upgrade_complete", { })
        end
        
    end)
    
    -- These callbacks will only fire when the state between below half health/above half health changes.
    -- i.e. it won't fire multiple times unnecessarily.
    event:OnBelowHalfHealth(function(unit)
        --BuildingHelper:print("" .. unit:GetUnitName() .. " is below half health.")
    end)
    
    event:OnAboveHalfHealth(function(unit)
        --BuildingHelper:print("" ..unit:GetUnitName().. " is above half health.")        
    end)
	
    --	if building_name == "tent" and IsInsideBaseArea(hero) == false then
	--	local check = false
	--	DebugPrint("Test1")
    --		for _,base in ipairs(playersBase) do
	--		local numBase, pID = unpack(base)
	--		DebugPrint("Test1.2")
	--		if pID == playerID then
	--			check = true
	--			DebugPrint("Test2")
	--		end
	--	end
	--	DebugPrint("Test3.1")
    --		DebugPrint(IdBaseArea(hero))
    --if check == false and IdBaseArea(hero) ~= nil then
	--		table.insert(playersBase,{IdBaseArea(hero),playerID})
	--		DebugPrint("Test3.2")
	--	end
    --	end
end

-- Called when the Cancel ability-item is used
function CancelBuilding( keys )
    DebugPrint("Trying to cancel!")
    local building = keys.unit
    local hero = building:GetOwner()
    
    BuildingHelper:print("CancelBuilding "..building:GetUnitName().." "..building:GetEntityIndex())
    
    -- Refund here
    PlayerResource:ModifyGold(hero,building.gold_cost,true)
    PlayerResource:ModifyLumber(hero,building.lumber_cost,true)
    
    -- Eject builder
    local builder = building.builder_inside
    if builder then
        BuildingHelper:ShowBuilder(builder)
    end
    building:ForceKill(true)
    Timers:CreateTimer(0.1,function()
        UTIL_Remove(building)    
    end)
end

function DestroyBuilding( keys )
    local building = keys.unit
    local units = FindUnitsInRadius(building:GetTeamNumber() , building:GetAbsOrigin() , nil , 1500 , DOTA_UNIT_TARGET_TEAM_ENEMY ,  DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    local ownerID = building:GetPlayerOwnerID()
    local playerID = building:GetMainControllingPlayer()
    if #units > 0 then
        SendErrorMessage(playerID, "#error_enemy_nearby")
    elseif PlayerResource:GetConnectionState(ownerID) == 3 then
        SendErrorMessage(playerID, "#error_not_destroy_building")
    else
        building:ForceKill(false)
    end
end

function printTryError(...)
	local stack = debug.traceback(...)
	print(stack) 
    GameRules:SendCustomMessage(stack, 1, 1)
	return stack
end

function ErrorCheck(callback, ...)
    print("BuildError")
	return xpcall(callback, printTryError, ...)
end

function UpgradeBuilding( event )
    local building = event.caster
    local NewBuildingName = event.NewName
    local playerID = building:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local upgrades = GetUnitKV(building:GetUnitName(),"Upgrades")
    local buildTime = GetUnitKV(NewBuildingName,"BuildTime")
    local gold_cost
    local lumber_cost
    local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(building:GetPlayerOwnerID()))
    
    if string.match(building:GetUnitName(),"troll_hut") then
        hero = GameRules.trollHero
        playerID = GameRules.trollID
    end
    
    -- I do it like this so you are able to have two buildings upgrade into the same upgraded building with different prices and only having one ability
    local count = tonumber(upgrades.Count)
    for i = 1, count, 1 do
        local upgrade = upgrades[tostring(i)]
        local upgraded_unit_name = upgrade.unit_name
        if upgraded_unit_name == NewBuildingName then
            gold_cost = upgrade.gold_cost
            lumber_cost = upgrade.lumber_cost
        end
    end
    if gold_cost > PlayerResource:GetGold(playerID) then
        SendErrorMessage(playerID, "#error_not_enough_gold")
        return false
    end
    if lumber_cost > PlayerResource:GetLumber(playerID) then
        SendErrorMessage(playerID, "#error_not_enough_lumber")
        return false
    end
    -- if GameRules.MapSpeed >= 4 and NewBuildingName == 'tower_19' then
    --    SendErrorMessage(playerID, "#error_not_upgrade_tower19_x4")
    --     return false
    --  end
	building:AddNewModifier(nil, nil, "modifier_stunned", {}) 
	
    local newBuilding
    --local status, nextCall = ErrorCheck(function() 
        newBuilding = BuildingHelper:UpgradeBuilding(building,NewBuildingName)
   -- end)
    local newBuildingName = newBuilding:GetUnitName()
    newBuilding.state = "complete"
    
    newBuilding.ancestors = building.ancestors
    table.insert(newBuilding.ancestors,building:GetUnitName())
    for _, ancestorUnitName in pairs(newBuilding.ancestors) do
        ModifyStartedConstructionBuildingCount(hero, ancestorUnitName, 1)
        ModifyCompletedConstructionBuildingCount(hero, ancestorUnitName, 1)
    end
    table.insert(hero.units, newBuilding)
    ModifyStartedConstructionBuildingCount(hero, newBuildingName, 1)
    
    local ability = event.ability
    local skips = GetAbilityKV(ability:GetAbilityName(),"SkipRequirements")
    if skips then
        for _, skipUnitName in pairs(skips) do
            ModifyStartedConstructionBuildingCount(hero, skipUnitName, 1)
            ModifyCompletedConstructionBuildingCount(hero, skipUnitName, 1)
        end
    end
    
    PlayerResource:ModifyGold(hero,-gold_cost)
    PlayerResource:ModifyLumber(hero,-lumber_cost)
    AddUpgradeAbilities(newBuilding)
    for i=0, newBuilding:GetAbilityCount()-1 do
        local newBuildingAbility = newBuilding:GetAbilityByIndex(i)
        if newBuildingAbility then
            local constructionCompleteModifiers = GetAbilityKV(newBuildingAbility:GetAbilityName(), "ConstructionCompleteModifiers")
            if constructionCompleteModifiers then
                for _, modifier in pairs(constructionCompleteModifiers) do
                    newBuildingAbility:ApplyDataDrivenModifier(newBuilding, newBuilding, modifier, {})
                end
            end
            local constructionStartModifiers = GetAbilityKV(newBuildingAbility:GetAbilityName(), "ConstructionStartModifiers")
            if constructionStartModifiers then
                for _, modifier in pairs(constructionStartModifiers) do
                    newBuildingAbility:ApplyDataDrivenModifier(newBuilding, newBuilding, modifier, {})
                end
            end
        end
    end
    local position = newBuilding:GetAbsOrigin()
    building:ForceKill(true)
    newBuilding.construction_size = BuildingHelper:GetConstructionSize(newBuildingName)
    if not string.match(newBuilding:GetUnitName(),"troll_hut") then
        newBuilding.blockers = BuildingHelper:BlockGridSquares(newBuilding.construction_size, BuildingHelper:GetBlockPathingSize(newBuildingName), position)
        elseif newBuilding:GetUnitName() == "troll_hut_7" then
        hero:AddAbility("lone_druid_spirit_bear_datadriven")
        local abil = hero:FindAbilityByName("lone_druid_spirit_bear_datadriven")
        abil:SetLevel(abil:GetMaxLevel())
    end
    local p
    if parts ~= nil then    
        if parts["3"] == "normal" then
            if newBuildingName == "tower_11" then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/venomancer/venomancer_hydra_switch_color_arms/venomancer_hydra_switch_color_arms.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/venomancer/venomancer_hydra_switch_color_shoulder/venomancer_hydra_switch_color_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/venomancer/venomancer_hydra_switch_color_head/venomancer_hydra_switch_color_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/venomancer/venomancer_hydra_switch_color_tail/venomancer_hydra_switch_color_tail.vmdl") 
                elseif newBuildingName == "tower_11_1" then     
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/viper/king_viper_head/king_viper_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/viper/king_viper_back/king_viper_back.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/viper/king_viper_tail/viper_king_viper_tail.vmdl")
                elseif newBuildingName == "tower_12" then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/drow/drow_ti9_immortal_weapon/drow_ti9_immortal_weapon.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/mask_of_madness/mask_of_madness.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/frostfeather_huntress_shoulder/frostfeather_huntress_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/frostfeather_huntress_misc/frostfeather_huntress_misc.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/ti6_immortal_cape/mesh/drow_ti6_immortal_cape.vmdl")        
                wearables:AttachWearable(newBuilding, "models/items/drow/frostfeather_huntress_arms/frostfeather_huntress_arms.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/drow/frostfeather_huntress_legs/frostfeather_huntress_legs.vmdl") 
                p = ParticleManager:CreateParticle("particles/econ/items/drow/drow_ti6_gold/drow_ti6_ambient_gold.vpcf", 1, newBuilding)
                ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
                elseif newBuildingName == "tower_13" then
                --wearables:RemoveWearables(newBuilding)
                -- wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl")
                --wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl")
                -- wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl")
                --wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_back/ti6_windranger_back.vmdl")
                --wearables:AttachWearable(newBuilding, "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl")
                --local p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bowstring_ambient.vpcf", 0, newBuilding)
                --ParticleManager:SetParticleControlEnt(p, 0, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
                -- p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bow_ambient.vpcf", 1, newBuilding)
                -- ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
                --p = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_bowstring.vpcf", 3, newBuilding)
                --ParticleManager:SetParticleControlEnt(p, 3, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
                
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_cape.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_quiver.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/windrunner/windrunner_arcana/wr_arcana_weapon.vmdl")
                --local p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_battleranger/windrunner_battleranger_bowstring_ambient.vpcf", 0, newBuilding)
                --ParticleManager:SetParticleControlEnt(p, 0, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
                p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_bow_ambient.vpcf", 1, newBuilding)
                ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
                --p = ParticleManager:CreateParticle("particles/econ/items/windrunner/windranger_arcana/windranger_arcana_bowstring_ambient.vpcf", 3, newBuilding)
                --ParticleManager:SetParticleControlEnt(p, 3, newBuilding, PATTACH_POINT_FOLLOW, "attach_hook",  newBuilding:GetAbsOrigin(), true)
                
                elseif newBuildingName == "tower_14"  then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/vengefulspirit/fallenprincess_head/fallenprincess_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/vengefulspirit/fallenprincess_legs/fallenprincess_legs.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/vengefulspirit/fallenprincess_weapon/fallenprincess_weapon.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/vengefulspirit/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder.vmdl")
                
                p = ParticleManager:CreateParticle("particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder_crimson_ambient.vpcf", 1, newBuilding)
                ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
                elseif newBuildingName == "tower_15"  then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/shadow_fiend/arms_deso/arms_deso.vmdl")
                wearables:AttachWearable(newBuilding, "models/heroes/shadow_fiend/head_arcana.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/nevermore/sf_souls_tyrant_shoulder/sf_souls_tyrant_shoulder.vmdl")              
                elseif newBuildingName == "tower_15_1"  then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/nevermore/ferrum_chiroptera_head/ferrum_chiroptera_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/nevermore/ferrum_chiroptera_shoulder/ferrum_chiroptera_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/nevermore/ferrum_chiroptera_arms/ferrum_chiroptera_arms.vmdl")
                local p = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/shadow_fiend_ambient_eyes.vpcf", 1, newBuilding)
                ParticleManager:SetParticleControlEnt(p, 1, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
                p = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_head_ambient.vpcf", 2, newBuilding)
                ParticleManager:SetParticleControlEnt(p, 2, newBuilding, PATTACH_POINT_FOLLOW, "follow_origin", newBuilding:GetAbsOrigin(), true)
                p = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_shoulder_ambient.vpcf", 3, newBuilding)
                ParticleManager:SetParticleControlEnt(p, 3, newBuilding, PATTACH_POINT_FOLLOW, "attach_hook",  newBuilding:GetAbsOrigin(), true)
                elseif newBuildingName == "tower_16"  then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/lanaya/raiment_of_the_violet_archives_shoulder/raiment_of_the_violet_archives_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/lanaya/raiment_of_the_violet_archives_armor/raiment_of_the_violet_archives_armor.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/lanaya/raiment_of_the_violet_archives_head_hood/raiment_of_the_violet_archives_head_hood.vmdl")
                elseif newBuildingName == "tower_17"  then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_head/luna_ti7_set_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_mount/luna_ti7_set_mount.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_shoulder/luna_ti7_set_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_weapon/luna_ti7_set_weapon.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/luna/luna_ti7_set_offhand/luna_ti7_set_offhand.vmdl")
                elseif newBuildingName == "tower_18"  then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/medusa/dotaplus_medusa_weapon/dotaplus_medusa_weapon.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/medusa/daughters_of_hydrophiinae/daughters_of_hydrophiinae.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_immortal_tail.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/medusa/dotaplas_medusa_head/dotaplas_medusa_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/medusa/dotaplus_medusa_arms/dotaplus_medusa_arms.vmdl")
                elseif newBuildingName == "tower_19" or newBuildingName == "tower_19_1" or newBuildingName == "tower_19_2" then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/enigma/tentacular_conqueror_armor/tentacular_conqueror_armor.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/enigma/tentacular_conqueror_arms/tentacular_conqueror_arms.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/enigma/tentacular_conqueror_head/tentacular_conqueror_head.vmdl")
                elseif newBuildingName == "tower_18"  then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/medusa/dotaplus_medusa_weapon/dotaplus_medusa_weapon.vmdl")
                elseif newBuildingName == "tower_10_1" then
                wearables:RemoveWearables(newBuilding)
                wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_shoulder/witch_hunter_set_shoulder.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_arms/witch_hunter_set_arms.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_head/witch_hunter_set_head.vmdl")
                wearables:AttachWearable(newBuilding, "models/items/sniper/witch_hunter_set_back/witch_hunter_set_back.vmdl")
                elseif string.match(GetMapName(),"winter") and newBuildingName == "true_sight_tower" then
                wearables:RemoveWearables(newBuilding)
                UpdateModel(newBuilding, "models/items/wards/frozen_formation/frozen_formation.vmdl", 1)    
				elseif string.match(GetMapName(),"spring") and newBuildingName == "true_sight_tower" then
                wearables:RemoveWearables(newBuilding)
                UpdateModel(newBuilding, "models/items/wards/sylph_ward/sylph_ward.vmdl", 1)    
				elseif (string.match(GetMapName(),"autumn") or string.match(GetMapName(),"halloween")) and newBuildingName == "true_sight_tower" then 
                wearables:RemoveWearables(newBuilding)
                UpdateModel(newBuilding, "models/items/wards/watcher_below_ward/watcher_below_ward.vmdl", 1)
                elseif string.match(GetMapName(),"desert") and newBuildingName == "true_sight_tower" then 
                wearables:RemoveWearables(newBuilding)
                UpdateModel(newBuilding, "models/items/wards/megagreevil_ward/megagreevil_ward.vmdl", 1)    
                --elseif newBuildingName == "rock_18" then
                --   wearables:RemoveWearables(newBuilding)
                --   UpdateModel(newBuilding, "models/items/world/towers/ti10_radiant_tower/ti10_radiant_tower.vmdl", 0.3)
                --elseif newBuildingName == "rock_19" then
                --   wearables:RemoveWearables(newBuilding)
                -- UpdateModel(newBuilding, "models/items/world/towers/ti10_radiant_tower/ti10_radiant_tower_model_editor.vmdl", 0.3)
                --elseif newBuildingName == "mother_of_nature" and parts["3"] == "normal" then
                --    wearables:RemoveWearables(newBuilding)
                --    wearables:AttachWearable(newBuilding, "models/items/enchantress/dota_plus_enchantress_belt_/dota_plus_enchantress_belt_.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/enchantress/dota_plus_enchantress_weapon/dota_plus_enchantress_weapon.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/enchantress/dota_plus_enchantress_arm_/dota_plus_enchantress_arm_.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/enchantress/dota_plus_enchantress_head/dota_plus_enchantress_head.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/enchantress/dota_plus_enchantress_neck/dota_plus_enchantress_neck.vmdl")
                -- elseif newBuildingName == "trader_3" and parts["3"] == "normal" then
                --    wearables:RemoveWearables(newBuilding)
                --    wearables:AttachWearable(newBuilding, "models/items/shredder/mad_destructor_armor/mad_destructor_armor.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/shredder/mad_destructor_back/mad_destructor_back.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/shredder/mad_destructor_shoulder/mad_destructor_shoulder.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/shredder/mad_destructor_head/mad_destructor_head.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/shredder/mad_destructor_weapon/mad_destructor_weapon.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/shredder/mad_destructor_offhand/mad_destructor_offhand.vmdl")
                -- elseif newBuildingName == "research_lab2" and parts["3"] == "normal" then
                --    wearables:RemoveWearables(newBuilding)
                --    wearables:AttachWearable(newBuilding, "models/items/alchemist/stove_guardian_armor/stove_guardian_armor.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/alchemist/stove_guardian_arms/stove_guardian_arms.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/alchemist/stove_guardian_weapon/stove_guardian_weapon.vmdl")
                --   wearables:AttachWearable(newBuilding, "models/items/alchemist/stove_guardian_off_hand/stove_guardian_off_hand.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/alchemist/stove_guardian_neck/stove_guardian_neck.vmdl")
                --    wearables:AttachWearable(newBuilding, "models/items/alchemist/stove_guardian_back/stove_guardian_back.vmdl")    
                --    wearables:AttachWearable(newBuilding, "models/items/alchemist/stove_guardian_shoulder/stove_guardian_shoulder.vmdl")
                
            end
        end
    end    
    Timers:CreateTimer(buildTime,function()
        if newBuilding:IsNull() or not newBuilding:IsAlive() then
            return
        end
        
        newBuilding:RemoveModifierByName("modifier_stunned")
        if not string.match(newBuildingName,"troll_hut") and newBuildingName ~= "tower_19" and newBuildingName ~= "tower_19_1" and newBuildingName ~= "tower_19_2" then
            local item = CreateItem("item_building_destroy", nil, nil)
            newBuilding:AddItem(item)
        end
        ModifyCompletedConstructionBuildingCount(hero, newBuildingName, 1)
        UpdateSpells(hero)
        for _, value in ipairs(hero.units) do
            UpdateUpgrades(value)
        end
    end)
end

