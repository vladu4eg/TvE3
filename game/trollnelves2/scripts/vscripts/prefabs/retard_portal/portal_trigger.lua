
require("prefabs/retard_portal/portal_class")

function RetardPortalInEnter(trigger)
    DebugPrint("TELEPORT")
    CRetardPortal:OnPortalTouch(trigger.caller, trigger.activator)
end

CRetardPortal:AddTriggerPortalIn(thisEntity)
