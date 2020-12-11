function TvESpeechBubble_Show(trigger)
    CTvESpeechBubble:SetVisible(trigger.activator, trigger.caller:GetName(), true)
end

function TvESpeechBubble_Hide(trigger)
    CTvESpeechBubble:SetVisible(trigger.activator, trigger.caller:GetName(), false)
end