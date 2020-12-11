LinkLuaModifier("modifier_hunger",
    "modifiers/modifier_hunger.lua",
LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_overeating",
    "modifiers/modifier_overeating.lua",
LUA_MODIFIER_MOTION_NONE)

function Feed(keys)
    local target = keys.target
    local hero = keys.caster
    local item = keys.ability
    
    if target.IS_HUNGER_ROSHAN and GameRules.PlayersCount >= MIN_RATING_PLAYER then
        
        if target:HasModifier("modifier_hunger") then
                    
        item:Use()
        
        local point = Entities:FindByName( nil, "line_spawner"):GetAbsOrigin() 
        local waypoint = Entities:FindByName( nil, "event_line") 
        
        local unit = CreateUnitByName( "event_line_boss" , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 
        unit:SetInitialGoalEntity( waypoint )
        unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
        unit:AddNewModifier(unit, nil, "modifier_phased", {})
        
        local dropRadius = RandomFloat( 20, 120 )     
        local spawnPoint = unit:GetAbsOrigin() + RandomVector( dropRadius )
        local newItem = CreateItem( "item_event_winter", nil, nil )
        local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint )    
        
        target:ForceKill(false)
        end
        else
        DebugPrint("ELSE")
    end
end