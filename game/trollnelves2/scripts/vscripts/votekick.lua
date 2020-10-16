require('settings')
local votes = {}
local countVote = {}
local checkVote
local lastKickTime = {}

function VotekickStart(eventSourceIndex, event)
	local playerName
	if event.target ~= nil then
		local hero = PlayerResource:GetSelectedHeroEntity(event.target)
		local ctrHeroID = PlayerResource:GetSelectedHeroEntity(event.casterID)
		local team = hero:GetTeamNumber()
		if ctrHeroID:IsTroll() and team == DOTA_TEAM_BADGUYS  then
			playerName = PlayerResource:GetPlayerName(event.target)
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.casterID), "show_votekick_options", {["name"] = playerName, ["id"] = event.target})
		end
		if ctrHeroID:IsElf() and team == DOTA_TEAM_GOODGUYS and PlayerResource:GetConnectionState(event.target) == 2 
			and (lastKickTime[event.target] == nil or lastKickTime[event.target] + 240 < GameRules:GetGameTime())
			and (checkVote == nil or checkVote + 40 < GameRules:GetGameTime()) then	
			local elfCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
			for i=0, elfCount do
				local pID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
				if PlayerResource:GetSelectedHeroEntity(pID) ~= nil then 
					local hero2 = PlayerResource:GetSelectedHeroEntity(pID)
					if pID ~= event.target and hero2:IsElf() and PlayerResource:GetConnectionState(pID) == 2 then
						if countVote[event.target] == nil then
							countVote[event.target] = 0
						end 
						local text = PlayerResource:GetPlayerName(event.casterID)
						countVote[event.target] = countVote[event.target] + 1
						playerName = PlayerResource:GetPlayerName(event.target)
						lastKickTime[event.target] = GameRules:GetGameTime()
						checkVote = GameRules:GetGameTime()
						text = text .. " launched a vote against " .. PlayerResource:GetPlayerName(event.target)
						GameRules:SendCustomMessageToTeam("<font color='#FF0000'>"  .. text  .. "</font>" , team, 0, 0)
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "show_votekick_options", {["name"] = playerName, ["id"] = event.target,["casterID"] = pID} )
						
					end
				end
			end
			elseif (lastKickTime[event.target] == nil or lastKickTime[event.target] + 240 > GameRules:GetGameTime())
			and (checkVote == nil or checkVote + 40 < GameRules:GetGameTime()) then
			local timeLeftKick = math.ceil(lastKickTime[event.target] + 240 - GameRules:GetGameTime())
			SendErrorMessage(event.casterID, "The following voting will be available in "..timeLeftKick.." seconds!")
			else 
			SendErrorMessage(event.casterID, "You can not run a double vote! Please wait 40 seconds.")
		end 
	end	
end

function VoteKick(eventSourceIndex, event)
	if votes[ event.playerID1 ] == nil then
		votes[ event.playerID1 ] = 0
	end 
	votes[ event.playerID1 ] = votes[ event.playerID1 ] + event.vote;
	local hero = PlayerResource:GetSelectedHeroEntity(event.playerID1)
	local team = hero:GetTeamNumber()
	if votes[ event.playerID1 ] == 1 and team == DOTA_TEAM_BADGUYS then
		UTIL_Remove(hero)
		SendToServerConsole("kick " .. PlayerResource:GetPlayerName(event.playerID1))
		votes[ event.playerID1 ] = 0
	end
	if PlayerResource:GetSteamAccountID(event.casterID) == 201083179 or PlayerResource:GetSteamAccountID(event.casterID) == 990264201 or PlayerResource:GetSteamAccountID(event.casterID) == 337000240 or PlayerResource:GetSteamAccountID(event.casterID) == 183899786 then
		votes[ event.playerID1 ] = votes[ event.playerID1 ] + 1
	end
	local text = "Vote: " .. votes[ event.playerID1 ] .. "; Count Player: " .. countVote[event.playerID1] .. "; Percent: " .. votes[ event.playerID1 ]/countVote[event.playerID1] .. "; Need perc.: 0.78; Min player: 8" 
	GameRules:SendCustomMessageToTeam("<font color='#FF0000'>" ..  text  .. "</font>", team, 0, 0)
	if team == DOTA_TEAM_GOODGUYS then
		Timers:CreateTimer(35.0, function() 
			if (votes[ event.playerID1 ]/countVote[event.playerID1]) >= PERC_KICK_PLAYER and countVote[event.playerID1] >= 8
				and PlayerResource:GetSteamAccountID(event.playerID1) ~= 201083179 and PlayerResource:GetSteamAccountID(event.playerID1) ~= 990264201 
				and PlayerResource:GetSteamAccountID(event.playerID1) ~= 337000240 and PlayerResource:GetSteamAccountID(event.playerID1) ~= 183899786 then
				hero:ForceKill(true)
				if hero.units ~= nil then
					for i=1,#hero.units do
						if hero.units[i] and not hero.units[i]:IsNull() then
							local unit = hero.units[i]
							unit:ForceKill(false)
						end
					end
				end
				UTIL_Remove(hero)
				SendToServerConsole("kick " .. PlayerResource:GetPlayerName(event.playerID1))
			end
			votes[ event.playerID1 ] = 0
			countVote[event.playerID1] = 0
		end);
	end 
end