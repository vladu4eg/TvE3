Pets = Pets or {
	playerPets = {}
}

-- function Pets:Precache( context )
-- 	print( "Pets precache start" )

-- 	for _, effect in pairs( self.heroEffects ) do
-- 		if effect.resource then
-- 			PrecacheResource( "particle_folder", effect.resource, context )
-- 		end
-- 	end

-- 	for _, p in pairs( self.petsData.particles ) do
-- 		PrecacheResource( "particle", p.particle, context )
-- 	end

-- 	for _, c in pairs( self.petsData.couriers ) do
-- 		PrecacheModel( c.model, context )

-- 		for _, p in pairs( c.particles ) do
-- 			if type( p ) == "string" then
-- 				PrecacheResource( "particle", p, context )
-- 			end
-- 		end
-- 	end

-- 	print( "Pets precache end" )
-- end

function Pets:Init()
	LinkLuaModifier( "modifier_cosmetic_pet", "modifiers/modifier_cosmetic_pet", LUA_MODIFIER_MOTION_NONE )
	-- LinkLuaModifier( "modifier_cosmetic_pet_invisible", "modifiers/modifier_cosmetic_pet_invisible", LUA_MODIFIER_MOTION_NONE )

	-- RegisterCustomEventListener( "cosmetics_select_pet", Dynamic_Wrap( self, "CreatePet" ) )
	-- RegisterCustomEventListener( "cosmetics_remove_pet", Dynamic_Wrap( self, "DeletePet" ) )

	GameRules:GetGameModeEntity():SetContextThink( "pets_think", function()
		self:OnThink()

		return  0.1
	end, 0.4 )
	end

-- local function HidePet( pet, time )
-- 	pet:AddNoDraw()
-- 	pet.isHidden = true
-- 	pet.unhideTime = GameRules:GetDOTATime( false, false ) + time

-- 	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_disguise_smoke_top.vpcf", PATTACH_WORLDORIGIN, nil )
-- 	ParticleManager:SetParticleControl( particle, 0, pet:GetAbsOrigin() )
-- 	ParticleManager:ReleaseParticleIndex( particle )
-- end

-- local function UnhidePet( pet )
-- 	pet:RemoveNoDraw()
-- 	pet.isHidden = false

-- 	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_disguise_smoke_top.vpcf", PATTACH_WORLDORIGIN, nil )
-- 	ParticleManager:SetParticleControl( particle, 0, pet:GetAbsOrigin() )
-- 	ParticleManager:ReleaseParticleIndex( particle )
-- end

function Pets:OnThink()
	for _, pet in pairs( Pets.playerPets ) do
		local owner = pet:GetOwner()
		local owner_pos = owner:GetAbsOrigin()
		local pet_pos = pet:GetAbsOrigin()
		local distance = ( owner_pos - pet_pos ):Length2D()
		local owner_dir = owner:GetForwardVector()
		local dir = owner_dir * RandomInt( 110, 140 )

		-- if owner:IsInvisible() and not pet:HasModifier( "modifier_cosmetic_pet_invisible" ) then
		-- 	pet:AddNewModifier( pet, nil, "modifier_cosmetic_pet_invisible", {} )
		-- elseif not owner:IsInvisible() and pet:HasModifier( "modifier_cosmetic_pet_invisible" ) then
		-- 	pet:RemoveModifierByName( "modifier_cosmetic_pet_invisible" )
		-- end

		-- local enemy_dis
		-- local near = FindUnitsInRadius(
		-- 	owner:GetTeam(),
		-- 	pet:GetAbsOrigin(),
		-- 	nil,
		-- 	300,
		-- 	DOTA_UNIT_TARGET_TEAM_ENEMY,
		-- 	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		-- 	DOTA_UNIT_TARGET_FLAG_NO_INVIS,
		-- 	FIND_CLOSEST,
		-- 	false
		-- )[1]

		-- if near then
		-- 	enemy_dis = ( near:GetAbsOrigin() - pet_pos ):Length2D()
		-- end

		if distance > 900 then
			-- if not pet.isHidden then
			-- 	HidePet( pet, 0.35 )
			-- end

			local a = RandomInt( 60, 120 )

			if RandomInt( 1, 2 ) == 1 then
				a = a * -1
			end

			local r = RotatePosition( Vector( 0, 0, 0 ), QAngle( 0, a, 0 ), dir )

			pet:SetAbsOrigin( owner_pos + r )
			pet:SetForwardVector( owner_dir )

			FindClearSpaceForUnit( pet, owner_pos + r, true )
		elseif distance > 150 then
			local right = RotatePosition( Vector( 0, 0, 0 ), QAngle( 0, RandomInt( 70, 110 ) * -1, 0 ), dir ) + owner_pos
			local left = RotatePosition( Vector( 0, 0, 0 ), QAngle( 0, RandomInt( 70, 110 ), 0 ), dir ) + owner_pos

			-- if enemy_dis and enemy_dis < 300 and distance < 400 then
			-- 	pet:Stop()
			-- else
				if ( pet_pos - right ):Length2D() > ( pet_pos - left ):Length2D() then
					pet:MoveToPosition( left )
				else
					pet:MoveToPosition( right )
				end
			-- end
		elseif distance < 90 then
			pet:MoveToPosition( owner_pos + ( pet_pos - owner_pos ):Normalized() * RandomInt( 110, 140 ) )
		-- elseif near and ( near:GetAbsOrigin() - pet_pos ):Length2D() < 110 then
		-- 	pet:MoveToPosition( pet_pos + ( pet_pos - near:GetAbsOrigin() ):Normalized() * RandomInt( 100, 150 ) )
		end
		if owner:HasModifier("modifier_generic_invisibility") then
        local invisModifier = owner:FindModifierByName("modifier_generic_invisibility")
		local check = true
        if invisModifier then
            local remainingTime = invisModifier:GetRemainingTime()
            pet:AddNewModifier(pet,nil,"modifier_generic_invisibility",{duration=remainingTime})
        end
		end
		if owner:HasModifier("modifier_invisible") then
        local invisModifier = owner:FindModifierByName("modifier_invisible")
        if invisModifier then
            local remainingTime = invisModifier:GetRemainingTime()
            pet:AddNewModifier(pet,nil,"modifier_invisible",{duration=remainingTime})
        end
		end
	end
