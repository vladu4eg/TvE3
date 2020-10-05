Stats = Stats or {}
local dedicatedServerKey = GetDedicatedServerKeyV2("1")
local isTesting = IsInToolsMode() and false
Stats.server =  "https://troll-elves.xyz/test/"
local count = 0

function Stats.SubmitMatchData(winner,callback)
	if not isTesting then
		if GameRules:IsCheatMode() then return end
	end
				--playerData.team = PlayerResource:GetTeam(pID) or 0
			--playerData.team = playerData.team == DOTA_TEAM_GOODGUYS and 2 or playerData.team == DOTA_TEAM_BADGUYS and 3 or 0
			--playerData.type = PlayerResource:GetType(pID)
			--playerData.goldGained = PlayerResource:GetGoldGained(pID) or 0
			--playerData.goldGiven = PlayerResource:GetGoldGiven(pID) or 0
			--playerData.lumberGained = PlayerResource:GetLumberGained(pID) or 0
			--playerData.lumberGiven = PlayerResource:GetLumberGiven(pID) or 0
			--playerData.kills = PlayerResource:GetKills(pID)
			--playerData.deaths = PlayerResource:GetDeaths(pID)
			--table.insert(data.players,playerData)
	local data = {}
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) then
			count = count + 1
		end
	end
	DebugPrint("Count " .. count)
	if count >= 12 then
		for pID=0,DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) then
				data.MatchID = tostring(GameRules:GetMatchID())
				data.Winner = tostring(PlayerResource:GetTeam(pID))
				--data.duration = GameRules:GetGameTime() - GameRules.startTime
				data.Map = GetMapName()
				local hero = PlayerResource:GetSelectedHeroEntity(pID)
				data.SteamID = tostring(PlayerResource:GetSteamID(pID) or 0)
				if PlayerResource:GetConnectionState(pID) == 2 then
					if PlayerResource:GetTeam(pID) == winner then
						if hero:IsTroll() then
							data.Score = "10" 
						elseif hero:IsElf() and PlayerResource:GetDeaths(pID) == 0 then 
							data.Score = "5" 
						end
					elseif PlayerResource:GetTeam(pID) ~= winner then
						if hero:IsTroll() then
							data.Score = "-5"
						elseif hero:IsElf() then 
							data.Score = "-2" 
						end
					end 
					if hero:IsAngel() or hero:IsWolf() then 
						data.Score = "-10"
					elseif hero:IsElf() and PlayerResource:GetDeaths(pID) > 0 then 
						data.Score = "-2" 
					end
				elseif PlayerResource:GetConnectionState(pID) ~= 2 then
					data.Score = "-25"
				end
				data.Key = dedicatedServerKey
				Stats.SendData(data,callback)
			end 
		end
	end
end


function Stats.SendData(data,callback)
	local req = CreateHTTPRequest("POST",Stats.server)
	local encData = json.encode(data)
	DebugPrint("***********************************************")
	DebugPrint(Stats.server)
	DebugPrint(encData)
	DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		DebugPrint("***********************************************")
		DebugPrint(res.Body)
		DebugPrint("Response code: " .. res.StatusCode)
		DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			DebugPrint("Error connecting")
			return
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end

function Stats.RequestData(pId, callback)
	local req = CreateHTTPRequest("GET",Stats.server .. tostring(PlayerResource:GetSteamID(pId)))
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		DebugPrint(obj.steamID)
		DebugPrint("***********************************************")
		local message = PlayerResource:GetPlayerName(pId) .. " has a Elf score: " .. obj[1].score .. "; Troll score: " .. obj[2].score
		GameRules:SendCustomMessage(message, pId, 0)
		return obj
	end)
end

function Stats.RequestDataTop10(idTop, callback)
	local req = CreateHTTPRequest("GET",Stats.server .. "all/" .. idTop)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		DeepPrintTable(obj)
		DebugPrint("***********************************************")
		trollnelves2:OnLoadTop(obj,idTop)
		---CustomNetTables:SetTableValue("stats", tostring( pId ), { steamID = obj.steamID, score = obj.score })
		return obj
		
	end)
end

function Stats.RequestVip(pID, steam, callback)
	local parts = {}
	local req = CreateHTTPRequest("GET",Stats.server .. "vip/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		DeepPrintTable(obj)
		DebugPrint("***********************************************")
		for id = 1, 17 do
			parts[id] = "nill"
		end
		CustomNetTables:SetTableValue("Particles_Tabel",tostring(pID),parts)
		DebugPrint("dateos " ..  GetSystemDate())
		for id=1,#obj do
			parts[obj[id].num] = "normal"
			CustomNetTables:SetTableValue("Particles_Tabel",tostring(pID),parts)
		end
		return obj
		
	end)
end

function Stats.GetVip(data,callback)
	if not isTesting then
		if GameRules:IsCheatMode() then return end
	end
	local req = CreateHTTPRequest("POST",Stats.server)
	local encData = json.encode(data)
	DebugPrint("***********************************************")
	DebugPrint(Stats.server)
	DebugPrint(encData)
	DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		DebugPrint("***********************************************")
		DebugPrint(res.Body)
		DebugPrint("Response code: " .. res.StatusCode)
		DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			DebugPrint("Error connecting")
			return
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end