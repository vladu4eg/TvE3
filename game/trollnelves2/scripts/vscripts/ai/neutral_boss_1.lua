--LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

	TargetAbility = thisEntity:FindAbilityByName( "satyr_soulstealer_mana_burn" )

	thisEntity:SetContextThink( "NeutralBoss1", NeutralBoss1, 1 )
end

function NeutralBoss1()
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


		if TargetAbility ~= nil and TargetAbility:IsFullyCastable() then
			return CastTargetAbility( enemies[ 1 ] )
		end

	end
		return 0.5
	
end


function CastTargetAbility( enemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = TargetAbility:entindex(),
		TargetIndex = enemy:entindex(),
		Queue = false,
	})

	return 0.5
end

function UseMaskOfMadness()
	if thisEntity.hMaskOfMadnessAbility ~= nil and thisEntity.hMaskOfMadnessAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = thisEntity.hMaskOfMadnessAbility:entindex(),
			Queue = false,
		})
	end
end

