function Feed(keys)
    local target = keys.target
    local hero = keys.caster
    local item = keys.ability

    if target.IS_HUNGER_ROSHAN then

        if target:HasModifier("") then

            local newStackCount = target:GetModifierStackCount("", target) - 1
            if newStackCount > 0 then
                target:SetModifierStackCount("", target, newStackCount)
            else
                target:RemoveModifierByName("")
            end

        elseif target:HasModifier("modifier_overeating") then
            CRetardDeath:Npc(target, "EAT_CHEESE_NPC")
        else
            target:AddNewModifier(target, nil, "modifier_overeating", {})
        end
        item:Use()
    else
        target:ForceKill(false)
    end
end