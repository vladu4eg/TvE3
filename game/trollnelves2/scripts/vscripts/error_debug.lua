Error_debug = Error_debug or {}
local dedicatedServerKey = GetDedicatedServerKeyV2("1")
local isTesting = IsInToolsMode() and false
Error_debug.server = "https://tve3.us/debug/" -- "https://localhost:5001/test/" --

function Error_debug.SendData(data,callback)
	local req = CreateHTTPRequest("POST",Error_debug.server)
	local encData = json.encode(data)
	DebugPrint("***********************************************")
	DebugPrint(Error_debug.server)
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
			GameRules:SendCustomMessage("Error connecting", 1, 1)
			DebugPrint("Error connecting")
			return
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end

function Error_debug.printTryError(...)
	local stack = debug.traceback(...)
	if stack ~= nil then
	DebugPrint("Error_debug")
	print(stack) 
	local data = {}
	data.Log = stack
	data.Srok = ""
	Error_debug.SendData(data,callback)
    --GameRules:SendCustomMessage(stack, 1, 1)
	end
	return stack
end

function Error_debug.ErrorCheck(callback, ...)
	return xpcall(callback, Error_debug.printTryError, ...)
end