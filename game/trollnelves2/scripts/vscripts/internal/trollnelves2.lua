
mode = nil
require('filter')
-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function trollnelves2:_Inittrollnelves2()
  -- Setup rules
  GameRules:SetHeroRespawnEnabled(true)
  GameRules:SetUseUniversalShopMode(false)
  GameRules:SetSameHeroSelectionEnabled(true)
  GameRules:SetHeroSelectionTime(0)
  GameRules:SetStrategyTime(0)
  GameRules:SetShowcaseTime(0)
  GameRules:SetPreGameTime(PRE_GAME_TIME)
  GameRules:SetPostGameTime(120)
   -- Will finish game setup using FinishCustomGameSetup()
  GameRules:SetCustomGameSetupRemainingTime(-1)
  GameRules:SetCustomGameSetupTimeout(-1)
  GameRules:EnableCustomGameSetupAutoLaunch(false)
  GameRules:SetCustomGameSetupAutoLaunchDelay(-1)
  GameRules:SetStartingGold(0)
  GameRules:SetTreeRegrowTime(0)
  GameRules:SetUseCustomHeroXPValues(false)
  GameRules:SetGoldPerTick(0)
  GameRules:SetGoldTickTime(0)
  GameRules:SetRuneSpawnTime(0)
  GameRules:SetUseBaseGoldBountyOnHeroes(false)
  GameRules:SetFirstBloodActive(false)
  GameRules:SetHideKillMessageHeaders(true)
  GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 17)
  GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 17)
  
  
  -- Setup game mode
  mode = GameRules:GetGameModeEntity()     
  mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )  
  mode:SetRecommendedItemsDisabled(true)
  mode:SetBuybackEnabled(false)
  mode:SetTopBarTeamValuesVisible(false)
  mode:SetCustomHeroMaxLevel(1)
  mode:SetAnnouncerDisabled(false)
  mode:SetWeatherEffectsDisabled(true)
  mode:SetPauseEnabled(false)
  mode:SetStashPurchasingDisabled(true)
  mode:SetNeutralStashEnabled(false)
  mode:SetSendToStashEnabled(false)
  
  
  mode:SetMinimumAttackSpeed(MINIMUM_ATTACK_SPEED)
  mode:SetMaximumAttackSpeed(MAXIMUM_ATTACK_SPEED)
  
  mode:SetUseCustomHeroLevels ( true )
  mode:SetCameraDistanceOverride(1400)

  LinkLuaModifier("modifier_custom_armor", "libraries/modifiers/modifier_custom_armor.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_generic_invisibility", "modifiers/modifier_generic_invisibility.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("part_mod", "modifiers/parts/part_mod", LUA_MODIFIER_MOTION_NONE )
  
  -- Event Hooks
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(trollnelves2, 'OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(trollnelves2, 'OnNPCSpawned'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(trollnelves2, 'OnConnectFull'), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(trollnelves2, 'OnPlayerReconnect'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(trollnelves2, 'OnEntityKilled'), self)
  ListenToGameEvent("player_disconnect", Dynamic_Wrap(trollnelves2, 'OnDisconnect'), self)
  ListenToGameEvent('player_chat', Dynamic_Wrap(chatcommand, 'OnPlayerChat'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(trollnelves2, 'OnItemPickedUp'), self)
  
  
  -- Panorama event listeners
  CustomGameEventManager:RegisterListener("give_resources", GiveResources)
  CustomGameEventManager:RegisterListener("choose_help_side", ChooseHelpSide)
  CustomGameEventManager:RegisterListener("player_team_choose", OnPlayerTeamChoose)
  CustomGameEventManager:RegisterListener("choose_kick_side", VoteKick)
  CustomGameEventManager:RegisterListener("votekick_start", VotekickStart)
  CustomGameEventManager:RegisterListener("flag_start", FlagStart)
  CustomGameEventManager:RegisterListener("choose_flag_side", FlagGive)
  CustomGameEventManager:RegisterListener("donate_player_take", PlayerTake )
  CustomGameEventManager:RegisterListener("SelectPart", Dynamic_Wrap(wearables, 'SelectPart'))
  CustomGameEventManager:RegisterListener("SetDefaultPart", Dynamic_Wrap(wearables, 'SetDefaultPart'))
  CustomGameEventManager:RegisterListener("SetDefaultPets", Dynamic_Wrap(SelectPets, 'SetDefaultPets'))
  CustomGameEventManager:RegisterListener("UpdateTops", Dynamic_Wrap(top, 'UpdateTops'))
  
  CustomGameEventManager:RegisterListener("SelectPets", Dynamic_Wrap(SelectPets, 'SelectPets'))
  
  CustomNetTables:SetTableValue("building_settings", "team_choice_time", { value = TEAM_CHOICE_TIME })
  
 -- mode:SetItemAddedToInventoryFilter(Dynamic_Wrap(trollnelves2, "ItemPickFilter"), self)
  
  
  -- Debugging setup
  local spew = 0
  if TROLLNELVES2_DEBUG_SPEW then
    spew = 1
  end
  Convars:RegisterConvar('trollnelves2_spew', tostring(spew), 'Set to 1 to start spewing trollnelves2 debug info.  Set to 0 to disable.', 0)

  -- Change random seed
  local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
  math.randomseed(tonumber(timeTxt))
  
  DebugPrint('[TROLLNELVES2] Done loading trollnelves2!\n\n')
end

-- This function is called as the first player loads and sets up the trollnelves2 parameters
function trollnelves2:_Capturetrollnelves2()
  if mode == nil then

    self:OnFirstPlayerLoaded()
  end 
end

function trollnelves2:LoadStaticContent(contentFile)
    return trollnelves2:prequire(contentFile)
end

function trollnelves2:prequire(...)
    local status, lib = pcall(require, ...)
    if (status) then return lib end
    return nil
end
