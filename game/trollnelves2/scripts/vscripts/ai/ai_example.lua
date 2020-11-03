--LinkLuaModifier( "modifier_fow_vision", "modifiers/modifier_fow_vision", LUA_MODIFIER_MOTION_NONE )

function Spawn(entityKeyValues)
  if not IsServer() then
    return
  end

  if thisEntity == nil then
    return
  end

  --	thisEntity:AddNewModifier( thisEntity, nil, "modifier_fow_vision", nil )

  PointAbility = thisEntity:FindAbilityByName("satyr_hellcaller_shockwave")
  NoTargetAbility = thisEntity:FindAbilityByName("spawnlord_master_stomp")
  TargetAbility = thisEntity:FindAbilityByName("satyr_soulstealer_mana_burn")

  thisEntity:SetContextThink("ThisEntityThink", ThisEntityThink, 1)
end

function ThisEntityThink()
  if (not thisEntity:IsAlive()) then
    return -1
  end

  if GameRules:IsGamePaused() == true then
    return 1
  end

  -- Increase acquisition range after the initial aggro

  local enemies = FindUnitsInRadius(
    thisEntity:GetTeamNumber(), --команда юнита
    thisEntity:GetOrigin(), --местоположение юнита
    nil, --айди юнита (необязательно)
    600, --радиус поиска
    DOTA_UNIT_TARGET_TEAM_ENEMY, -- юнитов чьей команды ищем вражеской/дружественной
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, --юнитов какого типа ищем
    DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, --поиск по флагам
    FIND_CLOSEST, --сортировка от ближнего к дальнему или от дальнего к ближнему
    false)

  if #enemies > 0 then
    local health_pct = thisEntity:GetHealthPercent()

    if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() then
      return CastNoTargetAbility()
    end

    if PointAbility ~= nil and PointAbility:IsFullyCastable() then
      return CastPointAbility(enemies[1])
    end

    if TargetAbility ~= nil and TargetAbility:IsFullyCastable() then
      return CastTargetAbility(enemies[1])
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

function CastPointAbility(enemy)
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

  return 3
end

function CastTargetAbility(enemy)

  ExecuteOrderFromTable({
    UnitIndex = thisEntity:entindex(),
    OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
    AbilityIndex = TargetAbility:entindex(),
    TargetIndex = enemy:entindex(),
    Queue = false,
  })

  return 0.5
end
