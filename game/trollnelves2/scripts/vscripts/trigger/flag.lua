function TvEPrivate_Touch(trigger)
    --CTvESpeechBubble:SetVisible(trigger.activator, trigger.caller:GetName(), true)
	DebugPrint(trigger.caller:GetEntityIndex())
end

function TvEPrivate_NoTouch(trigger)
    --CTvESpeechBubble:SetVisible(trigger.activator, trigger.caller:GetName(), false)
	
end