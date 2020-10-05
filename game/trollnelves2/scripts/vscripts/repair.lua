--------------------------------
--       Repair Scripts       --
--------------------------------

function Repair(event)
    local caster = event.caster
    local target = event.target

    BuildingHelper:AddRepairToQueue(caster, target, false)
end

-- Right before starting to move towards the target
function BuildingHelper:OnPreRepair(builder, target)
    -- Custom repair target rules
    local bValidRepair = target:GetClassname() == "npc_dota_creature" and IsCustomBuilding(target) and (target.missingHealthToComplete or target:GetHealthDeficit() > 0)

    -- Return false to stop the repair process
    return bValidRepair
end

-- As soon as the builder reaches the building
function BuildingHelper:OnRepairStarted(builder, building)
    --self:print("OnRepairStarted "..builder:GetUnitName().." "..builder:GetEntityIndex().." -> "..building:GetUnitName().." "..building:GetEntityIndex())

    local repair_ability = self:GetRepairAbility(builder)
    if repair_ability and repair_ability:GetToggleState() == false then
        repair_ability:ToggleAbility() -- Fake toggle the ability
    end
    
    local direction = (building:GetAbsOrigin()-builder:GetAbsOrigin()):Normalized()
    builder:SetForwardVector(direction)
    builder:StartGesture(ACT_DOTA_ATTACK)
    builder.repair_animation_timer = Timers:CreateTimer(function()
        if not building:IsNull() and not builder:IsNull() and builder.state == "repairing" then
            local direction = (building:GetAbsOrigin()-builder:GetAbsOrigin()):Normalized()
            builder:SetForwardVector(direction)
            builder:StartGesture(ACT_DOTA_ATTACK)
        end
        return 1
    end)
end

function BuildingHelper:OnRepairTick(building, hpGain, costFactor)
    local playerID = building:GetPlayerOwnerID()
    local buildTime = building:GetKeyValue("BuildTime")

    -- Keep adding the floating point values every tick
    local pct_healed = hpGain / building:GetMaxHealth()

end

-- After an ongoing move-to-building or repair process is cancelled
function BuildingHelper:OnRepairCancelled(builder, building)
   -- self:print("OnRepairCancelled "..builder:GetUnitName().." "..builder:GetEntityIndex().." -> "..building:GetUnitName().." "..building:GetEntityIndex())
    if builder.repair_animation_timer then
        builder:RemoveGesture(ACT_DOTA_ATTACK)
        Timers:RemoveTimer(builder.repair_animation_timer)
    end
end

-- After a building is fully constructed via repair ("RequiresRepair" buildings), or is fully repaired
function BuildingHelper:OnRepairFinished(builder, building)
   -- self:print("OnRepairFinished "..builder:GetUnitName().." "..builder:GetEntityIndex().." -> "..building:GetUnitName().." "..building:GetEntityIndex())
    if builder.repair_animation_timer then 
        builder:RemoveGesture(ACT_DOTA_ATTACK)
        Timers:RemoveTimer(builder.repair_animation_timer)
    end
end
