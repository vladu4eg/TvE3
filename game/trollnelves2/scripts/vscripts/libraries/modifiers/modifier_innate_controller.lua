modifier_innate_controller = class({})

function modifier_innate_controller:IsHidden()
    return false
end

function modifier_innate_controller:IsPurgable()
    return false
end

function modifier_innate_controller:GetModifierStatusResistance()
	return self:GetStackCount() * 5
end