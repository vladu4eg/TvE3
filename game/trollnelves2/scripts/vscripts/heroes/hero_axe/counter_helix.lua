function CounterHelix(keys)
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local helix_modifier = keys.helix_modifier

  -- If the caster has the helix modifier then do not trigger the counter helix
  -- as its considered to be on cooldown
  if target == caster and not caster:HasModifier(helix_modifier) then
    ability:ApplyDataDrivenModifier(caster, caster, helix_modifier, {})
  end
end
