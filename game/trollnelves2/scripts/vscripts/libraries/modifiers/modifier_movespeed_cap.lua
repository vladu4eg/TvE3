modifier_movespeed_cap = class({})

function modifier_movespeed_cap:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_MOVESPEED_MAX,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
  }
end

function modifier_movespeed_cap:GetModifierMoveSpeed_Max(params)
  return 1000
end

function modifier_movespeed_cap:GetModifierMoveSpeed_Limit(params)
  return 1000
end

function modifier_movespeed_cap:GetModifierIgnoreMovespeedLimit()
  return 1
end

function modifier_movespeed_cap:IsHidden()
  return true
end
