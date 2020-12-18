if SelectPets == nil then
    _G.SelectPets = class({})
end
local dedicatedServerKey = GetDedicatedServerKeyV2("1")
local isTesting = IsInToolsMode() and false
Stats.server = "https://troll-elves.xyz/test/" -- "https://localhost:5001/test/" --
defaultpart = {}

require('settings')

function SelectPets:SelectPets(info)
    if info.offp == 0 then
        local parts = CustomNetTables:GetTableValue("Pets_Tabel",tostring(info.PlayerID))
        if parts ~= nil then
            if parts[info.part] ~= "nill" and parts[info.part] ~= nil then
				
                local arr = {
                    info.PlayerID,
                    PlayerResource:GetPlayerName(info.PlayerID),
                    info.part,
                    PlayerResource:GetSelectedHeroName(info.PlayerID)
				}
				
                CustomGameEventManager:Send_ServerToAllClients( "UpdatePetsUI", arr)

				info.hero = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
				
                Pets.DeletePet( info )
				Pets.CreatePet( info,  info.part)
                PlayerResource:GetSelectedHeroEntity(info.PlayerID):AddNewModifier(PlayerResource:GetSelectedHeroEntity(info.PlayerID), PlayerResource:GetSelectedHeroEntity(info.PlayerID), "part_mod", {part = info.part})
			end					
		end
		else
        Pets.DeletePet( info )
	end
end

function SelectPets:SetPart()
	local pplc = PlayerResource:GetPlayerCount()
	for i=0,pplc-1 do
		if GameRules.PartDefaults[i] ~= nil and GameRules.PartDefaults[i] ~= "" and PlayerResource:GetConnectionState(i) == 2 then
			if PlayerResource:GetSelectedHeroEntity(i):FindModifierByName("part_mod") == nil then
				local parts = CustomNetTables:GetTableValue("Pets_Tabel",tostring(i))
				--Say(nil,"text here", false)
				--GameRules:SendCustomMessage("<font color='#58ACFA'> использовал эффект </font>"..info.name.."#partnote".." test", 0, 0)
				local arr = {
					i,
					PlayerResource:GetPlayerName(i),
					GameRules.PartDefaults[i],
					PlayerResource:GetSelectedHeroName(i)
				}
				
				CustomGameEventManager:Send_ServerToAllClients( "UpdatePetsUI", arr)
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "SetSelectedPets", arr)
				PlayerResource:GetSelectedHeroEntity(i):AddNewModifier(PlayerResource:GetSelectedHeroEntity(i), PlayerResource:GetSelectedHeroEntity(i), "part_mod", {part = GameRules.PartDefaults[i]})
				local parts = CustomNetTables:GetTableValue("Pets_Tabel",tostring(i))
				local npc = PlayerResource:GetSelectedHeroEntity(i)
				if parts["11"] == "normal" and not EVENT_START then
					SetModelVip(npc)
				end
			end
		end
	end
end

function SelectPets:SetDefaultPart(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
    if player.parttimerok == nil then player.parttimerok = true end
    if player.parttimerok == true then
        player.parttimerok = false
        Timers:CreateTimer(120, function()
            player.parttimerok = true
            CustomGameEventManager:Send_ServerToPlayer( player, "DefaultButtonReady", {})
		end)
		local data = {}
		if event.part ~=  nil then
			DebugPrint("no save")
			data.SteamID = tostring(PlayerResource:GetSteamID(event.PlayerID))
			data.Num = tostring(event.part)
			Stats.GetVip(data, callback)
		end
	end
end		
