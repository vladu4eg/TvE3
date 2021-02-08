if SelectPets == nil then
    _G.SelectPets = class({})
end
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
			end					
		end
		else
        Pets.DeletePet( info )
	end
end

function SelectPets:SetPets()
	local pplc = PlayerResource:GetPlayerCount()
	for i=0,pplc-1 do
		if GameRules.PetsDefaults[i] ~= nil and GameRules.PetsDefaults[i] ~= "" and PlayerResource:GetConnectionState(i) == 2 then
				local pets = CustomNetTables:GetTableValue("Pets_Tabel",tostring(i))
				--Say(nil,"text here", false)
				--GameRules:SendCustomMessage("<font color='#58ACFA'> использовал эффект </font>"..info.name.."#partnote".." test", 0, 0)
				local arr = {
					i,
					PlayerResource:GetPlayerName(i),
					GameRules.PetsDefaults[i],
					PlayerResource:GetSelectedHeroName(i)
				}
				local info = {}
				info.PlayerID = i
				info.hero = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
				info.part = GameRules.PetsDefaults[i]
				CustomGameEventManager:Send_ServerToAllClients( "UpdatePetsUI", arr)
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "SetSelectedPets", arr)
				Pets.DeletePet( info )
				Pets.CreatePet( info,  info.part)
				--local pets = CustomNetTables:GetTableValue("Pets_Tabel",tostring(i))
				--local npc = PlayerResource:GetSelectedHeroEntity(i)
				--if pets["11"] == "normal" and not EVENT_START then
				--	SetModelVip(npc)
				--end
		end
	end
end

function SelectPets:SetDefaultPets(event)
    local player = PlayerResource:GetPlayer(event.PlayerID)
    if player.parttimerok == nil then player.parttimerok = true end
    if player.parttimerok == true then
        player.parttimerok = false
        Timers:CreateTimer(120, function()
            player.parttimerok = true
            CustomGameEventManager:Send_ServerToPlayer( player, "DefaultButtonReadyPets", {})
		end)
		local data = {}
		if event.part ~=  nil then
			DebugPrint("no save")
			data.SteamID = tostring(PlayerResource:GetSteamID(event.PlayerID))
			data.Num = tostring(event.part)
			data.TypeDonate = "2"
			Stats.GetVip(data, callback)
		end
	end
end		
