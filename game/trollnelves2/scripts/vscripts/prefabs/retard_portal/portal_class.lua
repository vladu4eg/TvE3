if _G['CRetardPortal'] == nil then
    
    CRetardPortal = class({})
    _G['CRetardPortal'] = CRetardPortal
    
    CRetardPortal.currentTriggerPortalName = nil
    CRetardPortal.arUnitsInPortal = {}
    CRetardPortal.closedPortal = {}
end

function CRetardPortal:AddTriggerPortalIn(entity)
    self.currentTriggerPortalName = entity:GetName()
end

function CRetardPortal:AddPathCornerPortalIn(entity)
    if self.currentTriggerPortalName ~= nil and string.len(entity:GetName()) > 0 then
        self.arPortalNames[self.currentTriggerPortalName] = entity:GetName()
    end
end

function CRetardPortal:OnPortalTouch(portal, unit)
    DebugPrint(self.currentTriggerPortalName)
    if unit:HasModifier("modifier_retard_portal_ignore") then
        return
    end
    DebugPrint(self.arUnitsInPortal[unit])
    --if self.arUnitsInPortal[unit] ~= nil then
    --    self.arUnitsInPortal[unit] = nil
   --     return
   -- end
    local wws
    if string.match(portal:GetName(),"tp_in") then
        wws = tostring("tp_out" .. string.match(portal:GetName(),"%d+"))
    elseif string.match(portal:GetName(),"tp_out") then
        wws = tostring("tp_in" .. string.match(portal:GetName(),"%d+"))
    end
    
   -- if self.closedPortal[unit] == nil then 
    --    self.closedPortal[unit] = ""
   -- end
	DebugPrint(wws)

    local portalOut = Entities:FindByName(nil, wws) --строка ищет как раз таки нашу точку pnt1
    
    if portalOut ~= nil  then -- and tostring(self.closedPortal[unit]) ~= wws
        
        self.arUnitsInPortal[unit] = true
        
        self:CreatePortalParticle(unit)
        FindClearSpaceForUnit(unit, portalOut:GetOrigin(), true)
        unit:Stop()
        --CAddonRetardGame:SetPlayerCameraTargetUnit(unit)
        
        self:CreatePortalParticle(unit)
        --self.closedPortal[unit] = portal:GetName()
       -- DebugPrint("self.closedPortal[unit] 2222   " .. self.closedPortal[unit])
    end
end

function CRetardPortal:CreatePortalParticle(unit)
    local particle = ParticleManager:CreateParticle("particles/econ/events/league_teleport_2014/teleport_end_ground_flash_league.vpcf", PATTACH_ABSORIGIN, unit)
    ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
end

