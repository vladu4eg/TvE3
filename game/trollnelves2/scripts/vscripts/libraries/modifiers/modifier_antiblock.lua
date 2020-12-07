modifier_antiblock = class({})

function modifier_antiblock:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = true}
end

function modifier_antiblock:IsHidden()
    return true
end

function modifier_antiblock:IsPurgable()
    return false
end