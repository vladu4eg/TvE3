--LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	NoTargetAbility = thisEntity:FindAbilityByName( "spawnlord_master_stomp" )

	thisEntity:SetContextThink( "NeutralBoss3", NeutralBoss3, 1 )
end

function NeutralBoss3()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Increase acquisition range after the initial aggro

	local enemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),	--команда юнита
									thisEntity:GetOrigin(),		--местоположение юнита
									nil,	--айди юнита (необязательно)
									600,	--радиус поиска
									DOTA_UNIT_TARGET_TEAM_ENEMY,	-- юнитов чьей команды ищем вражеской/дружественной
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	--юнитов какого типа ищем 
									DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	--поиск по флагам
									FIND_CLOSEST,	--сортировка от ближнего к дальнему или от дальнего к ближнему
									false )

	if #enemies > 0 	then
		local health_pct = thisEntity:GetHealthPercent()

		if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() and health_pct < 90  then
			return CastNoTargetAbility()
		end
	end
		return 0.5
	
end


function CastNoTargetAbility()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility:entindex(),
		Queue = false,
	})
	
	return 2.5
end

