require('libraries/util')
require('trollnelves2')
require('wearables')
--Ability for tents to give gold
function GainGoldCreate(event)
	local caster = event.caster
	local hero = caster:GetOwner()				
	if not hero then
		return
	end
	local level = caster:GetLevel()
	local amountPerSecond = 2^(level-1) * GameRules.MapSpeed
	hero.goldPerSecond = hero.goldPerSecond + amountPerSecond
	local dataTable = { entityIndex = caster:GetEntityIndex(), amount = amountPerSecond, interval = 1 }
	CustomGameEventManager:Send_ServerToTeam(caster:GetTeamNumber(), "gold_gain_start", dataTable)
end

function GainGoldDestroy(event)
	local caster = event.caster
	local hero = caster:GetOwner()				
	local level = caster:GetLevel()
	local amountPerSecond = 2^(level-1) * GameRules.MapSpeed
	hero.goldPerSecond = hero.goldPerSecond - amountPerSecond
	local dataTable = { entityIndex = caster:GetEntityIndex() }
	CustomGameEventManager:Send_ServerToTeam(caster:GetTeamNumber(), "gold_gain_stop", dataTable)
end

function ItemEffect(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Num = "2"
	data.Srok = "01/09/2020"
	Stats.GetVip(data, callback)
	local item = caster:FindItemInInventory("item_vip")
	caster:RemoveItem(item)
end

function ItemEvent(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Num = "3"
	data.Srok = "01/09/2020"
	Stats.GetVip(data, callback)
	local item = caster:FindItemInInventory("item_event")
	caster:RemoveItem(item)
end

function GainGoldTeamThinker(event)
	if event.caster then
		local caster = event.caster
		local level = caster:GetLevel()
		local amount = 2^(level-1) * GameRules.MapSpeed
		for i=1,PlayerResource:GetPlayerCountForTeam(caster:GetTeamNumber()) do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(caster:GetTeamNumber(), i)
			local hero = PlayerResource:GetSelectedHeroEntity(playerID) or false
			if hero then
				PlayerResource:ModifyGold(hero,amount)
			end
		end
		PopupGoldGain(caster,amount)
	end
end


function shrapnel_start_charge( keys )
	-- Only start charging at level 1
	if keys.ability:GetLevel() ~= 1 then return end

	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_shrapnel_stack_counter_datadriven"
	local maximum_charges = ability:GetLevelSpecialValueFor( "maximum_charges", ( ability:GetLevel() - 1 ) )
	local charge_replenish_time = ability:GetLevelSpecialValueFor( "charge_replenish_time", ( ability:GetLevel() - 1 ) )
	if GameRules.MapSpeed ~= 1  then
		charge_replenish_time = 30
	end
	-- Initialize stack
	caster:SetModifierStackCount( modifierName, caster, 0 )
	caster.shrapnel_charges = maximum_charges
	caster.start_charge = false
	caster.shrapnel_cooldown = 0.0
	
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( modifierName, caster, maximum_charges )
	
	-- create timer to restore stack
	Timers:CreateTimer( function()
			-- Restore charge
			if caster.start_charge and caster.shrapnel_charges < maximum_charges then
				-- Calculate stacks
				local next_charge = caster.shrapnel_charges + 1
				caster:RemoveModifierByName( modifierName )
				if next_charge ~= maximum_charges then
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
					shrapnel_start_cooldown( caster, charge_replenish_time )
				else
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
					caster.start_charge = false
				end
				caster:SetModifierStackCount( modifierName, caster, next_charge )
				
				-- Update stack
				caster.shrapnel_charges = next_charge
			end
			
			-- Check if max is reached then check every 0.5 seconds if the charge is used
			if caster.shrapnel_charges ~= maximum_charges then
				caster.start_charge = true
				return charge_replenish_time
			else
				return 0.5
			end
		end
	)
end
function shrapnel_fire( keys )
	-- Reduce stack if more than 0 else refund mana
	if keys.caster.shrapnel_charges > 0 then
		-- variables
		local caster = keys.caster
		local target = keys.target_points[1]
		local ability = keys.ability
		local casterLoc = caster:GetAbsOrigin()
		local modifierName = "modifier_shrapnel_stack_counter_datadriven"
		local dummyModifierName = "modifier_shrapnel_dummy_datadriven"
		local radius = ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )
		local maximum_charges = ability:GetLevelSpecialValueFor( "maximum_charges", ( ability:GetLevel() - 1 ) )
		local charge_replenish_time = ability:GetLevelSpecialValueFor( "charge_replenish_time", ( ability:GetLevel() - 1 ) )
		local dummy_duration = ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) ) + 0.1
		local damage_delay = ability:GetLevelSpecialValueFor( "damage_delay", ( ability:GetLevel() - 1 ) ) + 0.1
		local next_charge = 0
		-- Deplete charge
		if GameRules.MapSpeed ~= 1  then
			charge_replenish_time = 30
		end
		if caster:HasModifier("modifier_troll_warlord_presence") or caster:HasModifier("modifier_troll_boots_3") then
			next_charge = caster.shrapnel_charges
		else
			next_charge = caster.shrapnel_charges - 1
		end
		if caster.shrapnel_charges == maximum_charges then
			caster:RemoveModifierByName( modifierName )
			ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
			shrapnel_start_cooldown( caster, charge_replenish_time )
		end
		caster:SetModifierStackCount( modifierName, caster, next_charge )
		caster.shrapnel_charges = next_charge
		
		-- Check if stack is 0, display ability cooldown
		if caster.shrapnel_charges == 0 then
			-- Start Cooldown from caster.shrapnel_cooldown
			ability:StartCooldown( caster.shrapnel_cooldown )
		else
			ability:EndCooldown()
		end
		-- Deal damage
		RevealArea( keys )
	end
