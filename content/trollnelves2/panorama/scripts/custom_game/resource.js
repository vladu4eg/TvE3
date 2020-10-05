"use strict";

var ui = GameUI.CustomUIConfig();
(function () {
    ui.playerGold = [];
    ui.playerLumber = [];
    ui.playerFood = [];
    ui.playerMaxFood = [];
    $.Msg("Initializing resource.js... ui: ", ui);
}());

function OnPlayerLumberChanged(args) {
    // $.Msg("Player lumber changed: ", args);
    var playerID = args.playerID;
    var lumber = args.lumber;
    ui.playerLumber[playerID] = lumber;
    UpdateLumberValue();
}

function UpdateLumberValue() {
    var playerID = Players.GetLocalPlayer();
    $('#LumberText').text = ui.playerLumber[playerID];
}

function OnPlayerGoldChanged(args) {
    // $.Msg("Player gold changed: ", args);
    var playerID = args.playerID;
    var gold = args.gold;
    ui.playerGold[playerID] = gold;
    UpdateGoldValue();
}

function UpdateGoldValue() {
    var playerID = Players.GetLocalPlayer();
    $('#GoldText').text = ui.playerGold[playerID];
}

function OnPlayerFoodChanged(args) {
    $.Msg("Player food changed: ", args);
    var playerID = args.playerID;
    var food = args.food;
    var maxFood = args.maxFood;
    ui.playerFood[playerID] = food;
    ui.playerMaxFood[playerID] = maxFood;
    UpdateFoodValue();
}

function OnPlayerWispChanged(args) {
   // $.Msg("Player wisp changed: ", args);
   // var playerID = args.playerID;
   // var wisp = args.wisp;
   // var maxWisp = args.maxWisp;
  //  ui.playerWisp[playerID] = wisp;
   // ui.playerMaxWisp[playerID] = maxWisp;
  //  UpdateWispValue();
}

function UpdateFoodValue() {
    var playerID = Players.GetLocalPlayer();
    var food = ui.playerFood[playerID];
    var maxFood = ui.playerMaxFood[playerID];
    $('#CheeseText').text = food + "/" + maxFood;
}

function UpdateWispValue() {
   // var playerID = Players.GetLocalPlayer();
   // var wisp = ui.playerWisp[playerID];
   // var maxWisp = ui.playerMaxWisp[playerID];
    // $('#CheeseText').text = wisp + "/" + maxWisp;
}

function OnPlayerLumberPriceChanged(args) {
    var lumberPrice = args.lumberPrice;
    $("#LumberPriceText").text = lumberPrice;
}


var lumberPopupSchedules = {};
var lumberPopupColor = [10, 200, 90];

function TreeWispHarvestStarted(args) {
    $.Msg("Tree wisp harvest started: ", args);
    PopupNumbersInterval(lumberPopupSchedules, args.entityIndex, args.amount, args.interval, lumberPopupColor, 0, null);
}

function TreeWispHarvestStopped(args) {
    $.Msg("Tree wisp harvest stopped: ", args);
    StopNumberPopupInterval(lumberPopupSchedules, args.entityIndex);
}

var goldPopupSchedules = {};
var goldPopupColor = [255, 200, 33];

function GoldGainStarted(args) {
    $.Msg("Gold gain started: ", args);
    PopupNumbersInterval(goldPopupSchedules, args.entityIndex, args.amount, args.interval, goldPopupColor, 0, null);
}

function GoldGainStopped(args) {
    $.Msg("Gold gain stopped: ", args);
    StopNumberPopupInterval(goldPopupSchedules, args.entityIndex);
}

function PopupNumbersInterval(schedulesArray, entityIndex, amount, interval, color, presymbol, postsymbol) {
    schedulesArray[entityIndex] = $.Schedule(interval, function PopupNumberInterval() {
        PopupNumbers(entityIndex, "damage", color, 3, amount, presymbol, postsymbol);
        schedulesArray[entityIndex] = $.Schedule(interval, PopupNumberInterval);
    });
}

function StopNumberPopupInterval(schedulesArray, entityIndex) {
    $.CancelScheduled(schedulesArray[entityIndex]);
}


// -- Customizable version.
function PopupNumbers(entityIndex, pfx, color, lifetime, number, presymbol, postsymbol) {
    var pfxPath = "particles/msg_fx/msg_" + pfx + ".vpcf";
    var pidx = Particles.CreateParticle(pfxPath, ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, entityIndex);

    var digits = 0;
    if (number != null) {
        digits = number.toString().length;
    }
    if (presymbol != null) {
        digits++;
    }
    if (postsymbol != null) {
        digits++;
    }
    Particles.SetParticleControl(pidx, 1, [presymbol, number, postsymbol]);
    Particles.SetParticleControl(pidx, 2, [lifetime, digits, 0]);
    Particles.SetParticleControl(pidx, 3, color);
    Particles.ReleaseParticleIndex(pidx);
}

function PlayerPickedHero(args) {
    $.Msg("Player picked hero: ", args);
    // Ignoring args because it doesn't give player id (args.player gives playerID + 1 or is it some user id stuff?)
    // Better be safe and just get local player id.
    var localId = Players.GetLocalPlayer();
    var hero = Players.GetPlayerSelectedHero(localId);
    var panelVisibility = hero === "npc_dota_hero_treant"  ? "visible" : "collapse";
    $("#CheeseLumberPricePanel").style.visibility = panelVisibility;
}

(function () {
    GameEvents.Subscribe("player_lumber_changed", OnPlayerLumberChanged);
    GameEvents.Subscribe("player_custom_gold_changed", OnPlayerGoldChanged);
    GameEvents.Subscribe("player_food_changed", OnPlayerFoodChanged);
    GameEvents.Subscribe("player_lumber_price_changed", OnPlayerLumberPriceChanged);
    GameEvents.Subscribe("tree_wisp_harvest_start", TreeWispHarvestStarted);
    GameEvents.Subscribe("tree_wisp_harvest_stop", TreeWispHarvestStopped);
    GameEvents.Subscribe("gold_gain_start", GoldGainStarted);
    GameEvents.Subscribe("gold_gain_stop", GoldGainStopped);
	GameEvents.Subscribe("player_wisp_changed", OnPlayerWispChanged);
    GameEvents.Subscribe("dota_player_pick_hero", PlayerPickedHero);
})();
