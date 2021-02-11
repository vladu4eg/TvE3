require('trollnelves2')

function SpiritBearSpawn( event )
	local caster = event.caster
	local player = caster:GetPlayerOwnerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = Vector(-320,-320,256) + RandomVector(200)
	local checkWolf  =  false
	local checkHut = false
	-- Set the unit name, concatenated with the level number
	local unit_name = "npc_dota_hero_bear" 
	--[[
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) then
			local wolf = PlayerResource:GetSelectedHeroEntity(pID)
			if wolf ~= nil then
				if wolf:IsWolf() and PlayerResource:GetConnectionState(wolf:GetPlayerOwnerID()) ~= 4 then
					checkWolf = true
				end
			end
		end
	end
	--]]
	local units = Entities:FindAllByClassname("npc_dota_creature")
	for _,unit in pairs(units) do
		local unit_name_hut = unit:GetUnitName();
		if unit_name_hut == "troll_hut_7" then
			checkHut = true
		end
	end
	if checkHut then
		-- Synergy Level. Checks both the default and the datadriven Synergy
		local synergyAbility = caster:FindAbilityByName("lone_druid_synergy_datadriven")
		if synergyAbility == nil then
			synergyAbility = caster:FindAbilityByName("lone_druid_synergy")
		end
		
		-- Check if the bear is alive, heals and spawns them near the caster if it is
		if caster.bear and IsValidEntity(caster.bear) and caster.bear:IsAlive() then
			FindClearSpaceForUnit(caster.bear, origin, true)
			caster.bear:SetHealth(caster.bear:GetMaxHealth())
			
			-- Spawn particle
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.bear)	
			
			-- Re-Apply the synergy buff if we found one
			if caster.bear:HasModifier("modifier_bear_synergy") then
				caster.bear:RemoveModifierByName("modifier_bear_synergy")
				synergyAbility:ApplyDataDrivenModifier(caster, caster.bear, "modifier_bear_synergy", nil)
			end
			
			else
			-- Create the unit and make it controllable
			caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
			caster.bear:SetControllableByPlayer(player, true)
			-- Apply the backslash on death modifier
			if ability ~= nil then
				ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_spirit_bear", nil)
			end
			
			-- Apply the synergy buff if the ability exists
			if synergyAbility ~= nil then
				synergyAbility:ApplyDataDrivenModifier(caster, caster.bear, "modifier_bear_synergy", nil)
			end
			InitializeBadHero(caster.bear)
			
			for i=0, caster.bear:GetAbilityCount()-1 do
				local ability = caster.bear:GetAbilityByIndex(i)
				if ability then ability:SetLevel(ability:GetMaxLevel()) end
			end
			ability:StartCooldown(999999)
			--SpiritCheckWolf(event)
			-- Learn its abilities: return lvl 2, entangle lvl 3, demolish lvl 4. By Index
		end
		
		else 
		ability:EndCooldown()
		SendErrorMessage(player, "#error_need_buy_hut_7")
	end
end

--[[
	Author: Noya
	Date: 15.01.2015.
	When the skill is leveled up, try to find the casters bear and replace it by a new one on the same place
]]
function SpiritBearLevel( event )
	local caster = event.caster
	local player = caster:GetPlayerOwnerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local unit_name = "npc_dota_hero_bear"
	
	print("Level Up Bear")
	
	-- Synergy Level. Checks both the default and the datadriven Synergy
	local synergyAbility = caster:FindAbilityByName("lone_druid_synergy_datadriven")
	if synergyAbility == nil then
		synergyAbility = caster:FindAbilityByName("lone_druid_synergy")
	end
	
	if caster.bear and caster.bear:IsAlive() then 
		-- Remove the old bear in its position
		local origin = caster.bear:GetAbsOrigin()
		caster.bear:RemoveSelf()
		
		-- Create the unit and make it controllable
		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:SetControllableByPlayer(player, true)
		-- Apply the backslash on death modifier
		ability:ApplyDataDrivenModifier(caster, caster.bear, "modifier_spirit_bear", nil)
		
		-- Apply the synergy buff if the ability exists
		if synergyAbility ~= nil then
			synergyAbility:ApplyDataDrivenModifier(caster, caster.bear, "modifier_bear_synergy", nil)
		end
		--SpiritCheckWolf(event)
		-- Learn its abilities: return lvl 2, entangle lvl 3, demolish lvl 4. By Index
	end
end

-- Do a percentage of the caster health then the spawned unit takes fatal damage
function SpiritBearDeath( event )
	local caster = event.caster
	local killer = event.attacker
	local ability = event.ability
	local casterHP = caster:GetMaxHealth()
	local backlash_damage = ability:GetLevelSpecialValueFor( "backlash_damage", ability:GetLevel() - 1 ) * 0.01
	
	-- Calculate and do the damage
	local damage = casterHP * backlash_damage
	
	ApplyDamage({ victim = caster, attacker = killer, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	ability:EndCooldown()
	ability:StartCooldown(360)
end

function SpiritCheckWolf( event )
	local caster = event.caster
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
		if PlayerResource:IsValidPlayerID(pID) then
			local wolf = PlayerResource:GetSelectedHeroEntity(pID)
			if wolf ~= nil then
				if wolf:IsWolf() then
					caster.bear:SetControllableByPlayer(pID, false)
				end
			end
		end
	end
end