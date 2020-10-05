require('top')


Stats = Stats or {}
local dedicatedServerKey = GetDedicatedServerKeyV2("1")
local isTesting = IsInToolsMode() and false
Stats.server = "https://troll-elves.xyz/test/" -- "https://localhost:5001/test/" --
local count = 0

function Stats.SubmitMatchData(winner,callback)
	if not isTesting then
		if GameRules:IsCheatMode() then return end
	end
	local data = {}
	local koeff = string.match(GetMapName(),"%d+") or 1
	local maxGoldId = 0
	local maxGoldSum = 0
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) then
			count = count + 1
			if GameRules.Bonus[pID] == nil then
				GameRules.Bonus[pID] = 0
			end
			if GameRules:GetGameTime() - GameRules.startTime <  600 then -- 10 min
				GameRules.Bonus[pID] = GameRules.Bonus[pID] + 0
				elseif GameRules:GetGameTime() - GameRules.startTime >= 600 and GameRules:GetGameTime() - GameRules.startTime < 2400 then -- 10-40min
				GameRules.Bonus[pID] = GameRules.Bonus[pID] + 1
				elseif GameRules:GetGameTime() - GameRules.startTime >= 2400 and GameRules:GetGameTime() - GameRules.startTime <  3600 then -- 60 min
				GameRules.Bonus[pID] = GameRules.Bonus[pID] + 3
				elseif GameRules:GetGameTime() - GameRules.startTime >= 3600 then
				GameRules.Bonus[pID] = GameRules.Bonus[pID] + 5
			end
			if PlayerResource:GetDeaths(pID) >= 10 then 
				GameRules.Bonus[pID] = GameRules.Bonus[pID] - 2
			end 
		end
	end
	if GameRules.BonusPercent  >  0.77 then
		GameRules.BonusPercent = 0.77
	end
	if count >= 12 then
		for pID=0,DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) then
				data.MatchID = tostring(GameRules:GetMatchID())
				data.Team = tostring(PlayerResource:GetTeam(pID))
				--data.duration = GameRules:GetGameTime() - GameRules.startTime
				data.Map = GetMapName()
				local hero = PlayerResource:GetSelectedHeroEntity(pID)
				data.SteamID = tostring(PlayerResource:GetSteamID(pID) or 0)
				data.Time = tostring(tonumber(GameRules:GetGameTime() - GameRules.startTime)/60 or 0)
				data.GoldGained = tostring(PlayerResource:GetGoldGained(pID)/1000 or 0)
				data.GoldGiven = tostring(PlayerResource:GetGoldGiven(pID)/1000 or 0)
				data.LumberGained = tostring(PlayerResource:GetLumberGained(pID)/1000 or 0)
				data.LumberGiven = tostring(PlayerResource:GetLumberGiven(pID)/1000 or 0)
				data.Kill = tostring(PlayerResource:GetKills(pID) or 0)
				data.Death = tostring(PlayerResource:GetDeaths(pID) or 0)
				data.Type = tostring(PlayerResource:GetType(pID))
				data.Nick = tostring(PlayerResource:GetPlayerName(pID))
				data.GPS = tostring(tonumber(data.GoldGained)/tonumber(GameRules:GetGameTime() - GameRules.startTime))
				data.LPS = tostring(tonumber(data.LumberGained)/tonumber(GameRules:GetGameTime() - GameRules.startTime))
				
				data.GetScoreBonus = tostring(PlayerResource:GetScoreBonus(pID))
				data.GetScoreBonusRank = tostring(PlayerResource:GetScoreBonusRank(pID))
				data.GetScoreBonusGoldGained = tostring(PlayerResource:GetScoreBonusGoldGained(pID))
				data.GetScoreBonusGoldGiven = tostring(PlayerResource:GetScoreBonusGoldGiven(pID))
				data.GetScoreBonusLumberGained = tostring(PlayerResource:GetScoreBonusLumberGained(pID))
				data.GetScoreBonusLumberGiven = tostring(PlayerResource:GetScoreBonusLumberGiven(pID))
				
				if PlayerResource:GetConnectionState(pID) == 2 then
					if PlayerResource:GetTeam(pID) == winner then
						if hero:IsTroll() then
							data.Score = tostring(math.floor(10/koeff + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
							if tonumber(data.Score) < 1  then
								data.Score = tostring(math.floor(10/koeff))
							end
							elseif hero:IsElf() and PlayerResource:GetDeaths(pID) == 0 then 
							data.Score = tostring(math.floor(10/koeff + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
							if tonumber(data.Score) < 1  then
								data.Score = tostring(1)
							end
						end
						elseif PlayerResource:GetTeam(pID) ~= winner then
						if hero:IsTroll() then
							data.Score = tostring( math.floor(-10 + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
							elseif hero:IsElf() then 
							data.Score = tostring(math.floor(0 + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
						end
					end 
					if hero:IsAngel() or hero:IsWolf() then 
						data.Score = tostring(math.floor(-5 + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
						data.Team = tostring(2)
						elseif hero:IsElf() and PlayerResource:GetDeaths(pID) > 0 then 
						data.Score = tostring(math.floor(-2 + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
					end
					elseif PlayerResource:GetConnectionState(pID) ~= 2 then
					data.Score = tostring(math.floor(-20 + GameRules.Bonus[pID] + tonumber(data.GetScoreBonus)))
				end
				data.Key = dedicatedServerKey
				data.BonusPercent = tostring(GameRules.BonusPercent)
				if tonumber(data.Score) >=  0 then
					data.Score = tostring(math.floor(tonumber(data.Score) *  (1 + GameRules.BonusPercent)))
					else 
					data.Score = tostring(math.floor(tonumber(data.Score) *  (1 - GameRules.BonusPercent)))
				end
				local text = PlayerResource:GetPlayerName(pID) .. " got " .. data.Score
				GameRules.Score[pID] = data.Score
				GameRules:SendCustomMessage(text, 1, 1)
				Stats.SendData(data,callback)
			end 
		end
	end
	SetResourceValues()
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
		GameRules.scores[pId] = {elf = 0, troll = 0}
		GameRules.scores[pId].elf = 0
		GameRules.scores[pId].troll = 0
		local obj,pos,err = json.decode(res.Body)
		DebugPrint(obj.steamID)
		DebugPrint("***********************************************"  .. #obj)
		DebugPrintTable(obj)
		local message = PlayerResource:GetPlayerName(pId) .. " is not in the rating!"
		if #obj > 0 then
			if obj[1].score ~= nil and #obj == 1 then
				if obj[1].team == "2" then 
					message = PlayerResource:GetPlayerName(pId) .. " has a Elf score: " .. obj[1].score
					GameRules.scores[pId].elf = obj[1].score
					GameRules.scores[pId].troll = 0
					elseif obj[1].team == "3" then
					message = PlayerResource:GetPlayerName(pId) .. " has a Troll score: " .. obj[1].score
					GameRules.scores[pId].troll = obj[1].score
					GameRules.scores[pId].elf = 0
				end 
				elseif  #obj == 2 then
				message =  PlayerResource:GetPlayerName(pId) .. " has a Elf score: " .. obj[1].score .. "; Troll score: " .. obj[2].score 
				GameRules.scores[pId].elf = obj[1].score
				GameRules.scores[pId].troll = obj[2].score
			end
		end
		GameRules:SendCustomMessage("<font color='#00FF80'>" ..  message ..  "</font>", pId, 0)
		CustomNetTables:SetTableValue("scorestats", tostring(pId), { playerScoreElf = tostring(GameRules.scores[pId].elf), playerScoreTroll = tostring(GameRules.scores[pId].troll) })
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
		top:OnLoadTop(obj,idTop)
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
		for id = 1, 31 do
			parts[id] = "nill"
		end
		CustomNetTables:SetTableValue("Particles_Tabel",tostring(pID),parts)
		--DebugPrint("dateos " ..  GetSystemDate())
		for id=1,#obj do
			parts[obj[id].num] = "normal"
			CustomNetTables:SetTableValue("Particles_Tabel",tostring(pID),parts)
			if tonumber(obj[id].num) == 3 then
				GameRules.BonusPercent = GameRules.BonusPercent  + 0.02
			end
			if tonumber(obj[id].num) == 8 then
				GameRules.BonusPercent = GameRules.BonusPercent  + 0.1
			end 	
			if tonumber(obj[id].num) == 11 then
				Timers:CreateTimer(120, function()
					GameRules:SendCustomMessage("<font color='#00FFFF '>"  .. PlayerResource:GetPlayerName(pID) .. " thank you for your support!" .. "</font>" ,  0, 0)
				end);
			end 
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

function Stats.RequestVipDefaults(pID, steam, callback)
	local req = CreateHTTPRequest("GET",Stats.server .. "vip/defaults/" .. steam)
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
		DebugPrint("RequestVipDefaults ***********************************************")
		if #obj > 0 then
			if obj[1].num ~= nil then
				GameRules.PartDefaults[pID] = obj[1].num
			end
		end
		return obj
		
	end)
end

function Stats.RequestBonus(pID, steam, callback)
	local req = CreateHTTPRequest("GET",Stats.server .. "bonus/" .. steam)
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
		if #obj > 0 then
			if obj[1].srok ~= nil then
				GameRules.BonusPercent = GameRules.BonusPercent  + 0.1
				Timers:CreateTimer(60, function()
					GameRules:SendCustomMessage("<font color='#00FFFF '>"  .. PlayerResource:GetPlayerName(pID) .. " thanks for the rating bonus!" .. "</font>" ,  0, 0)
				end);
			end
		end
		return obj
		
	end)
end
function Stats.RequestBonusTroll(pID, steam, callback)
	local req = CreateHTTPRequest("GET",Stats.server .. "troll/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	local tmp = 0
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		DeepPrintTable(obj)
		DebugPrint("***********************************************")
		if #obj > 0 then
			if obj[1].chance ~= nil then
				local roll_chance = RandomFloat(0, 100)
				DebugPrint("Donate Chance: ".. tonumber(obj[1].chance))
				DebugPrint("Donate Random: ".. roll_chance)
				GameRules:SendCustomMessage("<font color='#00FFFF '>"  .. PlayerResource:GetPlayerName(pID) .. " thank you for your support! Your chance is increased by " .. obj[1].chance .. "%.".. "</font>" ,  0, 0)
				if roll_chance <= tonumber(obj[1].chance) and PlayerResource:GetConnectionState(pID) == 2 then
					GameRules:SendCustomMessage("<font color='#00FFFF '>"  .. PlayerResource:GetPlayerName(pID) .. " you're in luck!" .. "</font>" ,  0, 0)
					table.insert(GameRules.BonusTrollIDs, pID)
				end		
			end
		end						
	end)
end