end
function shrapnel_start_cooldown( caster, charge_replenish_time )
	caster.shrapnel_cooldown = charge_replenish_time
	Timers:CreateTimer( function()
			local current_cooldown = caster.shrapnel_cooldown - 0.1
			if current_cooldown > 0.1 then
				caster.shrapnel_cooldown = current_cooldown
				return 0.1
			else
				return nil
			end
		end
	)
end

function RevealArea( event )
	
	local caster = event.caster
	local point = event.target_points[1]
	local visionRadius = string.match(GetMapName(),"standart") and event.Radius*0.58 or string.match(GetMapName(),"arena") and event.Radius*0.58 or event.Radius
	local visionDuration = event.Duration
	AddFOWViewer(caster:GetTeamNumber(), point, visionRadius, visionDuration, false)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), point , nil, visionRadius , DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
	local timeElapsed = 0
	
	Timers:CreateTimer(0.03,function()
		for _,unit in pairs(units) do
			if unit ~= nil then
				if unit:HasModifier("modifier_invisible") then
					unit:RemoveModifierByName("modifier_invisible")
				end
			end
		end
		timeElapsed = timeElapsed + 0.03
		if timeElapsed < visionDuration then
			return 0.03
		end
	end)
end

function TeleportTo (event)
	local caster = event.caster
	for i=1,#GameRules.trollTps do
		local units = FindUnitsInRadius(caster:GetTeamNumber(), GameRules.trollTps[i] , nil, 200 , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
		if #units == 0 then
			FindClearSpaceForUnit( caster , GameRules.trollTps[i] , true )
			break
		end
	end
end

function GoldOnAttack (event)
	local caster = event.caster
	local dmg = math.floor(event.DamageDealt) * GameRules.MapSpeed
	PlayerResource:ModifyGold(caster,dmg)
	PopupGoldGain(caster,dmg)
	local target = event.unit
	caster.attackTarget = target:GetEntityIndex()
	target.attackers = target.attackers or {}
	target.attackers[caster:GetEntityIndex()] = true
	
end

function ExchangeLumber(event)
	local caster = event.caster
	local playerID = caster:GetMainControllingPlayer()
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local amount = event.Amount
	
	local price = 0
	local increasePrice = 0
	for a = 10,math.abs(amount),10 do
		price = price + GameRules.lumberPrice + increasePrice
		if amount > 0 then
			increasePrice = increasePrice + 5
			else
			if GameRules.lumberPrice + increasePrice - 5 > 10 then
				increasePrice = increasePrice - 5
			end
		end
	end
	
	--Buy wood
	if amount > 0 then
		DebugPrint("Buying " .. amount .. " wood for " .. price .. " gold!")
		if price > PlayerResource:GetGold(playerID) then
            SendErrorMessage(playerID, "#error_not_enough_gold")
            return false
			else
        	PlayerResource:ModifyGold(hero,-price)
        	PlayerResource:ModifyLumber(hero,amount)
        	ModifyLumberPrice(increasePrice)
        	PopupGoldGain(caster,math.floor(price),false)
        	PopupLumber(caster,math.floor(amount),true)
		end
		--Sell wood
		else
		amount = -amount
		price = price + increasePrice
		DebugPrint("Selling " .. amount .. " wood for " .. price .. " gold!")
		if amount > PlayerResource:GetLumber(playerID) then
            SendErrorMessage(playerID, "#error_not_enough_lumber")
            return false
			else
			PlayerResource:ModifyGold(hero,price)
			PlayerResource:ModifyLumber(hero,-amount)
        	ModifyLumberPrice(increasePrice)
        	PopupGoldGain(caster,math.floor(price),true)
        	PopupLumber(caster,math.floor(amount),false)
		end
	end
	
end

function SpawnUnitOnSpellStart(event)
	local caster = event.caster
	local playerID = caster:GetMainControllingPlayer()
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local ability = event.ability
	local unit_name = GetAbilityKV(ability:GetAbilityName()).UnitName
	local gold_cost = ability:GetSpecialValueFor("gold_cost")
	local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
	local food = ability:GetSpecialValueFor("food_cost")
	local wisp = ability:GetSpecialValueFor("wisp_cost")
	PlayerResource:ModifyGold(hero,-gold_cost)
	PlayerResource:ModifyLumber(hero,-lumber_cost)
	PlayerResource:ModifyFood(hero,food)
	PlayerResource:ModifyWisp(hero,wisp)
    if PlayerResource:GetGold(playerID) < 0 then
        SendErrorMessage(playerID, "#error_not_enough_gold")
        caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
        return false
	end
    if PlayerResource:GetLumber(playerID) < 0 then
        SendErrorMessage(playerID, "#error_not_enough_lumber")
        caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
        return false
		end
    if hero.food > GameRules.maxFood and food ~= 0 then
        SendErrorMessage(playerID, "#error_not_enough_food")
        caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
		return false
	end
	if hero.wisp > GameRules.maxWisp and wisp ~= 0 then
        SendErrorMessage(playerID, "#error_not_enough_wisp")
        caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
		return false
	end
end

function SpawnUnitOnChannelSucceeded(event)
	local caster = event.caster
	local ability = event.ability
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local unit_name = GetAbilityKV(ability:GetAbilityName()).UnitName
	local unit_count = ability:GetSpecialValueFor("unit_count")
	local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(caster:GetPlayerOwnerID()))
	for a = 1,unit_count do
		local unit = CreateUnitByName(unit_name, caster:GetAbsOrigin() , true, nil, nil, hero:GetTeamNumber())
		unit:AddNewModifier(unit,nil,"modifier_phased",{duration = 0.03})
        unit:SetOwner(hero)
        table.insert(hero.units,unit)
        unit:SetControllableByPlayer(playerID, true)
		if parts ~= nil then      
			if  string.match(unit_name,"%a+") == "wisp" and parts["3"] == "normal" and unit_name ~= "gold_wisp" then
				if string.match(GetMapName(),"winter") then
					wearables:RemoveWearables(unit)
					UpdateModel(unit, "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", 1.2)    
				elseif string.match(GetMapName(),"spring") then
					wearables:RemoveWearables(unit)
					UpdateModel(unit, "models/items/courier/serpent_warbler/serpent_warbler_flying.vmdl", 1.1)    
				elseif string.match(GetMapName(),"autumn") then 
					wearables:RemoveWearables(unit)
					UpdateModel(unit, "models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution_flying.vmdl", 1.2)    
				elseif string.match(GetMapName(),"desert") then 
					wearables:RemoveWearables(unit)
					UpdateModel(unit, "models/items/courier/ig_dragon/ig_dragon_flying.vmdl", 1.2)    
				end
			--elseif parts["3"] == "normal" and unit_name == "gold_wisp" then
			--		wearables:RemoveWearables(unit)
			--		UpdateModel(unit, "models/gold_wisp.vmdl", 1)     
			end
		end
	end
