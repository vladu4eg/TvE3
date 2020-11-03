modifier_generic_invisibility = class({})

function modifier_generic_invisibility:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_EVENT_ON_ATTACK,
  }
end
--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_invisibility:IsHidden()
  return false
end

function modifier_generic_invisibility:IsDebuff()
  return false
end

function modifier_generic_invisibility:IsPurgable()
  return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_invisibility:OnCreated(kv)
  -- references
  self.delay = kv.delay or 0
  self.attack_reveal = kv.attack_reveal or true
  self.ability_reveal = kv.ability_reveal or true
  self.bonus_movement_speed = kv.bonus_movement_speed or 0

  self.hidden = false

  if IsServer() then
    -- Start interval
    self:StartIntervalThink(self.delay)
  end
end

function modifier_generic_invisibility:OnDestroy(kv)
end

--------------------------------------------------------------------------------
-- Modifier Effects

function modifier_generic_invisibility:GetModifierMoveSpeedBonus_Percentage(params)
  return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

function modifier_generic_invisibility:GetModifierInvisibilityLevel()
  return 1
end

function modifier_generic_invisibility:OnAbilityExecuted(params)
  if IsServer() then
    if not self.ability_reveal then
      return
    end
    if params.unit ~= self:GetParent() then
      return
    end

    self:Destroy()
  end
end

function modifier_generic_invisibility:OnAttack(params)
  if IsServer() then
    if not self.attack_reveal then
      return
    end
    if params.attacker ~= self:GetParent() then
      return
    end

    self:Destroy()
  end
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_generic_invisibility:CheckState()
  return {
    [MODIFIER_STATE_INVISIBLE] = self.hidden,
  }
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_generic_invisibility:OnIntervalThink()
  DebugPrint("on interval think")
  self.hidden = true
  self:StartIntervalThink(-1)
end
