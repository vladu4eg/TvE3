if top == nil then
	DebugPrint( 'top' )
	_G.top = class({})
end

PlaysTopList = {}
WinsTopList = {}
HardWinsTopList = {}

PlaysTopListEvent = {}

function top:UpdateTops()
    print("UpdateTops")
    CustomGameEventManager:Send_ServerToAllClients( "UpdateTopPlays", PlaysTopList)
    CustomGameEventManager:Send_ServerToAllClients( "UpdateTopWins", WinsTopList)
    CustomGameEventManager:Send_ServerToAllClients( "UpdateTopHardWins", HardWinsTopList)
	CustomGameEventManager:Send_ServerToAllClients( "UpdateTopPlaysEvent", PlaysTopListEvent)
end

function top:OnLoadTop(list, idTop)
	if list ~= nil then
		if list[1] ~= nil then
			for i=1,#list do
				local id = ""
				local col = ""
				local kv =
				{
					id = list[i].steamID,
					col = list[i].score
				}
				if idTop == "1" then
					table.insert(PlaysTopList,kv)
					elseif idTop == "2" then
					table.insert(WinsTopList,kv)
					elseif idTop == "3" then
					table.insert(HardWinsTopList,kv)
				elseif idTop == "4" then
					table.insert(PlaysTopListEvent,kv)
				end
			end
		end
	end
    top:UpdateTops()
end