end

function SpawnUnitOnChannelInterrupted(event)
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local ability = event.ability
	local unit_name = GetAbilityKV(ability:GetAbilityName()).UnitName
	local gold_cost = ability:GetSpecialValueFor("gold_cost")
	local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
	local food = ability:GetSpecialValueFor("food_cost")
	local wisp = ability:GetSpecialValueFor("wisp_cost")
	PlayerResource:ModifyGold(hero,gold_cost)
	PlayerResource:ModifyLumber(hero,lumber_cost)
	PlayerResource:ModifyFood(hero,-food)
	PlayerResource:ModifyWisp(hero,-wisp)
end


THINK_INTERVAL = 0.5


function Repair(event)
	local args = {}
    args.PlayerID = event.caster:GetPlayerOwnerID()
    args.targetIndex = event.target:GetEntityIndex()
    args.queue = false
	BuildingHelper:RepairCommand(args)
end

function RepairAutocast(event)
	local caster = event.caster
	local ability = event.ability
	local playerID = caster:GetPlayerOwnerID()
	local radius = event.Radius
	Timers:CreateTimer(function()
		if caster.state == "idle" and ability and not ability:IsNull() and ability:GetAutoCastState() then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin() , nil, radius , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
			for k,unit in pairs(units) do
				if IsCustomBuilding(unit) and unit:GetHealthDeficit() > 0 and unit.state == "complete" then
					BuildingHelper:AddRepairToQueue(caster, unit, true)
					caster.state = "repairing"
					break
				end
			end
		end
		return 0.5
	end)
