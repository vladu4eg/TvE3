modifier_custom_armor = class({})

function modifier_custom_armor:IsPurgable()
  return false
end

function modifier_custom_armor:IsHidden()
  return true
end

function modifier_custom_armor:RemoveOnDeath()
  return false
end

function modifier_custom_armor:IsPermanent()
  return true
end

function modifier_custom_armor:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
  }
end

-- Only run on server so client still shows unmodified armor values
if IsServer() then
  function modifier_custom_armor:GetModifierPhysicalArmorBonus()
    if (self.checkArmor) then
      return 0
    else
      self.checkArmor = true
      local armor = self:GetParent():GetPhysicalArmorValue(false)
      self.checkArmor = false
      return armor * -1; -- Return negative armor, so dota 2 thinks the armor is 0 and gives 0 physical resistance
    end
  end

  function modifier_custom_armor:GetModifierIncomingPhysicalDamage_Percentage()
    self.checkArmor = true
    local armor = self:GetParent():GetPhysicalArmorValue(false)
    self.checkArmor = false
    local physicalResistance = 0.06*armor/(1+0.06*math.abs(armor))*100*-1 -- Calculate physical resistance with custom formula
    return physicalResistance
  end
end
