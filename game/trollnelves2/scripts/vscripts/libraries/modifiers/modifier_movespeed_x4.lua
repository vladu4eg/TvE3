modifier_movespeed_x4 = class({})

function modifier_movespeed_x4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_x4:GetModifierMoveSpeed_Max( params )
    return 800
end

function modifier_movespeed_x4:GetModifierMoveSpeed_Limit( params )
    return 800
end

function modifier_movespeed_x4:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_movespeed_x4:IsHidden()
    return true
end