end

function GatherLumber(event)
	local caster = event.caster
    local target = event.target
    local ability = event.ability
    local target_class = target:GetClassname()
    local pID = caster:GetPlayerOwnerID()
    caster:Interrupt()
    if target_class ~= "ent_dota_tree" then
    	caster:Interrupt()
    	return
	end
    
    local tree = target
	
	
    -- Check for empty tree for Wisps
    if tree.builder ~= nil and tree.builder ~= caster then
        SendErrorMessage(pID,"The tree is occupied!")
        caster:Interrupt()
        return
	end
	
    local tree_pos = tree:GetAbsOrigin()
    local particleName = "particles/ui_mouseactions/ping_circle_static.vpcf"
    local particle = ParticleManager:CreateParticleForPlayer(particleName, PATTACH_CUSTOMORIGIN, caster, caster:GetPlayerOwner())
    ParticleManager:SetParticleControl(particle, 0, Vector(tree_pos.x, tree_pos.y, tree_pos.z+20))
    ParticleManager:SetParticleControl(particle, 1, Vector(0,255,0))
    Timers:CreateTimer(3, function() 
        ParticleManager:DestroyParticle(particle, true)
	end)
	
    caster.target_tree = tree
    ability.cancelled = false
	
    tree.builder = caster
	
    -- Fake toggle the ability, cancel if any other order is given
    if not ability:GetToggleState() then
    	ability:ToggleAbility()
	end
	
    -- Recieving another order will cancel this
    -- ability:ApplyDataDrivenModifier(caster, caster, "modifier_on_order_cancel_lumber", {})
    tree_pos.z = tree_pos.z - 28
    caster:SetAbsOrigin(tree_pos)
    tree.wisp_gathering = true
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_gathering_lumber", {})
	
