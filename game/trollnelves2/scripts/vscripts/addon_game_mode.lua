-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('trollnelves2')
require("libraries/buildinghelper")
require('settings')
require("PrecacheLoad")

function Precache( context )
	--[[
		This function is used to precache resources/units/items/abilities that will be needed
		for sure in your game and that will not be precached by hero selection.  When a hero
		is selected from the hero selection screen, the game will precache that hero's assets,
		any equipped cosmetics, and perform the data-driven precaching defined in that hero's
		precache{} block, as well as the precache{} block for any equipped abilities.
		
		See trollnelves2:PostLoadPrecache() in trollnelves2.lua for more information
	]]
	
	DebugPrint("[TROLLNELVES2] Performing pre-load precache")
	
	-- Particles can be precached individually or by folder
	-- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
	-- Models can also be precached by folder or individually
	-- PrecacheModel should generally used over PrecacheResource for individual models
	-- Sounds can precached here like anything else
	
	-- Entire items can be precached by name
	-- Abilities can also be precached in this way despite the name
	PrecacheItemByNameSync("item_root_ability", context)
	PrecacheItemByNameSync("item_silence_ability", context)
	PrecacheItemByNameSync("item_glyph_ability", context)
	PrecacheItemByNameSync("item_night_ability", context)	
	PrecacheItemByNameSync("item_blink_datadriven", context)
	
	-- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
	-- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
	PrecacheUnitByNameSync(ELF_HERO, context)
	PrecacheUnitByNameSync(TROLL_HERO, context)
	PrecacheUnitByNameSync(WOLF_HERO, context)
	PrecacheUnitByNameSync(ANGEL_HERO, context)
	PrecacheUnitByNameSync(BEAR_HERO, context)
	PrecacheUnitByNameSync("tent", context)
	PrecacheUnitByNameSync("tent_2", context)
	PrecacheUnitByNameSync("tent_3", context)
	PrecacheUnitByNameSync("tent_4", context)
	PrecacheUnitByNameSync("tent_5", context)
	PrecacheUnitByNameSync("tent_6", context)
	PrecacheUnitByNameSync("tent_7", context)
	PrecacheUnitByNameSync("barracks_1", context)
	PrecacheUnitByNameSync("barracks_2", context)
	PrecacheUnitByNameSync("barracks_3", context)
	PrecacheUnitByNameSync("rock_1", context)
	PrecacheUnitByNameSync("rock_2", context)
	PrecacheUnitByNameSync("rock_3", context)
	PrecacheUnitByNameSync("rock_4", context)
	PrecacheUnitByNameSync("rock_5", context)
	PrecacheUnitByNameSync("rock_6", context)
	PrecacheUnitByNameSync("rock_7", context)
	PrecacheUnitByNameSync("rock_8", context)
	PrecacheUnitByNameSync("rock_9", context)
	PrecacheUnitByNameSync("rock_10", context)
	PrecacheUnitByNameSync("rock_11", context)
	PrecacheUnitByNameSync("rock_12", context)
	PrecacheUnitByNameSync("rock_13", context)
	PrecacheUnitByNameSync("rock_14", context)
	PrecacheUnitByNameSync("rock_15", context)
	PrecacheUnitByNameSync("rock_16", context)
	PrecacheUnitByNameSync("rock_17", context)
	PrecacheUnitByNameSync("rock_18", context)
	PrecacheUnitByNameSync("rock_19", context)
	PrecacheUnitByNameSync("rock_20", context)
	PrecacheUnitByNameSync("rock_21", context)
	PrecacheUnitByNameSync("rock_22", context)
	PrecacheUnitByNameSync("tower_1", context)
	PrecacheUnitByNameSync("tower_2", context)
	PrecacheUnitByNameSync("tower_3", context)
	PrecacheUnitByNameSync("tower_4", context)
	PrecacheUnitByNameSync("tower_5", context)
	PrecacheUnitByNameSync("tower_6", context)
	PrecacheUnitByNameSync("tower_7", context)
	PrecacheUnitByNameSync("tower_8", context)
	PrecacheUnitByNameSync("tower_9", context)
	PrecacheUnitByNameSync("tower_10", context)
	PrecacheUnitByNameSync("tower_10_1", context)
	PrecacheUnitByNameSync("tower_11", context)
	PrecacheUnitByNameSync("tower_11_1", context)
	PrecacheUnitByNameSync("tower_12", context)
	PrecacheUnitByNameSync("tower_13", context)
	PrecacheUnitByNameSync("tower_14", context)
	PrecacheUnitByNameSync("tower_15", context)
	PrecacheUnitByNameSync("tower_15_1", context)
	PrecacheUnitByNameSync("tower_16", context)
	PrecacheUnitByNameSync("tower_17", context)
	PrecacheUnitByNameSync("tower_18", context)
	PrecacheUnitByNameSync("tower_19", context)
	PrecacheUnitByNameSync("tower_19_1", context)
	PrecacheUnitByNameSync("tower_19_2", context)
	PrecacheUnitByNameSync("tower_20", context)
	PrecacheUnitByNameSync("tower_21", context)
	PrecacheUnitByNameSync("true_sight_tower", context)
	PrecacheUnitByNameSync("trader_1", context)
	PrecacheUnitByNameSync("trader_2", context)
	PrecacheUnitByNameSync("trader_3", context)
	PrecacheUnitByNameSync("workers_guild", context)
	PrecacheUnitByNameSync("mother_of_nature", context)
	PrecacheUnitByNameSync("research_lab", context)
	PrecacheUnitByNameSync("research_lab_2", context)
	PrecacheUnitByNameSync("research_lab_3", context)
	PrecacheUnitByNameSync("research_lab_4_1", context)
	PrecacheUnitByNameSync("research_lab_4_2", context)
	PrecacheUnitByNameSync("research_lab_4_3", context)
	PrecacheUnitByNameSync("research_lab_4_4", context)
	PrecacheUnitByNameSync("research_lab_4_5", context)
	PrecacheUnitByNameSync("research_lab_5_!", context)
	PrecacheUnitByNameSync("worker_1", context)
	PrecacheUnitByNameSync("worker_2", context)
	PrecacheUnitByNameSync("worker_3", context)
	PrecacheUnitByNameSync("worker_4", context)
	PrecacheUnitByNameSync("worker_5", context)
	PrecacheUnitByNameSync("worker_6", context)
	PrecacheUnitByNameSync("gold_mine_1", context)
	PrecacheUnitByNameSync("gold_mine_2", context)
	PrecacheUnitByNameSync("gold_mine_3", context)
	PrecacheUnitByNameSync("gold_mine_4", context)
	PrecacheUnitByNameSync("gold_mine_5", context)
	PrecacheUnitByNameSync("gold_mine_6", context)
	PrecacheUnitByNameSync("gold_mine_7", context)
	PrecacheUnitByNameSync("gold_mine_8", context)
	PrecacheUnitByNameSync("wisp_1", context)
	PrecacheUnitByNameSync("wisp_2", context)
	PrecacheUnitByNameSync("wisp_3", context)
	PrecacheUnitByNameSync("wisp_4", context)
	PrecacheUnitByNameSync("wisp_5", context)
	PrecacheUnitByNameSync("wisp_6", context)
	PrecacheUnitByNameSync("wisp_7", context)
	PrecacheUnitByNameSync("wisp_8", context)
	PrecacheUnitByNameSync("gold_wisp", context)
	PrecacheUnitByNameSync("troll_hut_1", context)
	PrecacheUnitByNameSync("troll_hut_2", context)
	PrecacheUnitByNameSync("troll_hut_3", context)
	PrecacheUnitByNameSync("troll_hut_4", context)
	PrecacheUnitByNameSync("troll_hut_5", context)
	PrecacheUnitByNameSync("troll_hut_6", context)
	PrecacheUnitByNameSync("weapon_shop", context)
	PrecacheUnitByNameSync("armor_shop", context)
	PrecacheUnitByNameSync("hp_shop", context)
	PrecacheUnitByNameSync("hp_reg_shop", context)
	PrecacheUnitByNameSync("atk_spd_shop", context)
	
	PrecacheResource("particle","particles/buildinghelper/square_overlay.vpcf", context)
	PrecacheResource("particle","particles/buildinghelper/range_overlay.vpcf", context)
	PrecacheResource("particle","particles/buildinghelper/ghost_model.vpcf", context)
	PrecacheResource("particle","particles/buildinghelper/square_sprite.vpcf", context)
	PrecacheResource("particle","particles/ui_mouseactions/range_display.vpcf", context)
	
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
	PrecacheResource("particle","particles/econ/events/league_teleport_2014/teleport_end_league.vpcf",context)
	PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_sven.vsndevts",context)
	PrecacheResource("particle","particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf",context)
	PrecacheResource("particle","particles/generic_gameplay/generic_stunned.vpcf",context)
	
	PrecacheResource("particle","particles/units/heroes/hero_mirana/mirana_base_attack.vpcf",context)
	PrecacheResource("particle","particles/base_attacks/ranged_tower_good.vpcf",context)
	PrecacheResource("particle","particles/base_attacks/ranged_tower_bad.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf",context)  
	PrecacheResource("particle","particles/units/heroes/hero_drow/drow_frost_arrow.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_vengeful/vengeful_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_luna/luna_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_medusa/medusa_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_enigma/enigma_base_attack.vpcf",context)
	PrecacheResource("particle","particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf",context)
	
	PrecacheResource("particle", "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_3.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient.vpcf", context)
	PrecacheResource("particle", "particles/my_new/courier_roshan_darkmoon.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_shagbark/courier_shagbark_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti7/ti7_hero_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_ice.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8_flying.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf", context)
	-- PrecacheResource("particle", "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti8/ti8_hero_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_hermit_crab/hermit_crab_skady_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf", context)
    PrecacheResource("particle", "particles/my_new/ambientfx_effigy_wm16_radiant_lvl3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient_lvl4.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/ember_spirit/ember_spirit_vanishing_flame/ember_spirit_vanishing_flame_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_purple/courier_greevil_purple_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_yellow/courier_greevil_yellow_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_2.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_swarm.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_bloom_ambient.vpcf", context)
    PrecacheResource("particle", "particles/dev/curlnoise_test.vpcf",  context)
    PrecacheResource("particle", "particles/econ/courier/courier_axolotl_ambient/courier_axolotl_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/sniper/sniper_charlie/sniper_shrapnel_charlie_ground.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_faceless_rex/cour_rex_ground_a.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/bane/slumbering_terror/bane_slumbering_terror_ambient_a.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_crystal_rift/courier_ambient_crystal_rift.vpcf", context)
    PrecacheResource("particle", "particles/econ/courier/courier_oculopus/courier_oculopus_ambient.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_detail.vpcf", context)
	PrecacheResource("particle", "particles/econ/golden_ti7.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/ti9/ti9_emblem_effect.vpcf", context)
    PrecacheResource("particle", "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/undying/undying_scourge/undying_scourge_blade_elec.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_sprint_fire.vpcf", context)
	
	PrecacheResource("particle", "particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/diretide_2020/emblem/fall20_emblem_v2_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/diretide_2020/emblem/fall20_emblem_v1_effect.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/diretide_2020/emblem/fall20_emblem_effect.vpcf", context)
	
	PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_arms/venomancer_hydra_switch_color_arms.vmdl", context)
    PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_shoulder/venomancer_hydra_switch_color_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_head/venomancer_hydra_switch_color_head.vmdl", context)
    PrecacheResource("model", "models/items/venomancer/venomancer_hydra_switch_color_tail/venomancer_hydra_switch_color_tail.vmdl", context)        
    
	PrecacheResource("model", "models/items/drow/drow_ti9_immortal_weapon/drow_ti9_immortal_weapon.vmdl", context)
    PrecacheResource("model", "models/items/drow/mask_of_madness/mask_of_madness.vmdl", context)
    PrecacheResource("model", "models/items/drow/frostfeather_huntress_shoulder/frostfeather_huntress_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/drow/frostfeather_huntress_misc/frostfeather_huntress_misc.vmdl", context)
    PrecacheResource("model", "models/items/drow/ti6_immortal_cape/mesh/drow_ti6_immortal_cape.vmdl", context)       
    PrecacheResource("model", "models/items/drow/frostfeather_huntress_arms/frostfeather_huntress_arms.vmdl", context)
    PrecacheResource("model", "models/items/drow/frostfeather_huntress_legs/frostfeather_huntress_legs.vmdl", context) 
    PrecacheResource("particle", "particles/econ/items/drow/drow_ti6_gold/drow_ti6_ambient_gold.vpcf", context)
   
   --PrecacheResource("model", "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl", context)
   -- PrecacheResource("model", "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl", context)
   -- PrecacheResource("model", "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl", context)
   -- PrecacheResource("model", "models/items/windrunner/ti6_windranger_back/ti6_windranger_back.vmdl", context)
   -- PrecacheResource("model", "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/vengefulspirit/fallenprincess_head/fallenprincess_head.vmdl", context)
    PrecacheResource("model", "models/items/vengefulspirit/fallenprincess_legs/fallenprincess_legs.vmdl", context)
    PrecacheResource("model", "models/items/vengefulspirit/fallenprincess_weapon/fallenprincess_weapon.vmdl", context)
    PrecacheResource("model", "models/items/vengefulspirit/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder.vmdl", context)
	PrecacheResource("particle", "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_shoulder_crimson_ambient.vpcf", context)
    
	PrecacheResource("model", "models/items/shadow_fiend/arms_deso/arms_deso.vmdl", context)
    PrecacheResource("model", "models/heroes/shadow_fiend/head_arcana.vmdl", context)
    PrecacheResource("model", "models/items/nevermore/sf_souls_tyrant_shoulder/sf_souls_tyrant_shoulder.vmdl", context)
    
	PrecacheResource("model", "models/items/lanaya/raiment_of_the_violet_archives_shoulder/raiment_of_the_violet_archives_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/lanaya/raiment_of_the_violet_archives_armor/raiment_of_the_violet_archives_armor.vmdl", context)
    PrecacheResource("model", "models/items/lanaya/raiment_of_the_violet_archives_head_hood/raiment_of_the_violet_archives_head_hood.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_head/luna_ti7_set_head.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_mount/luna_ti7_set_mount.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_shoulder/luna_ti7_set_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_weapon/luna_ti7_set_weapon.vmdl", context)
    PrecacheResource("model", "models/items/luna/luna_ti7_set_offhand/luna_ti7_set_offhand.vmdl", context)
   
   PrecacheResource("model", "models/items/medusa/dotaplus_medusa_weapon/dotaplus_medusa_weapon.vmdl", context)
    PrecacheResource("model", "models/items/medusa/daughters_of_hydrophiinae/daughters_of_hydrophiinae.vmdl", context)
	PrecacheResource("model", "models/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_immortal_tail.vmdl", context)
    PrecacheResource("model", "models/items/medusa/dotaplas_medusa_head/dotaplas_medusa_head.vmdl", context)
    PrecacheResource("model", "models/items/medusa/dotaplus_medusa_arms/dotaplus_medusa_arms.vmdl", context)
	
	PrecacheResource("model", "models/items/enigma/tentacular_conqueror_armor/tentacular_conqueror_armor.vmdl", context)
    PrecacheResource("model", "models/items/enigma/tentacular_conqueror_arms/tentacular_conqueror_arms.vmdl", context)
    PrecacheResource("model", "models/items/enigma/tentacular_conqueror_head/tentacular_conqueror_head.vmdl", context) 
	
	PrecacheResource("particle", "particles/items_fx/blink_dagger_end.vpcf", context) 
	PrecacheResource("particle", "particles/items_fx/blink_dagger_start.vpcf", context) 
	PrecacheResource("particle", "particles/ui_mouseactions/ping_circle_static.vpcf", context) 
	
	PrecacheResource("model", "models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution_flying.vmdl", context) 
	PrecacheResource("model", "models/items/courier/little_sapplingnew_bloom_style/little_sapplingnew_bloom_style_flying.vmdl", context)
    PrecacheResource("model", "models/courier/baby_winter_wyvern/baby_winter_wyvern_flying.vmdl", context)
	
	PrecacheResource("model", "models/heroes/alchemist/alchemist.vmdl", context) 
	PrecacheResource("model", "models/items/world/towers/ti10_radiant_tower/ti10_radiant_tower.vmdl", context)
	
	PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_cape.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_quiver.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_head.vmdl", context)
    PrecacheResource("model", "models/items/windrunner/windrunner_arcana/wr_arcana_weapon.vmdl", context)
	PrecacheResource("particle", "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_bow_ambient.vpcf", context) 
	
	PrecacheResource("particle", "particles/msg_fx/msg_damage.vpcf", context)
	PrecacheResource("particle_folder", "particles/msg_fx", context)
	
	PrecacheResource("model", "models/items/viper/king_viper_head/king_viper_head.vmdl", context)
    PrecacheResource("model", "models/items/viper/king_viper_back/king_viper_back.vmdl", context)
    PrecacheResource("model", "models/items/viper/king_viper_tail/viper_king_viper_tail.vmdl", context)
	PrecacheResource("particle", "particles/units/heroes/hero_viper/viper_base_attack.vpcf", context)
	
	PrecacheResource("model", "models/items/nevermore/ferrum_chiroptera_head/ferrum_chiroptera_head.vmdl", context)
    PrecacheResource("model", "models/items/nevermore/ferrum_chiroptera_shoulder/ferrum_chiroptera_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/nevermore/ferrum_chiroptera_arms/ferrum_chiroptera_arms.vmdl", context)
	PrecacheResource("particle", "particles/units/heroes/hero_nevermore/shadow_fiend_ambient_eyes.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_head_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_ferrum/shadow_fiend_ferrum_shoulder_ambient.vpcf", context)
	PrecacheResource("model", "models/items/courier/serpent_warbler/serpent_warbler_flying.vmdl", context)
	PrecacheResource("model", "models/items/courier/ig_dragon/ig_dragon_flying.vmdl", context)
	
	PrecacheResource("model", "models/items/wards/frozen_formation/frozen_formation.vmdl", context)
	PrecacheResource("model", "models/items/wards/sylph_ward/sylph_ward.vmdl", context)
	PrecacheResource("model", "models/items/wards/watcher_below_ward/watcher_below_ward.vmdl", context)
	PrecacheResource("model", "models/items/wards/megagreevil_ward/megagreevil_ward.vmdl", context)
	
	PrecacheResource("particle", "particles/units/heroes/hero_sniper/sniper_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", context)
	
	PrecacheResource("model", "models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl", context)
    PrecacheResource("model", "models/items/sniper/witch_hunter_set_shoulder/witch_hunter_set_shoulder.vmdl", context)
    PrecacheResource("model", "models/items/sniper/witch_hunter_set_arms/witch_hunter_set_arms.vmdl", context)
    PrecacheResource("model", "models/items/sniper/witch_hunter_set_head/witch_hunter_set_head.vmdl", context)
    PrecacheResource("model", "models/items/sniper/witch_hunter_set_back/witch_hunter_set_back.vmdl", context)
	--pets
	PrecacheResource("model", "models/courier/baby_rosh/babyroshan.vmdl", context)
    PrecacheResource("model", "models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl", context)
    PrecacheResource("model", "models/courier/doom_demihero_courier/doom_demihero_courier.vmdl", context)
    PrecacheResource("model", "models/courier/huntling/huntling.vmdl", context)
    PrecacheResource("model", "models/items/courier/krobeling_gold/krobeling_gold.vmdl", context)
	PrecacheResource("model", "models/courier/venoling/venoling.vmdl", context)
    PrecacheResource("model", "models/courier/beetlejaws/mesh/beetlejaws.vmdl", context)
	PrecacheResource("particle", "particles/econ/courier/courier_butch/courier_butch_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_golden_doomling/courier_golden_doomling_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_huntling_gold/courier_huntling_gold_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_krobeling_gold/courier_krobeling_gold_ambient.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_venoling_gold/courier_venoling_ambient_gold.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_beetlejaw_gold/courier_beetlejaw_gold_ambient.vpcf", context)

	
	--Halloween
