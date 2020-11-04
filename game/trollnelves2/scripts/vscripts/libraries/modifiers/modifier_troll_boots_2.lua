modifier_troll_boots_2 = class({})

function troll_boots_2(keys)
  keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_troll_boots_2", nil)
end

function modifier_troll_boots_2:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_MAX,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
  }

  return funcs
end

function modifier_troll_boots_2:GetModifierMoveSpeed_Max(params)
  return 600
end

function modifier_troll_boots_2:GetModifierMoveSpeed_Limit(params)
  return 600
end

function modifier_troll_boots_2:GetModifierIgnoreMovespeedLimit()
  return 1
end

function modifier_troll_boots_2:GetModifierMoveSpeedBonus_Special_Boots()
  return self:GetAbility():GetSpecialValueFor("bonus_ms")
end
function modifier_troll_boots_2:IsHidden()
  return true
end