end

function LumberGain( event )
    local ability = event.ability
    local caster = event.caster
	local lumberGain = GetUnitKV(caster:GetUnitName(), "LumberAmount") * GameRules.MapSpeed
	local lumberInterval = GetUnitKV(caster:GetUnitName(), "LumberInterval")
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	ModifyLumberPerSecond(hero, lumberGain, lumberInterval)
	local dataTable = { entityIndex = caster:GetEntityIndex(),
	amount = lumberGain, interval = lumberInterval }
	local player = hero:GetPlayerOwner()
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "tree_wisp_harvest_start", dataTable)
	end
end

function ModifyLumberPerSecond(hero, amount, interval) 
	hero.lumberPerSecond = hero.lumberPerSecond + (amount/interval)
end

function CancelGather(event)
	
	DebugPrint("Cancel gather---------------------------------------------------------------------")
  	local caster = event.caster
    local ability = event.ability
	
    caster:RemoveModifierByName("modifier_gathering_lumber")
	
    ability.cancelled = true
    caster.state = "idle"
	
    local tree = caster.target_tree
    if tree then
        caster.target_tree = nil
        tree.builder = nil
	end
    if ability:GetToggleState() then
    	ability:ToggleAbility()
	end
    -- Give 1 extra second of fly movement
    caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
    Timers:CreateTimer(0.03,function() 
        caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
        caster:AddNewModifier(caster, nil, "modifier_phased", {duration=0.03})
	end)
	local lumberGain = GetUnitKV(caster:GetUnitName(), "LumberAmount") * GameRules.MapSpeed
	local lumberInterval = GetUnitKV(caster:GetUnitName(), "LumberInterval")
    local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	ModifyLumberPerSecond(hero, -lumberGain, lumberInterval)
	local dataTable = { entityIndex = caster:GetEntityIndex() }
	local player = hero:GetPlayerOwner()
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "tree_wisp_harvest_stop", dataTable)
	end
end


function GoldMineCreate(keys)
	local caster = keys.caster
	local hero = caster:GetOwner()
	local amountPerSecond = GetUnitKV(caster:GetUnitName()).GoldAmount * GameRules.MapSpeed
	local maxGold = GetUnitKV(caster:GetUnitName(),"MaxGold") or 2000000
	hero.goldPerSecond = hero.goldPerSecond + amountPerSecond
	local secondsToLive = maxGold/amountPerSecond;
	keys.ability:StartCooldown(secondsToLive)
	caster.destroyTimer = Timers:CreateTimer(secondsToLive,
		function()
			caster:ForceKill(false)
		end)
		local dataTable = { entityIndex = caster:GetEntityIndex(), amount = amountPerSecond, interval = 1 }
		local player = hero:GetPlayerOwner()
		if player then
			CustomGameEventManager:Send_ServerToPlayer(player, "gold_gain_start", dataTable)
		end
end

function GoldMineDestroy(keys)
	local caster = keys.caster
	local hero = caster:GetOwner()
	local amountPerSecond = GetUnitKV(caster:GetUnitName()).GoldAmount * GameRules.MapSpeed
	hero.goldPerSecond = hero.goldPerSecond - amountPerSecond
	Timers:RemoveTimer(caster.destroyTimer)
	local dataTable = { entityIndex = caster:GetEntityIndex() }
	local player = hero:GetPlayerOwner()
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "gold_gain_stop", dataTable)
	end
end


function HpRegenModifier(keys)
	print ( '[vladu4eg] HpRegenModifier' )
    DebugPrintTable(keys)
	local caster = keys.caster
	if caster and caster.hpReg then
		caster.hpReg = caster.hpReg + keys.Amount
		CustomGameEventManager:Send_ServerToAllClients("custom_hp_reg", { value=(caster.hpReg-caster.hpRegDebuff),unit=caster:GetEntityIndex() })
	end
