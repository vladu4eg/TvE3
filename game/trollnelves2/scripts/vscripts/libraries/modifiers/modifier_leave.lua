modifier_leave = class({})


function modifier_leave:CheckState() 
    return { [MODIFIER_STATE_MUTED] = true,
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_SILENCED] = true,
            [MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_BLIND] = true,}
end

function modifier_leave:IsHidden()
    return true
end

function modifier_leave:IsPurgable()
    return false
end