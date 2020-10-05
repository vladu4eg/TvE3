--LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

--	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )
	thisEntity.init = false
	print(thisEntity.init)

	NoTargetAbility1 = thisEntity:FindAbilityByName( "troll_boss_berserkers_rage" )
	PointAbility = thisEntity:FindAbilityByName( "troll_boss_whirling_axes_ranged" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "troll_boss_whirling_axes_melee" )
	NoTargetAbility3 = thisEntity:FindAbilityByName( "troll_boss_battle_trance" )

	thisEntity:SetContextThink( "ThisEntityThink", ThisEntityThink, 1 )
end

function ThisEntityThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if not thisEntity.init then
		thisEntity.init = true
		thisEntity.rage = false
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
		
		if thisEntity.rage == false and health_pct < 50 then
			thisEntity.rage = true
			if NoTargetAbility1 ~= nil and NoTargetAbility1:IsFullyCastable()  then
				NoTargetAbility1:ToggleAbility()
				NoTargetAbility2:SetActivated(true)
				PointAbility:SetActivated(false)
			end
		end

		if NoTargetAbility3 ~= nil and NoTargetAbility3:IsFullyCastable() and health_pct < 50  then
			return CastNoTargetAbility3()
		end

		if thisEntity.rage then
			if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable()  then
				return CastNoTargetAbility2()
			end
		else
			if PointAbility ~= nil and PointAbility:IsFullyCastable() then
				return CastPointAbility( enemies[ 1 ] )
			end
		end

	end
		return 0.5
	
end


function CastNoTargetAbility1()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility1:entindex(),
		Queue = false,
	})
	
	return 1
end

function CastNoTargetAbility2()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility2:entindex(),
		Queue = false,
	})
	
	return 1
end

function CastNoTargetAbility3()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility3:entindex(),
		Queue = false,
	})
	
	return 1
end


function CastPointAbility( enemy )
	if enemy == nil then
		return
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = PointAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 1 
end



