LinkLuaModifier("modifier_hunger",
    "modifiers/modifier_hunger.lua",
LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_overeating",
    "modifiers/modifier_overeating.lua",
LUA_MODIFIER_MOTION_NONE)

function Spawn()
    ListenToGameEvent('game_rules_state_change', function (data) 
        if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
            thisEntity.IS_HUNGER_ROSHAN = true
            thisEntity:AddNewModifier(thisEntity, nil, "modifier_hunger", {})
            --thisEntity:SetModifierStackCount("modifier_hunger", thisEntity, 2)
            
            Timers:CreateTimer(function()
                if GameRules:IsDaytime() and thisEntity ~= nil then
                    thisEntity:AddNoDraw()
                    thisEntity:AddNewModifier(thisEntity, nil, "modifier_invulnerable", {})
                    thisEntity:AddNewModifier(thisEntity, nil, "modifier_phased", {})
                    return 0.1
                elseif thisEntity ~= nil then
                    thisEntity:RemoveNoDraw()
                    thisEntity:RemoveModifierByName("modifier_invulnerable")
                    thisEntity:RemoveModifierByName("modifier_phased")
                    return 0.1
                end
                return 0
            end)
            
        end        
    end, nil)   
end
