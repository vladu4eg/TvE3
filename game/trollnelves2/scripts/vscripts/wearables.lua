if wearables == nil then
    _G.wearables = class({})
end
local dedicatedServerKey = GetDedicatedServerKeyV2("1")
local isTesting = IsInToolsMode() and false
Stats.server = "https://troll-elves.xyz/test/" -- "https://localhost:5001/test/" --
defaultpart = {}

require('settings')

function wearables:SelectPart(info)
    if info.offp == 0 then
        local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(info.PlayerID))
        if parts ~= nil then
            if parts[info.part] ~= "nill" and parts[info.part] ~= nil then
				
                local arr = {
                    info.PlayerID,
                    PlayerResource:GetPlayerName(info.PlayerID),
                    info.part,
                    PlayerResource:GetSelectedHeroName(info.PlayerID)
				}
				
                CustomGameEventManager:Send_ServerToAllClients( "UpdateParticlesUI", arr)
                PlayerResource:GetSelectedHeroEntity(info.PlayerID):RemoveModifierByName("part_mod")
                PlayerResource:GetSelectedHeroEntity(info.PlayerID):AddNewModifier(PlayerResource:GetSelectedHeroEntity(info.PlayerID), PlayerResource:GetSelectedHeroEntity(info.PlayerID), "part_mod", {part = info.part})
			end
			local npc = PlayerResource:GetSelectedHeroEntity(info.PlayerID)
			if parts["11"] == "normal" and not EVENT_START then
				SetModelVip(npc)
			end						
		end
		else
        PlayerResource:GetSelectedHeroEntity(info.PlayerID):RemoveModifierByName("part_mod")
	end
end

function wearables:AttachWearable(unit, modelPath)
    local wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = modelPath, DefaultAnim=animation, targetname=DoUniqueString("prop_dynamic")})
    wearable:FollowEntity(unit, true)
    unit.wearables = unit.wearables or {}
    table.insert(unit.wearables, wearable)
end

function wearables:RemoveWearables(hero)
    print('#RemoveWearables')
	local wearables = {} -- объявление локального массива на удаление
	local cur = hero:FirstMoveChild() -- получаем первый указатель над подобъект объекта hero ()
	
	while cur ~= nil do --пока наш текущий указатель не равен nil(пустота/пустой указатель)
		cur = cur:NextMovePeer() -- выбираем следующий указатель на подобъект нашего обьекта
		if cur ~= nil and cur:GetClassname() ~= "" and cur:GetClassname() == "dota_item_wearable" then -- проверяем, елси текущий указатель не пуст, название класса не пустое, и если этот класс есть класс "dota_item_wearable", то есть надеваемые косметические предметы
			table.insert(wearables, cur) -- добавляем в таблицу на удаление текущий предмет(сверху проверяли класс текущего объекта)
		end
	end
	
	for i = 1, #wearables do -- собственно цикл для удаления всего занесенного в массив на удаление
		UTIL_Remove(wearables[i]) -- удаляем объект
	end
	wearables = nil
end

function UpdateModel(target, model, scale)
	target:SetOriginalModel(model)
	target:SetModel(model)
	target:SetModelScale(scale)
end
function wearables:SetPart()
	local pplc = PlayerResource:GetPlayerCount()
	for i=0,pplc-1 do
		if GameRules.PartDefaults[i] ~= nil and GameRules.PartDefaults[i] ~= "" and PlayerResource:GetConnectionState(i) == 2 then
			if PlayerResource:GetSelectedHeroEntity(i):FindModifierByName("part_mod") == nil then
				local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(i))
				--Say(nil,"text here", false)
				--GameRules:SendCustomMessage("<font color='#58ACFA'> использовал эффект </font>"..info.name.."#partnote".." test", 0, 0)
				local arr = {
					i,
					PlayerResource:GetPlayerName(i),
					GameRules.PartDefaults[i],
					PlayerResource:GetSelectedHeroName(i)
				}
				
				CustomGameEventManager:Send_ServerToAllClients( "UpdateParticlesUI", arr)
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "SetSelectedParticles", arr)
				PlayerResource:GetSelectedHeroEntity(i):AddNewModifier(PlayerResource:GetSelectedHeroEntity(i), PlayerResource:GetSelectedHeroEntity(i), "part_mod", {part = GameRules.PartDefaults[i]})
				local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(i))
				local npc = PlayerResource:GetSelectedHeroEntity(i)
				if parts["11"] == "normal" and not EVENT_START then
					SetModelVip(npc)
				end
			end
		end
	end
end

function wearables:SetDefaultPart(event)
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

function SetModelVip(npc)
	if npc:IsAngel() then
		--	wearables:AttachWearable(npc, "models/items/crystal_maiden/dota_plus_crystal_maiden_shoulder/dota_plus_crystal_maiden_shoulder.vmdl")
		--	wearables:AttachWearable(npc, "models/items/crystal_maiden/dota_plus_crystal_maiden_head/dota_plus_crystal_maiden_head.vmdl")
		--	wearables:AttachWearable(npc, "models/items/crystal_maiden/dota_plus_crystal_maiden_back/dota_plus_crystal_maiden_back.vmdl")
		--	wearables:AttachWearable(npc, "models/items/crystal_maiden/dota_plus_crystal_maiden_weapon/dota_plus_crystal_maiden_weapon.vmdl")
		--	wearables:AttachWearable(npc, "models/items/crystal_maiden/dota_plus_crystal_maiden_arms/dota_plus_crystal_maiden_arms.vmdl")
		elseif npc:IsWolf() then
		wearables:RemoveWearables(npc)
		wearables:AttachWearable(npc, "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl")
		elseif npc:IsTroll() then
		--	wearables:AttachWearable(npc, "models/items/troll_warlord/lord_of_war_weapon/lord_of_war_weapon.vmdl")
		--	wearables:AttachWearable(npc, "models/items/troll_warlord/lord_of_war_armor/lord_of_war_armor.vmdl")
		--	wearables:AttachWearable(npc, "models/items/troll_warlord/lord_of_war_head/lord_of_war_head.vmdl")
		--	wearables:AttachWearable(npc, "models/items/troll_warlord/lord_of_war_shoulder/lord_of_war_shoulder.vmdl")
		elseif npc:IsElf() then
		wearables:RemoveWearables(npc)
		wearables:AttachWearable(npc, "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega.vmdl")
	end
	--if npc.bear ~= nil  then
	--	wearables:RemoveWearables(npc.bear)
	--	wearables:AttachWearable(npc.bear, "models/items/lone_druid/true_form/rabid_black_bear/rabid_black_bear.vmdl")
	--end
end