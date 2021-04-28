modifier_innate_controller = class({})

function modifier_innate_controller:IsHidden()
    return false
end

function modifier_innate_controller:IsPurgable()
    return false
end

function modifier_innate_controller:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
	return funcs
end

function modifier_innate_controller:GetModifierStatusResistanceStacking()
	return self:GetStackCount() * 5
end