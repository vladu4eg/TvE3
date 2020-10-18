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

function Pets.CreatePet( keys )
	local id = keys.PlayerID
	-- local old_pet = Pets.playerPets[id]
	-- local old_pet_pos
	-- local old_pet_dir
	local hero = keys.hero--PlayerResource:GetSelectedHeroEntity(id)--PlayerResource:GetPlayer( id ):GetAssignedHero()
	local model = "models/courier/baby_rosh/babyroshan_elemental.vmdl"

	-- if old_pet then
	-- 	old_pet_pos = old_pet.unit:GetAbsOrigin()
	-- 	old_pet_dir = old_pet.unit:GetForwardVector()

	-- 	old_pet.unit:Destroy()
	-- end

	local pet = CreateUnitByName( "npc_cosmetic_pet", hero:GetAbsOrigin() + RandomVector( RandomInt( 75, 150 ) ), true, hero, hero, hero:GetTeam() )

	pet:SetForwardVector( hero:GetAbsOrigin() )
	pet:AddNewModifier( pet, nil, "modifier_cosmetic_pet", {} )
	-- UnhidePet( pet )
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_disguise_smoke_top.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, pet:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )

	if tostring(PlayerResource:GetSteamID(id)) == "76561198161348907" then
		--model = "models/courier/baby_rosh/babyroshan_ti10.vmdl"
		pet:SetModel( model )
		pet:SetOriginalModel( model )
		ParticleManager:CreateParticle("particles/my_new/courier_roshan_darkmoon.vpcf", PATTACH_POINT_FOLLOW, pet )
	else
		pet:SetModel( model )
		pet:SetOriginalModel( model )

	-- if pet_data.skin then
		pet:SetMaterialGroup("1")--tostring( pet_data.skin ) )
	-- end

	-- local attach_types = {
	-- 	customorigin = PATTACH_CUSTOMORIGIN,
	-- 	point_follow = PATTACH_POINT_FOLLOW,
	-- 	absorigin_follow = PATTACH_ABSORIGIN_FOLLOW
	-- }

	-- for _, p in pairs( pet_data.particles ) do
	-- 	if type( p ) == "number" then
	-- 		local particle_data =  Pets.petsData.particles[p]
	-- 		local mat = attach_types[particle_data.attach_type] or PATTACH_POINT_FOLLOW

	-- 		local particle = ParticleManager:CreateParticle( particle_data.particle, mat, pet )

	-- 		for _, control in pairs( particle_data.control_points or {} ) do
	-- 			local pat = attach_types[control.attach_type] or PATTACH_POINT_FOLLOW

	-- 			ParticleManager:SetParticleControlEnt( particle, control.control_point_index, pet, pat, control.attachment, pet:GetAbsOrigin(), true )
	-- 		end
	-- 	else
			
			ParticleManager:CreateParticle( "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", PATTACH_POINT_FOLLOW, pet )
	-- 	end
	-- end

	-- local e = Pets.playerPetEffects[id]
	-- local c = Pets.playerPetColors[id]
	
	-- if e then
	-- 	e.particle = CreateEffect( pet, Pets.heroEffects[e.index], c and c.color or nil )
	-- end
	end

	Pets.playerPets[id] = pet
end

function Pets.DeletePet( keys )
 	local id = keys.PlayerID

 	if not Pets.playerPets[id] then
 		return
	end

 	HidePet( Pets.playerPets[id].unit, 0 )

 	Pets.playerPets[id].unit:Destroy()
 	Pets.playerPets[id] = nil
end