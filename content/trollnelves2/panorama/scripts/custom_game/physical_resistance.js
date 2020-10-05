'use strict';

var altLabel;
var tooltips;
var tooltipLabel;

(function () {
    var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements");
    var centerBlock = newUI.FindChildTraverse("center_block");
    altLabel = centerBlock.FindChildTraverse("PhysicalDamageResist");

    tooltips = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("Tooltips");

    GameEvents.Subscribe('dota_portrait_unit_stats_changed', UpdatePhysicalResistanceValues);
    GameEvents.Subscribe('dota_portrait_unit_modifiers_changed', UpdatePhysicalResistanceValues);
    GameEvents.Subscribe('dota_player_update_hero_selection', UpdatePhysicalResistanceValues);
    GameEvents.Subscribe('dota_player_update_selected_unit', UpdatePhysicalResistanceValues);
    GameEvents.Subscribe('dota_player_update_query_unit', UpdatePhysicalResistanceValues);
}());

function GetTooltipLabel() {
    if (tooltipLabel == null) {
        tooltipLabel = tooltips.FindChildTraverse("PhysicalResist");
    }
    return tooltipLabel;
}

function UpdatePhysicalResistanceValues() {
    var unit = Players.GetLocalPlayerPortraitUnit();
    var armor = Entities.GetPhysicalArmorValue(unit);
    // Would be better to get the value from the server instead of calculating it client-side, but not sure how to do that
    var physicalResistance = 0.06 * armor / (1 + 0.06 * Math.abs(armor)) * 100
    var text = Math.round(physicalResistance * 100) / 100 + "%";
    altLabel.text = text;
    var tLabel = GetTooltipLabel();
    if (tLabel != null) {
        tLabel.text = text;
    }
}