CheckUnit = true
function TvESpawnBoss(trigger)
	if CheckUnit then
		local point = trigger.activator:GetAbsOrigin() 
        local waypoint = Entities:FindByName( nil, "event_line") 
        
        local unit = CreateUnitByName( "event_line_boss" , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 
        unit:SetInitialGoalEntity( waypoint )
        unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
        unit:AddNewModifier(unit, nil, "modifier_phased", {})
        unit:SetMaterialGroup(1)
		
        local dropRadius = RandomFloat( 20, 120 )     
        local spawnPoint = unit:GetAbsOrigin() + RandomVector( dropRadius )
        local newItem = CreateItem( "item_event_helheim", nil, nil )
        local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
        newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint )
		CheckUnit = false
	end
end