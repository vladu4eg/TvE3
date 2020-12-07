LinkLuaModifier("modifier_hunger",
    "modifiers/modifier_hunger.lua",
    LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_overeating",
    "modifiers/modifier_overeating.lua",
    LUA_MODIFIER_MOTION_NONE)

function Feed(keys)
    local target = keys.target
    local hero = keys.caster
    local item = keys.ability

    if target.IS_HUNGER_ROSHAN then

        if target:HasModifier("modifier_hunger") then
            target:ForceKill(false)
        end

        target:EmitSound("retard.fart")
        item:Use()
    else
        DebugPrint("ELSE")
    end
end