--	PrecacheResource("model", "models/heroes/death_prophet/death_prophet.vmdl", context)
--	PrecacheResource("model", "models/items/death_prophet/drowned_siren_head/drowned_siren_head.vmdl", context)
  --  PrecacheResource("model", "models/items/death_prophet/drowned_siren_drowned_siren_skirt/drowned_siren_drowned_siren_skirt.vmdl", context)
  --  PrecacheResource("model", "models/items/death_prophet/drowned_siren_armor/drowned_siren_armor.vmdl", context)
   -- PrecacheResource("model", "models/items/death_prophet/exorcism/drowned_siren_drowned_siren_crowned_fish/drowned_siren_drowned_siren_crowned_fish.vmdl", context)
  --  PrecacheResource("model", "models/items/death_prophet/drowned_siren_misc/drowned_siren_misc.vmdl", context)
	
--	PrecacheResource("model", "models/heroes/life_stealer/life_stealer.vmdl", context)
	--PrecacheResource("model", "models/items/lifestealer/bloody_ripper_belt/bloody_ripper_belt.vmdl", context)
  --  PrecacheResource("model", "models/items/lifestealer/promo_bloody_ripper_back/promo_bloody_ripper_back.vmdl", context)
   -- PrecacheResource("model", "models/items/lifestealer/bloody_ripper_arms/bloody_ripper_arms.vmdl", context)       
   -- PrecacheResource("model", "models/items/lifestealer/bloody_ripper_head/bloody_ripper_head.vmdl", context)  
	
 --  PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_weapon.vmdl", context)
  --  PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_arms.vmdl", context)
  --  PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_shoulder.vmdl", context)
  --  PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_armor.vmdl", context)
   -- PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_back.vmdl", context)
    --PrecacheResource("model", "models/items/wraith_king/arcana/wraith_king_arcana_head.vmdl", context)	
	
	--PrecacheResource("model", "models/heroes/pudge/pudge.vmdl", context)
	--PrecacheResource("model", "models/items/pudge/blackdeath_offhand/blackdeath_offhand.vmdl", context)
   -- PrecacheResource("model", "models/items/pudge/blackdeath_belt/blackdeath_belt.vmdl", context)
    --PrecacheResource("model", "models/items/pudge/blackdeath_head/blackdeath_head.vmdl", context)
    --PrecacheResource("model", "models/items/pudge/blackdeath_back/blackdeath_back.vmdl", context)
   -- PrecacheResource("model", "models/items/pudge/blackdeath_weapon/blackdeath_weapon.vmdl", context)
   -- PrecacheResource("model", "models/items/pudge/blackdeath_shoulder/blackdeath_shoulder.vmdl", context)
	--PrecacheResource("model", "models/items/pudge/blackdeath_arms/blackdeath_arms.vmdl", context)
	
	--PrecacheResource("model", "models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl", context)
	-- End Halloween
	
	PrecacheLoad:PrecacheLoad (context)
	
	GameRules.pc = context
	trollnelves2().pc = context
	