end

function HpRegenDestroy(keys)
	keys.Amount = keys.Amount * (-1)
	HpRegenModifier(keys)
end



function BuyItem(event)
	local ability = event.ability
	local caster = event.caster
	local item_name = GetAbilityKV(ability:GetAbilityName()).ItemName
	local gold_cost = GetItemKV(item_name)["AbilitySpecial"]["02"]["gold_cost"];
	local lumber_cost = GetItemKV(item_name)["AbilitySpecial"]["03"]["lumber_cost"];
	local playerID = caster.buyer
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	
	if not IsInsideShopArea(hero) and item_name ~=  "item_book_of_agility" and item_name ~=  "item_book_of_strength" and item_name ~=  "item_book_of_intelligence" then
		SendErrorMessage(playerID, "#error_shop_out_of_range")
		return
	end
	if gold_cost > PlayerResource:GetGold(playerID) then
        SendErrorMessage(playerID, "#error_not_enough_gold")
        return
	end
	if lumber_cost > PlayerResource:GetLumber(playerID) then
        SendErrorMessage(playerID, "#error_not_enough_lumber")
        return
	end
	if hero:GetNumItemsInInventory() >= 6 then
		SendErrorMessage(playerID, "#error_full_inventory")
        return
	end
	if hero:FindItemInInventory("item_disable_repair_2") ~= nil and item_name == 'item_disable_repair_2'  then
		SendErrorMessage(playerID, "#error_full_inventory")
        return		
	end
	if item_name == 'item_troll_boots_3' and (GameRules:GetGameTime() - GameRules.startTime) < (7200 / GameRules.MapSpeed) then
		SendErrorMessage(playerID, "#error_no_time_boots")
        return	
	end
	
    PlayerResource:ModifyLumber(hero,-lumber_cost)
    PlayerResource:ModifyGold(hero,-gold_cost)
	local item = CreateItem(item_name, hero, hero)
	hero:AddItem(item)
end

function IsInsideShopArea(unit) 
	for index, shopTrigger in ipairs(GameRules.shops) do
		if IsInsideBoxEntity(shopTrigger, unit) then
			return true
		end
	end
	return false
end

function IsInsideBoxEntity(box, unit)
    local boxOrigin = box:GetAbsOrigin()
	local bounds = box:GetBounds()
    local min = bounds.Mins
	local max = bounds.Maxs
	local unitOrigin = unit:GetAbsOrigin()
    local X = unitOrigin.x
    local Y = unitOrigin.y
    local minX = min.x + boxOrigin.x
	local minY = min.y + boxOrigin.y
	local maxX = max.x + boxOrigin.x
	local maxY = max.y + boxOrigin.y
	local betweenX = X >= minX and X <= maxX
	local betweenY = Y >= minY and Y <= maxY
	
	return betweenX and betweenY
end

