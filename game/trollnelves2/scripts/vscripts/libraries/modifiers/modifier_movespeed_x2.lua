modifier_movespeed_x2 = class({})

function modifier_movespeed_x2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_x2:GetModifierMoveSpeed_Max( params )
    return 600
end

function modifier_movespeed_x2:GetModifierMoveSpeed_Limit( params )
    return 600
end

function modifier_movespeed_x2:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_movespeed_x2:IsHidden()
    return true
end