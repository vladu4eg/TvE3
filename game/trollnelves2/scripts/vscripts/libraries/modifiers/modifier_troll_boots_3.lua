modifier_troll_boots_3 = class({})

function modifier_troll_boots_3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }

    return funcs
end

function modifier_troll_boots_3:GetModifierMoveSpeed_Max( params )
    return 650
end

function modifier_troll_boots_3:GetModifierMoveSpeed_Limit( params )
    return 650
end

function modifier_troll_boots_3:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_troll_boots_3:GetModifierMoveSpeedBonus_Special_Boots()
   return self:GetAbility():GetSpecialValueFor("bonus_ms")
end 
function modifier_troll_boots_3:IsHidden()
    return true
end