function FountainRegen(event)
	local caster = event.caster
	local radius = event.Radius
	local units = FindUnitsInRadius(caster:GetTeamNumber() , caster:GetAbsOrigin() , nil , radius , DOTA_UNIT_TARGET_TEAM_FRIENDLY ,  DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	for _,unit in pairs(units) do
		unit:SetHealth(unit:GetHealth() + unit:GetMaxHealth() * 0.004)
	end
end

function BuyLumberTroll(event)
	local caster = event.caster
	local playerID = caster.buyer
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local amount = event.Amount
	local price = amount * 64000
	local distance = (caster:GetAbsOrigin() - hero:GetAbsOrigin()):Length()
	local noDistance = false
	local units = Entities:FindAllByClassname("npc_dota_creature")
	for _,unit in pairs(units) do
		local unit_name = unit:GetUnitName();
		if unit_name == "troll_hut_6" or unit_name == "troll_hut_7" then
			noDistance = true
		end
	end
	
	if distance > 1000 and not noDistance then
		SendErrorMessage(playerID, "#error_shop_out_of_range")
		return false
	end	

	if amount > 0 then
		if price > PlayerResource:GetGold(playerID) then
			SendErrorMessage(playerID, "#error_not_enough_gold")
			return false
		end
		else
		if -amount > PlayerResource:GetLumber(playerID) then
			SendErrorMessage(playerID, "#error_not_enough_lumber")
			return false
		end
	end
	PlayerResource:ModifyGold(hero,-price)
	PlayerResource:ModifyLumber(hero,amount)
	
end

function StealGold(event)
	local caster = event.caster
	local target = event.target
	local playerID = target:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local sum = math.ceil(hero:GetNetworth()*0.003)+10
	local maxSum = 50000
	local units = Entities:FindAllByClassname("npc_dota_creature")
	for _,unit in pairs(units) do
		local unit_name = unit:GetUnitName();
		if unit_name == "troll_hut_6" or unit_name == "troll_hut_7" then
			maxSum = 500000
			sum = math.ceil(hero:GetNetworth()*0.005)+10
			caster:GiveMana(5)
		end
	end
	if GameRules:GetGameTime() - GameRules.startTime >= WOLF_START_SPAWN_TIME then
		if sum > maxSum then
			sum = maxSum
		end
	else
		SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_time")
		sum = 0
	end
	PlayerResource:ModifyGold(caster,sum)
end

function CheckStealGoldTarget(event)
	local caster = event.caster
	local target = event.target
	local pID = caster:GetMainControllingPlayer()
	if not string.match(target:GetUnitName(),"troll_hut") then
		caster:Interrupt()
		SendErrorMessage(pID, "#error_castable_only_on_troll_hut")
		caster:SetMana(caster:GetMana() + 20)
	end
end

function CommitSuicide(event)
	local caster = event.caster
	local units = FindUnitsInRadius(caster:GetTeamNumber() , caster:GetAbsOrigin() , nil , 1500 , DOTA_UNIT_TARGET_TEAM_ENEMY ,  DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	local playerID = caster:GetMainControllingPlayer()
	if #units > 0 then
		SendErrorMessage(playerID, "#error_enemy_nearby")
		else
		caster:ForceKill(true) --This will call RemoveBuilding
		Timers:CreateTimer(10,function()
			UTIL_Remove(caster)
		end)
	end
end

function ItemBlink(keys)
	ProjectileManager:ProjectileDodge(keys.caster)  --Disjoints disjointable incoming projectiles.
	
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, keys.caster)
	keys.caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	
	local origin_point = keys.caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local difference_vector = target_point - origin_point
	
	if difference_vector:Length2D() > keys.MaxBlinkRange then  --Clamp the target point to the MaxBlinkRange range in the same direction.
		target_point = origin_point + (target_point - origin_point):Normalized() * keys.MaxBlinkRange
	end
	
	keys.caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(keys.caster, target_point, false)
	
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, keys.caster)
end

