troll_invis = class({})

function troll_invis:OnSpellStart()
    local unit = self:GetCaster()
    local id = unit:GetPlayerID()
    EmitSoundOn("Hero_Clinkz.WindWalk", unit)
    local duration = self:GetSpecialValueFor("duration")
    local bonus_movement_speed = self:GetSpecialValueFor("bonus_movement_speed")
    unit:AddNewModifier(unit, self, "modifier_generic_invisibility", { duration = duration, bonus_movement_speed = bonus_movement_speed })
   -- if Pets.playerPets[id] then
 	--	Pets.playerPets[id]:AddNewModifier(Pets.playerPets[id], self, "modifier_invisible", { duration = duration, bonus_movement_speed = bonus_movement_speed })
	--end
end

--[[
    if Pets.playerPets[id] then
 		Pets.playerPets[id]:AddNewModifier(Pets.playerPets[id], self, "modifier_invisible", {})
        Timers:CreateTimer(duration, function() Pets.playerPets[id]:RemoveModifierByName("modifier_invisible") end)   
	end
   ]]