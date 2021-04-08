if chatcommand == nil then
	DebugPrint( 'chatcommand' )
	_G.chatcommand = class({})
end
local lastCommandChat = {}

function chatcommand:OnPlayerChat(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.playerid)
	if event.text == "!rank" and GameRules:GetGameTime() - GameRules.startTime > 60 and 
		(lastCommandChat[event.playerid] == nil or lastCommandChat[event.playerid] + 120 < GameRules:GetGameTime() - GameRules.startTime) then
		local message =  PlayerResource:GetPlayerName(event.playerid) .. " has a Elf score: " .. GameRules.scores[event.playerid].elf .. "; Troll score: " .. GameRules.scores[event.playerid].troll
		GameRules:SendCustomMessage("<font color='#00FF80'>" ..  message ..  "</font>", event.playerid, 0)		
		lastCommandChat[event.playerid] = GameRules:GetGameTime() 
		elseif event.text == "!bonus" and GameRules:GetGameTime() - GameRules.startTime > 60 and 
		(lastCommandChat[event.playerid] == nil or lastCommandChat[event.playerid] + 120 < GameRules:GetGameTime() - GameRules.startTime) then
		if GameRules.BonusPercent  > 0.77 then
			GameRules.BonusPercent = 0.77
		end
		local text = "Total rating bonus for this match " .. (GameRules.BonusPercent * 100) .. "%!"
		GameRules:SendCustomMessage("<font color='#00FF80'>" .. text ..  "</font>" , 1, 1)
		lastCommandChat[event.playerid] = GameRules:GetGameTime() 
		elseif event.text == "!list" and PlayerResource:GetSteamAccountID(event.playerid) == 201083179 then
		for pID = 0,DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) then
				local text = "Nick: " .. PlayerResource:GetPlayerName(pID) .. " pID: " .. pID
				GameRules:SendCustomMessage(text, 1, 1)
			end
		end
		elseif string.match(event.text,"%D+") == "!kick" and PlayerResource:GetSteamAccountID(event.playerid) == 201083179 then
		local id_kick = tonumber(string.match(event.text,"%d+"))
		local hero_kick = PlayerResource:GetSelectedHeroEntity(id_kick)
		if hero:GetTeamNumber() == hero_kick:GetTeamNumber() then
			hero_kick:ForceKill(true)
			if hero_kick.units ~= nil then
				for i=1,#hero_kick.units do
					if hero_kick.units[i] and not hero_kick.units[i]:IsNull() then
						local unit = hero_kick.units[i]
						unit:ForceKill(false)
					end
				end
			end
			UTIL_Remove(hero_kick)
			SendToServerConsole("kick " .. PlayerResource:GetPlayerName(id_kick))
		end
		elseif string.match(event.text,"%D+") == "!kill" and PlayerResource:GetSteamAccountID(event.playerid) == 201083179 then
		local id_kick = tonumber(string.match(event.text,"%d+"))
		local hero_kick = PlayerResource:GetSelectedHeroEntity(id_kick)
		hero_kick:ForceKill(true)
		elseif event.text == "!drop" and PlayerResource:GetSteamAccountID(event.playerid) == 201083179 then
		local spawnPoint = hero:GetAbsOrigin()	
		local newItem = CreateItem("item_vip", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		local dropRadius = RandomFloat( 50, 100 )
		newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
		elseif string.match(event.text,"%D+") == "!delete" and PlayerResource:GetSteamAccountID(event.playerid) == 201083179 then
		local id_kick = tonumber(string.match(event.text,"%d+"))
		local hero_kick = PlayerResource:GetSelectedHeroEntity(id_kick)
		if hero:GetTeamNumber() == hero_kick:GetTeamNumber() then
			if hero_kick.units ~= nil then
				for i=1,#hero_kick.units do
					if hero_kick.units[i] and not hero_kick.units[i]:IsNull() then
						local unit = hero_kick.units[i]
						unit:ForceKill(false)
					end
				end
			end
		end
		elseif event.text == "!event" and GameRules:GetGameTime() - GameRules.startTime > 60 and 
		(lastCommandChat[event.playerid] == nil or lastCommandChat[event.playerid] + 120 < GameRules:GetGameTime() - GameRules.startTime) then
		local steamID = tostring(PlayerResource:GetSteamID(event.playerid))
		local pID = tonumber(event.playerid)
		DebugPrint(pID)
		Stats.RequestEvent(pID, steamID, callback)
		lastCommandChat[event.playerid] = GameRules:GetGameTime() 
		elseif event.text == "!test" then
		if GameRules:IsCheatMode() then 
			GameRules.test = true
		end
		elseif event.text == "!fps" then
			GameRules.PlayersFPS[event.playerid] = true
		elseif event.text == "!unfps" then
			GameRules.PlayersFPS[event.playerid] = false
		elseif event.text == "!birthday" and (PlayerResource:GetSteamAccountID(event.playerid) == 201083179 
		or PlayerResource:GetSteamAccountID(event.playerid) == 337000240 
		or PlayerResource:GetSteamAccountID(event.playerid) == 183899786 ) then
		local spawnPoint = hero:GetAbsOrigin()	
		local newItem = CreateItem("item_event_birthday", nil, nil )
		local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
		local dropRadius = RandomFloat( 50, 100 )
		newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
		--elseif event.text == "!xp" then
		--	GameRules:SendCustomMessage("<font color='#00FF80'>" .. hero:GetCurrentXP() ..  "</font>" , 1, 1)
		--elseif event.text == "!xpup" then
		--	hero:AddExperience(50,DOTA_ModifyXP_Unspecified,false,false)
		--elseif event.text == "!map" then
				-- Must set the map name prior to getting the neighboring room height difference
				--local mapList = EncounterData.szMapNames
				--if GameRules.Aghanim:IsMapFlipped() and EncounterData.szFlippedMapNames ~= nil then
				--	mapList = EncounterData.szFlippedMapNames
				--end					
				--local szMapName = mapList[ self:RoomRandomInt( 1, #mapList ) ]
				--local ExitRoom.szMapName = szMapName
		--DOTA_SpawnMapAtPosition( "winter", Vector(0,0,100), false, nil, nil, nil )
	
	
	
	--elseif event.text == "!fps" then
	--	GameRules.PlayersFPS[event.playerid] = true
	--	if hero.units ~= nil then
	--		for i=1,#hero.units do
	--			if hero.units[i] and not hero.units[i]:IsNull() then
	--				local unit = hero.units[i]
	--				DebugPrint(unit:GetUnitName())
	--				local dataTable = { entityIndex = unit:GetEntityIndex() }
	--				local player = hero:GetPlayerOwner()
	--				if player then
	--					if string.match(hero.units[i]:GetUnitName(),"mine") then
	--						CustomGameEventManager:Send_ServerToPlayer(player, "gold_gain_stop", dataTable)
	--					elseif string.match(hero.units[i]:GetUnitName(),"wisp") then 
	--						CustomGameEventManager:Send_ServerToPlayer(player, "tree_wisp_harvest_stop", dataTable)
	--					end
	--				end
	--			end
	--		end
	--	end
	--elseif event.text == "!unfps" then
	--	GameRules.PlayersFPS[event.playerid] = false
	--	if hero.units ~= nil then
	--		for i=1,#hero.units do
	--			if hero.units[i] and not hero.units[i]:IsNull() then
	--				local unit = hero.units[i]
	--				DebugPrint(unit:GetUnitName())
	--				local dataTable = { entityIndex = unit:GetEntityIndex() }
	--				local player = hero:GetPlayerOwner()
	--				if player then
	--					if string.match(hero.units[i]:GetUnitName(),"mine") then
	--						CustomGameEventManager:Send_ServerToPlayer(player, "gold_gain_start", dataTable)
	--					elseif string.match(hero.units[i]:GetUnitName(),"wisp") then
	--						CustomGameEventManager:Send_ServerToPlayer(player, "tree_wisp_harvest_start", dataTable)
	--					end
	--				end
	--			end
	--		end
	--	end
	--elseif event.text  ==  "stats"  then
	--local playerStatsScore = CustomNetTables:GetTableValue("scorestats",tostring(event.playerid)); 
	--CustomNetTables:SetTableValue("scorestats", tostring(event.playerid), { playerScoreElf = tostring(GameRules.scores[event.playerid].elf), playerScoreTroll = tostring(GameRules.scores[event.playerid].troll) })
	--DebugPrint(GameRules.scores[event.playerid].elf)
	--DebugPrint(GameRules.scores[event.playerid].troll)
	--DebugPrintTable("playerStatsScore   "  ..  playerStatsScore)
	--elseif event.text == "blink" then 
	--	hero:ClearInventoryCM()
	--elseif event.text == "test" then
	--local data = {}
	--data.SteamID = tostring(PlayerResource:GetSteamID(event.playerid))
	--data.Num = "2"
	--data.Srok = "01/09/2020"
	--Stats.GetVip(data, callback)
	--http.SendRequest("post", "/test", "228")
	
	--elseif event.text == "get" then
	--Stats.RequestDataTop10(callback)
	--local stats = CustomNetTables:GetTableValue( "top10", "test" )
	--DebugPrint(stats)
	--DebugPrintTable(stats)
	--trollnelves2:OnLoadTop(stats.steamID, 1)
	--elseif event.text == "test_r" then
	--GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
	--Stats.SubmitMatchData(DOTA_TEAM_BADGUYS, callback)
	--GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
	--elseif event.text == "test" then
	--local hero = PlayerResource:GetSelectedHeroEntity(event.playerid)
	--hero:RemoveDesol2()
end

end