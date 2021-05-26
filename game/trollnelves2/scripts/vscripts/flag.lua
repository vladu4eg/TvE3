local lastFlagTime = {}
local countFlag = {}


function FlagStart(eventSourceIndex, event)
	DebugPrint("FlagStart")
	if event.target ~= nil then
		local hero = PlayerResource:GetSelectedHeroEntity(event.target)
		local casterHero = PlayerResource:GetSelectedHeroEntity(event.casterID)	
		local playerName = PlayerResource:GetPlayerName(event.casterID)
		if casterHero:IsElf() and hero:IsElf() and PlayerResource:GetConnectionState(event.target) == 2 and GameRules.PlayersBase[event.casterID] ~= nil and countFlag[event.casterID] == nil
			and (GameRules:GetGameTime() - GameRules.startTime < 120 
			or  (lastFlagTime[event.target] == nil or lastFlagTime[event.target] + 240 < GameRules:GetGameTime()) )
			and (lastFlagTime[event.caster] == nil or lastFlagTime[event.caster] + 40 < GameRules:GetGameTime()) then	
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.target), "show_flag_options", {["name"] = playerName, ["id"] = event.target,["casterID"] = event.casterID} )
			DebugPrint("FlagStart SEND")
			if GameRules:GetGameTime() - GameRules.startTime > 120 then
				lastFlagTime[event.target] = GameRules:GetGameTime()
			end
		elseif GameRules.PlayersBase[event.casterID] == nil then 
			SendErrorMessage(event.casterID, "You have no bases.")
		elseif countFlag[event.casterID] ~= nil then
			SendErrorMessage(event.casterID, "You can only invite 1 person.")
		else 
			SendErrorMessage(event.casterID, "You can't send an invitation so often.")
		end
	end	
end

function FlagGive(eventSourceIndex, event)
	DebugPrint("event.vote " .. event.vote)
	local hero = PlayerResource:GetSelectedHeroEntity(event.playerID1)
	if event.vote == 1 then
        DebugPrint("GameRules.PlayersBase[event.casterID] FlagGive " .. GameRules.PlayersBase[event.casterID])
        DebugPrint("event.casterID FlagGive " .. event.casterID)
		GameRules.PlayersBase[event.playerID1] = GameRules.PlayersBase[event.casterID]
		if hero.units ~= nil then
			for i=1,#hero.units do
				if hero.units[i] and not hero.units[i]:IsNull() and hero.units[i]:GetUnitName() == "flag" then
					local unit = hero.units[i]
					unit:ForceKill(true)
				end
			end
		end
		hero:RemoveAbility("build_flag")
		countFlag[event.playerID1] = GameRules.PlayersBase[event.casterID]
		countFlag[event.casterID] = GameRules.PlayersBase[event.casterID]
		text = PlayerResource:GetPlayerName(event.target) .. " accepted the invitation to private the base."
		GameRules:SendCustomMessageToTeam("<font color='#FF0000'>"  .. text  .. "</font>" , hero:GetTeamNumber(), 0, 0)
	else
	text = PlayerResource:GetPlayerName(event.target) .. " canceled the request for a private base."
	GameRules:SendCustomMessageToTeam("<font color='#FF0000'>"  .. text  .. "</font>" , hero:GetTeamNumber(), 0, 0)
end
end