if CTvESpeechBubble == nil then
    CTvESpeechBubble = class({})
    CTvESpeechBubble.speechList = {}

    _G['CTvESpeechBubble'] = CTvESpeechBubble
end

function CTvESpeechBubble:Init()

    local contentFileName = "speech_bubble/speech_bubble_tag"
    self.speechList = trollnelves2:LoadStaticContent(contentFileName)

    if self.speechList ~= nil then
        for k in pairs(self.speechList) do
            self.speechList[k].players = {}
        end

        ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(CTvESpeechBubble, 'onPlayerPickHero'), self)
        ListenToGameEvent('player_reconnected', Dynamic_Wrap(CTvESpeechBubble, 'onPlayerReconnect'), self)
    else
        print("SpeechBubble content file name `" .. contentFileName .. "` not found")
    end

end

function CTvESpeechBubble:SetVisible(activator, name, visible)
    DebugPrint("CTvESpeechBubble:SetVisible")
    if string.len(name) == 0 then
        return
    end
    DebugPrint(name)
    local speech = self.speechList[name]
    if speech ~= nil then
        local playerId = activator:GetPlayerOwnerID()
        if playerId >= 0 and speech.players[playerId] ~= nil then
            speech.players[playerId]:SetData({ showed = visible })
        end
    end

end

function CTvESpeechBubble:onPlayerReconnect(data)

    local playerId = data.PlayerID
    if playerId >= 0 then
        for k in pairs(self.speechList) do
            CTvESpeechBubble:Create(playerId, k)
        end
    end

end

function CTvESpeechBubble:onPlayerPickHero(data)

    local npc = EntIndexToHScript(data.heroindex)
    local playerId = npc:GetPlayerOwnerID()
    if playerId >= 0 then
        for k in pairs(self.speechList) do
            if self.speechList[k].players[playerId] == nil then
                CTvESpeechBubble:Create(playerId, k)
            end
        end
    end

end

function CTvESpeechBubble:Create(playerId, name)

    local speech = self.speechList[name]
    if speech ~= nil then

        local entity
        repeat
            entity = Entities:FindByName(entity, name)
        until entity == nil or entity:GetClassname() ~= 'trigger_dota'

        if entity ~= nil then

            local conf = {
                layout = "file://{resources}/layout/custom_game/worldpanels/speechbubble.xml",
                entity = entity,
                data = {
                    showed = false,
                    text = speech.text
                }
            }

            if speech.top ~= nil then
                conf.entityHeight = speech.top
            end

            if speech.width ~= nil then
                conf.data.width = speech.width
            end

            speech.players[playerId] = WorldPanels:CreateWorldPanel(playerId, conf)

        end

    end

end

CTvESpeechBubble:Init()