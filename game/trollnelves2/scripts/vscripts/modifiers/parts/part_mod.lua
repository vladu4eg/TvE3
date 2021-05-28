part_mod = class({})
--------------------------------------------------------------------------------
function part_mod:GetEffectName()
    local partcls = {
    "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf", -- 1
    "particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_3.vpcf",--2
    "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient.vpcf",--3
    "particles/econ/events/ti8/ti8_hero_effect.vpcf",--4
    "particles/econ/courier/courier_hermit_crab/hermit_crab_skady_ambient.vpcf",--5
    "particles/econ/courier/courier_shagbark/courier_shagbark_ambient.vpcf",--6
    "particles/my_new/courier_roshan_darkmoon.vpcf",--7
    "particles/econ/events/ti7/ti7_hero_effect.vpcf",--8
    "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_ice.vpcf",--9
    "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf",--др 10
    "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf",--P lvl 1 11
    "particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8_flying.vpcf",--P lvl 2 12
    "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf",--P lvl 3 13
    "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf",--P lvl 4 14
    "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf",--P lvl 5 15
    "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf",--молнии платиного рошана 16
    "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf",--др2 17
    "particles/my_new/ambientfx_effigy_wm16_radiant_lvl3.vpcf",--19 /                                               18
    "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf",--23/                         19
    "particles/econ/courier/courier_greevil_purple/courier_greevil_purple_ambient_3.vpcf",--24                      20
    "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_swarm.vpcf",--сталкера 27/ 21
    "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf",--сильная трава 28
    "particles/dev/curlnoise_test.vpcf", -- много частичек 30                                                               //23
    "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf",--send roshan 34             //24
    "particles/econ/items/bane/slumbering_terror/bane_slumbering_terror_ambient_a.vpcf",--штука бейна 35                    //25
    "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf",--инвок 36                                         //26
    "particles/econ/golden_ti7.vpcf", --27
    "particles/econ/events/ti9/ti9_emblem_effect.vpcf", --28
    "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf", --29
    "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf", --30
    "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_sprint_fire.vpcf", --31
    
    "particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf", --32
    "particles/econ/events/diretide_2020/emblem/fall20_emblem_v2_effect.vpcf", --33
    "particles/econ/events/diretide_2020/emblem/fall20_emblem_v1_effect.vpcf", --34
	"particles/econ/events/diretide_2020/emblem/fall20_emblem_effect.vpcf", --35
    
    "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_casterribbons_arcana1.vpcf", --36 top2-3
    "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf", --37 top1
    "particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_lvl3.vpcf", -- 38 top1 spring
    "particles/econ/events/fall_major_2016/force_staff_fm06.vpcf", -- 39 top2 spring
    "particles/econ/events/fall_major_2016/force_staff_fm06_glow_trail.vpcf", -- 40 top3 sring

    
    
    "particles/econ/events/ti9/bottle_ti9.vpcf", -- 39 top2 sring
    "particles/econ/events/ti9/bottle_b_ti9.vpcf", -- 40 top3 spring
    
    "particles/customgames/capturepoints/cp_allied_fire.vpcf", -- крутой зеленый эффект
    
    "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_ambient.vpcf", --38
	"particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf", --39

    

    
    --"particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", --30

    --------------------------------------------------------------------------------------------------------------------------------   
   -- "particles/econ/courier/courier_crystal_rift/courier_ambient_crystal_rift.vpcf",-- 37
   -- "particles/econ/courier/courier_oculopus/courier_oculopus_ambient.vpcf",-- 38
   -- "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_detail.vpcf",-- 39
    --"particles/econ/items/skywrath_mage/hero_skywrath_dpits3_wings/skywrath_dpits3_backwing_p.vpcf",-- 40
   -- "particles/econ/courier/courier_gold_horn/courier_gold_horn_ambient.vpcf",--old др 41
    -------
       -- "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf",-- 18
         --  "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient_lvl4.vpcf",-- 20
  --  "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf",--21
  --  "particles/econ/items/ember_spirit/ember_spirit_vanishing_flame/ember_spirit_vanishing_flame_ambient.vpcf",--22
    --  "particles/econ/courier/courier_greevil_yellow/courier_greevil_yellow_ambient_3.vpcf",--25
   -- "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_2.vpcf",--26
      -- "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_bloom_ambient.vpcf",--слабые золотые частички 29 /22
         -- "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient.vpcf",--розавая дичь 31
    --"particles/econ/items/sniper/sniper_charlie/sniper_shrapnel_charlie_ground.vpcf",--поляна 32
   -- "particles/econ/courier/courier_faceless_rex/cour_rex_ground_a.vpcf",--"шипы" из под земли 33
    "particles/econ/courier/courier_baekho/courier_baekho_ambient.vpcf",--слабая розавая дичь 42
    "particles/econ/courier/courier_jade_horn/courier_jade_horn_ambient.vpcf",--слабый зелёный эффект 43
    "particles/econ/courier/courier_red_horn/courier_red_horn_ambient.vpcf",--слабый красный эффект 44
    "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_arcana_ground_ambient.vpcf",--слабые снежинки под ногами 45
    "particles/econ/courier/courier_smeevil_flying_carpet/courier_smeevil_flying_carpet_ambient.vpcf",--слабые очень маленикие жёлтые частички 46
    
    }
	return partcls[self:GetStackCount()]
end

function part_mod:IsHidden() 
	return true
end
--------------------------------------------------------------------------------
function part_mod:OnCreated( kv )
    if IsServer() then
        self:SetStackCount(tonumber(kv.part))
    end
end

function part_mod:IsPurgable()
	return false
end

function part_mod:RemoveOnDeath()
    return false
end