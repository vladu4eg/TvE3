function Spawn()

    ListenToGameEvent('game_rules_state_change', function (data)

        if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then

            CAddonRetardGame:InitModifier("modifier_hunger")
            CAddonRetardGame:InitModifier("modifier_overeating")

            thisEntity.IS_HUNGER_ROSHAN = true
            thisEntity:AddNewModifier(thisEntity, nil, "modifier_hunger", {})
            thisEntity:SetModifierStackCount("modifier_hunger", thisEntity, 1)
        end

    end, nil)

end