end

function Pets.CreatePet( keys, num )
	local id = keys.PlayerID
	-- local old_pet = Pets.playerPets[id]
	-- local old_pet_pos
	-- local old_pet_dir
	local hero = keys.hero--PlayerResource:GetSelectedHeroEntity(id)--PlayerResource:GetPlayer( id ):GetAssignedHero()
	local model = ""
	local effect = ""

	-- if old_pet then
	-- 	old_pet_pos = old_pet.unit:GetAbsOrigin()
	-- 	old_pet_dir = old_pet.unit:GetForwardVector()

	-- 	old_pet.unit:Destroy()
	-- end


	-- UnhidePet( pet )
	--local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_disguise_smoke_top.vpcf", PATTACH_WORLDORIGIN, nil )
	--ParticleManager:SetParticleControl( particle, 0, pet:GetAbsOrigin() )
	--ParticleManager:ReleaseParticleIndex( particle )


	--[[

	]]
	if num == "1" then
		model = "models/courier/baby_rosh/babyroshan.vmdl" -- Baby Roshan
		effect = "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_swarm.vpcf"
	elseif num == "2" then
		model = "models/courier/baby_rosh/babyroshan_elemental.vmdl" -- Lava Baby Roshan
		effect = ""
	elseif num == "3" then
		model = "models/courier/baby_rosh/babyroshan_elemental.vmdl" -- Ice Baby Roshan
		effect = ""
	elseif num == "4" then
		model = "models/courier/baby_rosh/babyroshan.vmdl" --  Jade Baby Roshan SPRING 
		effect = "particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8.vpcf"
	elseif num == "5" then
		model = "models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl" -- Butch
		effect = "particles/econ/courier/courier_butch/courier_butch_ambient.vpcf"
	elseif num == "6" then
		model = "models/courier/doom_demihero_courier/doom_demihero_courier.vmdl" -- Golden Doomling
		effect = "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_ambient.vpcf"
	elseif num == "7" then
		model = "models/courier/huntling/huntling.vmdl" -- Golden Huntling
		effect = "particles/econ/courier/courier_huntling_gold/courier_huntling_gold_ambient.vpcf"
	elseif num == "8" then
		model = "models/items/courier/krobeling_gold/krobeling_gold.vmdl" -- Golden Krobeling
		effect = "particles/econ/courier/courier_krobeling_gold/courier_krobeling_gold_ambient.vpcf"
	elseif num == "9" then
		model = "models/courier/venoling/venoling.vmdl" -- Golden Venoling
		effect = "particles/econ/courier/courier_venoling_gold/courier_venoling_ambient_gold.vpcf"
	elseif num == "10" then
		model = "models/courier/beetlejaws/mesh/beetlejaws.vmdl" -- Beetlejaws 
		effect = "particles/econ/courier/courier_beetlejaw_gold/courier_beetlejaw_gold_ambient.vpcf"
	elseif num == "11" then
		model = "models/courier/minipudge/minipudge.vmdl" -- Pudgling
		effect = "particles/econ/courier/courier_minipudge/courier_minipudge_lvl2_ambient.vpcf"
	end
	
	
	if model ~= "" then
		local pet = CreateUnitByName( "npc_cosmetic_pet", hero:GetAbsOrigin() + RandomVector( RandomInt( 6000, 8000 ) ), true, hero, hero, hero:GetTeam() )
		pet:SetForwardVector( hero:GetAbsOrigin() )
		pet:AddNewModifier( pet, nil, "modifier_cosmetic_pet", {} )
		
		pet:SetModel( model )
		pet:SetOriginalModel( model )
		Pets.playerPets[id] = pet
		if effect ~= "" then
			ParticleManager:CreateParticle(effect, PATTACH_POINT_FOLLOW, pet )
		end
	end
end

function Pets.DeletePet( keys )
 	local id = keys.PlayerID

 	if not Pets.playerPets[id] then
 		return
	end

 	--HidePet( Pets.playerPets[id].unit, 0 )
	UTIL_Remove(Pets.playerPets[id])
	Pets.playerPets[id] = nil
end