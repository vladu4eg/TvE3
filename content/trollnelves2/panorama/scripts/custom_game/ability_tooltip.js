function setupTooltip() {
    var text;
    var abilityName = $.GetContextPanel().GetAttributeString("abilityName", null);
    var caster = $.GetContextPanel().GetAttributeInt("entityIndex", 0);
    var locName = $.Localize("DOTA_Tooltip_ability_" + abilityName);
    var locDescription = $.Localize("DOTA_Tooltip_ability_" + abilityName + "_Description");
    var upgradedUnitName = CustomNetTables.GetTableValue("buildings", abilityName) && CustomNetTables.GetTableValue("buildings", abilityName).upgradeUnitName || "";
    var building = caster && CustomNetTables.GetTableValue("buildings", Entities.GetUnitName(caster));
    var resources = (building && upgradedUnitName.length > 0 && building[upgradedUnitName]) || CustomNetTables.GetTableValue("buildings", abilityName) || CustomNetTables.GetTableValue("abilities", abilityName);
    var gold_cost = resources && resources.gold_cost || 0;
    var lumber_cost = resources && resources.lumber_cost || 0;
    var food_cost = resources && resources.food_cost || 0; 
    var requirementsObject = upgradedUnitName.length > 0 && CustomNetTables.GetTableValue("buildings", (Players.GetLocalPlayer() + upgradedUnitName)) || {};
    var requirementKeys = Object.keys(requirementsObject);
    var gold_gain = upgradedUnitName.length > 0 && CustomNetTables.GetTableValue("buildings", upgradedUnitName) && CustomNetTables.GetTableValue("buildings", upgradedUnitName).gold_gain || 0;

    var item = CustomNetTables.GetTableValue("items", "buy_" + abilityName) || CustomNetTables.GetTableValue("items", abilityName);
    var stats_name = item && item.bonus_stats && $.Localize(item.bonus_stats) || "";
    var stats_amount = item && item.bonus_stats && item.bonus_value || "";
    var item_gold = item && item.gold_cost || "";
    var item_lumber = item && item.lumber_cost || "";



    var harvestAbility = (caster && CustomNetTables.GetTableValue("abilities", Entities.GetUnitName(caster))) || (abilityName && CustomNetTables.GetTableValue("abilities", abilityName.substr(6)));
    var lumber_interval = harvestAbility && harvestAbility.lumber_interval || 0;
    var lumber_amount = harvestAbility && harvestAbility.amount || 0;

    var repair = (abilityName && (abilityName.indexOf("repair") > -1 || abilityName.indexOf("train") > -1)) && (CustomNetTables.GetTableValue("abilities", Entities.GetUnitName(caster)) || abilityName && CustomNetTables.GetTableValue("abilities", abilityName.substr(6)));
    var repair_speed = repair && repair.speed || 0;

    SetText("AbilityName", locName + "     ");
    SetText("costs", (gold_cost > 0 ? ("<img src='file://{images}/custom_game/gold_icon32.png'/>" + gold_cost) : "") + (lumber_cost > 0 ? ("<img src='file://{images}/custom_game/lumber_icon32.png'/>" + lumber_cost) : "") + (food_cost > 0 ? ("<img src='file://{images}/custom_game/cheese_icon32.png'/>" + food_cost) : ""));
    SetText("description", locDescription);
    var reqText = "";
    if (requirementKeys.length > 0) {
        reqText = reqText + "<br>Requirements:";
    }
    for (var requirementKey of requirementKeys) {
        reqText = reqText + "<br>" + $.Localize(requirementsObject[requirementKey]);
    }
    SetText("requirements", reqText);
    SetText("gold_gain", (gold_gain > 0 && "Gold per second:" + gold_gain || ""));
    SetText("item_stats", (stats_name + ":" + stats_amount));
    SetText("item_gold", (item_gold > 0 ? ("<img src='file://{images}/custom_game/gold_icon32.png'/>" + item_gold) : ""));
    SetText("item_lumber", (item_lumber > 0 ? ("<img src='file://{images}/custom_game/lumber_icon32.png'/>" + item_lumber) : ""));
    SetText("lumber_interval", lumber_interval > 0 && "Gather interval: " + lumber_interval || "");
    SetText("lumber_amount", lumber_amount > 0 && "Lumber amount: " + lumber_amount || "");
    SetText("repair_speed", repair_speed > 0 && "Repair speed: " + repair_speed || "");

}

function SetText(panelID, text) {
    var panel = $("#" + panelID);
    panel.text = text;
    // panel.style.width = "fit-children";
    if (text.length > 2) {
        panel.style.maxHeight = "500px";
    } else {
        panel.style.maxHeight = "0";
    }
}