function TowerAttackSpeed( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	
	-- Check if we have an old target
	if caster.fervor_target then
		-- Check if that old target is the same as the attacked target
		if caster.fervor_target == target then
			-- Check if the caster has the attack speed modifier
			if caster:HasModifier(modifier) and target:HasModifier("modifier_fervor_target") then
				-- Get the current stacks
				local stack_count = caster:GetModifierStackCount(modifier, ability)
				
				-- Check if the current stacks are lower than the maximum allowed
				if stack_count < max_stacks then
					-- Increase the count if they are
					caster:SetModifierStackCount(modifier, ability, stack_count + 1)
				end
				else
				-- Apply the attack speed modifier and set the starting stack number
				ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
				caster:SetModifierStackCount(modifier, ability, 1)
			end
			else
			-- If its not the same target then set it as the new target and remove the modifier
			caster:RemoveModifierByName(modifier)
			caster.fervor_target = target
		end
		else
		caster.fervor_target = target
	end
end

function NightAbility( keys )
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	--local currentTime = GameRules:GetTimeOfDay()
	
	-- Time variables
	local time_flow = 0.0020833333
	local time_elapsed = 0
	-- Calculating what time of the day will it be after Darkness ends
	local start_time_of_day = GameRules:GetTimeOfDay()
	local end_time_of_day = start_time_of_day + duration * time_flow
	
	if end_time_of_day >= 1 then end_time_of_day = end_time_of_day - 1 end
	
	-- Setting it to the middle of the night
	GameRules:SetTimeOfDay(0)
	
	-- Using a timer to keep the time as middle of the night and once Darkness is over, normal day resumes
	Timers:CreateTimer(1, function()
		if time_elapsed < duration then
			GameRules:SetTimeOfDay(0)
			time_elapsed = time_elapsed + 1
			return 1
			else
			GameRules:SetTimeOfDay(end_time_of_day)
		end
	end)
end

function CheckNight(keys)
	local caster = keys.caster
	if GameRules:IsDaytime() then
		caster:Interrupt()
		SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_night")
	end
end

function CheckNightInvis(keys)
	local caster = keys.caster
	if GameRules:IsDaytime() then
		if caster:HasModifier("modifier_stand_invis") then
			caster:RemoveModifierByName("modifier_stand_invis")
		end
	end
end

function HealBuilding(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local heal = math.max(event.FixedHeal,(event.PercentageHeal*target:GetMaxHealth()/100))
	if target.state == "complete" then 
		if target.healed then
			heal = heal/3
		end
		if target:HasModifier("modifier_disable_repair") then
			heal = heal/2
		end
		if (target:GetHealth() + heal) > target:GetMaxHealth() then
			target:SetHealth(target:GetMaxHealth())
			else
			target:SetHealth(target:GetHealth() + heal)
		end
		target.healed = true
		Timers:CreateTimer(ability:GetCooldownTime(),function()
			target.healed = false
		end)
	end 
end

function StackModifierCreated(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.Modifier
	
	local stack_count = 0
	if target:HasModifier(modifier) then
		stack_count = target:GetModifierStackCount(modifier, ability)
		else 
		ability:ApplyDataDrivenModifier(caster, target, modifier, {})
	end
	target:SetModifierStackCount(modifier, ability, stack_count + 1)
end

function StackModifierCreated2(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.Modifier
	
	local stack_count = 0
	if target:HasModifier("modifier_buff_counter") then
		stack_count = target:GetModifierStackCount(modifier, ability)
		else 
		ability:ApplyDataDrivenModifier(caster, target, modifier, {})
	end
	target:SetModifierStackCount(modifier, ability, stack_count + 1)
	
	local tar = target:FindModifierByName( "modifier_rooted" )
	local tar2 = target:FindModifierByName( "modifier_disarmed" )
	local tar3 = target:FindModifierByName( "invis_disabled" )
	
	if target:HasModifier("modifier_buff_counter") and stack_count+1 == 2 then
		tar:SetDuration(3,true)
		tar2:SetDuration(3,true)
		tar3:SetDuration(3,true)
		elseif target:HasModifier("modifier_buff_counter") and stack_count+1 == 3 then
		tar:SetDuration(1.5,true)
		tar2:SetDuration(1.5,true)
		tar3:SetDuration(1.5,true)
		elseif target:HasModifier("modifier_buff_counter") and stack_count+1 > 3 then
		tar:SetDuration(1,true)
		tar2:SetDuration(1,true)
		tar3:SetDuration(1,true)
	end
end


function StackModifierExpired(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.Modifier
	
	local stackCount = target:GetModifierStackCount(modifier, ability)
	if stackCount <= 1 then
		target:RemoveModifierByName(modifier)
		else
		target:SetModifierStackCount(modifier, ability, stackCount-1)
	end
end	

function troll_buff(keys)
    local unit = keys:GetCaster()
    EmitSoundOn("Hero_TrollWarlord.BattleTrance.Cast", unit)
end