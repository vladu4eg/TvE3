
function FlagStart(eventSourceIndex, event)
	local playerName = "nul"
	DebugPrint("FlagStart")
	if event.target ~= nil then
		local hero = PlayerResource:GetSelectedHeroEntity(event.target)
		local casterHeroID = PlayerResource:GetSelectedHeroEntity(event.casterID)		
		if casterHeroID:IsElf() and hero:IsElf() and PlayerResource:GetConnectionState(event.target) == 2 and GameRules:GetGameTime() - GameRules.startTime > 1 and GameRules.PlayersBase[event.casterID] ~= nil then	
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.target), "show_flag_options", {["name"] = playerName, ["id"] = event.target,["casterID"] = event.casterID} )
			DebugPrint("FlagStart SEND")
			elseif GameRules.PlayersBase[event.casterID] == nil then 
			SendErrorMessage(event.casterID, "You have no bases.")
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
					unit:ForceKill(false)
				end
			end
		end
		hero:RemoveAbility("flag")
	else
	text = PlayerResource:GetPlayerName(event.target) .. " canceled the request for a private base."
	GameRules:SendCustomMessageToTeam("<font color='#FF0000'>"  .. text  .. "</font>" , team, 0, 0)
end
end