end

-- Create the game mode when we activate
function Activate()
	GameRules.MapSpeed = tonumber(string.match(GetMapName(),"%d+")) or 1
	GameRules.lumberPrice = STARTING_LUMBER_PRICE
	GameRules.maxFood = STARTING_MAX_FOOD
	GameRules.maxWisp = STARTING_MAX_WISP
	GameRules.playerTeamChoices = {}
	GameRules.dcedChoosers = {}
	GameRules.trollTps = {Vector(-320,-320,256),Vector(0,-320,256),Vector(320,-320,256),Vector(-320,-640,256),Vector(0,-640,256),Vector(320,-640,256),Vector(-320,0,256),Vector(0,0,256),Vector(320,0,256),}
	GameRules.angel_spawn_points = Entities:FindAllByName("angel_spawn_point")
	GameRules.shops = Entities:FindAllByClassname("trigger_shop")
	GameRules.base = Entities:FindAllByName("trigger_base")
	GameRules.baseBlock = Entities:FindAllByName("trigger_antibild")
	GameRules.startTime = nil
	GameRules.colorCounter = 1
	GameRules.gold = {}
	GameRules.lumber = {}
	GameRules.goldGained = {}
	GameRules.lumberGained = {}
	GameRules.goldGiven = {}
	GameRules.lumberGiven = {}
	GameRules.scores = {}
	GameRules.types = {}
	GameRules.trollID = nil
	GameRules.trollHero = nil
	GameRules.Bonus = {}
	GameRules.BonusPercent = 0
	GameRules.BonusTrollIDs = {}
	GameRules.PartDefaults = {}
	GameRules.PetsDefaults = {}
	GameRules.Score = {}
	GameRules.PlayersBase = {}
	GameRules.PlayersFPS = {}
	GameRules.test = false
	GameRules.PlayersCount = 0
	GameRules.KickList = {}
	
	GameRules.trollnelves2 = trollnelves2()
	GameRules.trollnelves2:Inittrollnelves2()
end
