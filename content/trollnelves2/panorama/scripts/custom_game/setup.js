var customHealthRegenLabel;
var customHpReg = {};
var itemHotkeys = [];
var uiWaitingSchedules = [];
(function () {
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false );      //Time of day (clock).
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES, false);     //Heroes and team score at the top of the HUD.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false);      //Lefthand flyout scoreboard.
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_PANEL, false );     //Hero actions UI.
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP, false );     //Minimap.
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PANEL, false );      //Entire Inventory UI
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP, false);     //Shop portion of the Inventory.
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_ITEMS, false );      //Player items.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false);     //Quickbuy.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false);      //Courier controls.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, false);      //Glyph.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, false);     //Gold display.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false);      //Suggested items shop panel.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS, false);     //Hero selection Radiant and Dire player lists.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME, false);     //Hero selection game mode name display.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK, false);     //Hero selection clock.
    //GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_MENU_BUTTONS, false );     //Top-left menu buttons in the HUD.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false);      //Endgame scoreboard.
    GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND, false);     //Top-left menu buttons in the HUD.

    // These lines set up the panorama colors used by each team (for game select/setup, etc)
    GameUI.CustomUIConfig().team_colors = {}
    GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_GOODGUYS] = "#00CC00;";
    GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_BADGUYS] = "#FF0000;";

    var tooltipManager = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("Tooltips");
    tooltipManager.AddClass("CustomTooltipStyle");

    var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements");
    var centerBlock = newUI.FindChildTraverse("center_block");

    newUI.FindChildTraverse("RadarButton").style.visibility = "collapse";

    //Use 284 if you want to keep 4 ability minimum size, and only use 160 if you want ~2 ability min size
    centerBlock.FindChildTraverse("AbilitiesAndStatBranch").style.minWidth = "284px";

    centerBlock.FindChildTraverse("StatBranch").style.visibility = "collapse";
    //you are not spawning the talent UI, fuck off (Disabling mouseover and onactivate)
    //We also don't want to crash, valve plz
    centerBlock.FindChildTraverse("StatBranch").SetPanelEvent("onmouseover", function () {
    });
    centerBlock.FindChildTraverse("StatBranch").SetPanelEvent("onactivate", function () {
    });

    // Remove xp circle
    centerBlock.FindChildTraverse("xp").style.visibility = "collapse";
    centerBlock.FindChildTraverse("stragiint").style.visibility = "collapse";
    //Fuck that levelup button
    centerBlock.FindChildTraverse("level_stats_frame").style.visibility = "collapse";
    // Hide tp slot
    centerBlock.FindChildTraverse("inventory_tpscroll_container").style.visibility = "collapse";

    //fuck backpack UI (We have Lua filling these slots with junk, and if the player can't touch them it should be effectively disabled)
    var inventory = centerBlock.FindChildTraverse("inventory").FindChildTraverse("inventory_items");
    var backpack = inventory.FindChildTraverse("inventory_backpack_list")
    backpack.style.visibility = "collapse";
    //Add resource panel instead of backpack 
    var resourcePanel = $.CreatePanel("Panel", inventory, "");
    resourcePanel.BLoadLayout("file://{resources}/layout/custom_game/resource.xml", false, false);

    var healthContainer = centerBlock.FindChildTraverse("HealthContainer");
    InitializeCustomHpRegenLabel(healthContainer);
    healthContainer.FindChildTraverse("HealthRegenLabel").style.visibility = "collapse";

    SetupUnusedItemHotkeys();

    GameEvents.Subscribe("gameui_activated", UpdateUI);
    GameEvents.Subscribe("dota_inventory_changed", UpdateItemTooltipsAndAbilityCustomHotkeys);
    GameEvents.Subscribe("dota_inventory_item_changed", UpdateItemTooltipsAndAbilityCustomHotkeys);
    GameEvents.Subscribe("dota_player_update_selected_unit", UpdateUI);
    GameEvents.Subscribe("dota_player_update_query_unit", UpdateUI);
    GameEvents.Subscribe("game_rules_state_change", HidePickScreen);
    GameEvents.Subscribe("custom_hp_reg", function (args) {
        customHpReg[args.unit] = args.value;
        UpdateHpRegLabel();
    });
})();

function InitializeCustomHpRegenLabel(healthContainer) {
    customHealthRegenLabel = $.CreatePanel("Label", healthContainer, "CustomHealthRegenLabel");
    customHealthRegenLabel.AddClass("MonoNumbersFont");
    customHealthRegenLabel.style.zIndex = 4;
    customHealthRegenLabel.style.color = "#3ED038";
    customHealthRegenLabel.style.fontSize = "14px";
    customHealthRegenLabel.style.textShadow = "2px 2px 0px 1.0 #00000066";
    customHealthRegenLabel.style.fontWeight = "bold";
    customHealthRegenLabel.style.marginTop = "-1px";
    customHealthRegenLabel.style.marginRight = "4px";
    customHealthRegenLabel.style.textAlign = "right";
    customHealthRegenLabel.style.horizontalAlign = "right";
    customHealthRegenLabel.style.verticalAlign = "center";
    customHealthRegenLabel.style.paddingRight = "2px";
}

function UpdateHpRegLabel() {
    var localHero = Players.GetLocalPlayerPortraitUnit();
    customHealthRegenLabel.text = "+" + parseFloat(Entities.GetHealthThinkRegen(localHero) + (customHpReg[localHero] || 0)).toFixed(2);
}

function UpdateTooltips() {
    UpdateItemTooltips();
    UpdateAbilityTooltips();
}

function UpdateUI() {
    UpdateTooltips();
    UpdateHpRegLabel();
}

var unusedHotkeyAbilitySlots;

function SetupUnusedItemHotkeys() {
    itemHotkeys.push(GetKeyBind("InventoryTp"));
    for (var i = 0; i < 6; i++) {
        itemHotkeys.push(Game.GetKeybindForInventorySlot(i));
    }
    //$.Msg("Setup unused item hotkeys");
    for (var i = 0; i < itemHotkeys.length; i++) {
        var hotkey = itemHotkeys[i];
        (function (hotkey, slot) {
            Game.AddCommand("UseHotkey_" + hotkey, function (data) {
                UseItemCommandCalled(data, hotkey, slot);
            }, "", 0);
        })(hotkey, i - 1);
        Game.CreateCustomKeyBind(hotkey, "UseHotkey_" + hotkey);
    }
}

function UseItemCommandCalled(data, hotkey, slot) {
    //$.Msg("Use item command called: ", data, "; ", hotkey, "; ");
    var selectedUnitID = Players.GetLocalPlayerPortraitUnit();
    var itemID = Entities.GetItemInSlot(selectedUnitID, slot);
    var abilitySlot = unusedHotkeyAbilitySlots[hotkey];
    //$.Msg("ItemID: ", itemID);
    if (itemID !== -1) {
        Abilities.ExecuteAbility(itemID, selectedUnitID, false);
    } else if (abilitySlot != null) {
        var abilityID = Entities.GetAbility(selectedUnitID, abilitySlot);
        Abilities.ExecuteAbility(abilityID, selectedUnitID, false);
    }
}

function UpdateAbilityTooltips() {
    //$.Msg("UpdateAbilityTooltips");
    CleanUpUiSchedules();
    const abilityListPanel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("abilities");
    var selectedUnit = Players.GetLocalPlayerPortraitUnit();
    //$.Msg("Selected unit: ", selectedUnit);
    var x = {nextHotkeyIndex: 0};
    unusedHotkeyAbilitySlots = [];
    for (var i = 0; i < 16; i++) {
        var abilityID = Entities.GetAbility(selectedUnit, i);
        if (abilityID === -1) {
            break;
        }
        if (!Abilities.IsDisplayedAbility(abilityID)) {
            continue;
        }

        waitForValveUI(i, 0);

        function waitForValveUI(abilitySlot, tries) {
            var abilityPanel = abilityListPanel.FindChildTraverse("Ability" + abilitySlot);
            if (abilityPanel == null) {
                if (tries < 3) {
                    uiWaitingSchedules.push($.Schedule(0.1, function () {
                        waitForValveUI(abilitySlot, tries + 1);
                    }));
                }
                return;
            }

            var abilityName = Abilities.GetAbilityName(Entities.GetAbility(selectedUnit, abilitySlot));

            var buttonWell = abilityPanel.FindChildTraverse("ButtonWell");
            abilityPanel.SetPanelEvent("onmouseover", (function (index, tooltipParent) {
                return function () {
                    $.DispatchEvent("UIShowCustomLayoutParametersTooltip", tooltipParent, "AbilityTooltip",
                        "file://{resources}/layout/custom_game/ability_tooltip.xml", "entityIndex=" + selectedUnit + "&abilityName=" + abilityName);
                }
            })(abilitySlot, buttonWell));
            abilityPanel.SetPanelEvent("onmouseout",
                function () {
                    $.DispatchEvent("UIHideCustomLayoutTooltip", "AbilityTooltip");
                });
            var buttonSize = buttonWell.FindChildTraverse("ButtonSize");

            var upgradedUnitName = CustomNetTables.GetTableValue("buildings", abilityName) && CustomNetTables.GetTableValue("buildings", abilityName).upgradeUnitName || "";
            var building = selectedUnit && CustomNetTables.GetTableValue("buildings", Entities.GetUnitName(selectedUnit));
            var resources = (building && upgradedUnitName.length > 0 && building[upgradedUnitName]) || CustomNetTables.GetTableValue("buildings", abilityName) || CustomNetTables.GetTableValue("abilities", abilityName);
            var gold_cost = 0;
            var lumber_cost = 0;

            if (resources) {
                gold_cost = resources.gold_cost || 0;
                lumber_cost = resources.lumber_cost || 0;
            } else {
                var item = CustomNetTables.GetTableValue("items", "buy_" + abilityName) || CustomNetTables.GetTableValue("items", abilityName);
                gold_cost = item && item.gold_cost || 0;
                lumber_cost = item && item.lumber_cost || 0;
            }

            var goldCostElement = buttonSize.FindChildTraverse("GoldCost");
            goldCostElement.style.visibility = gold_cost > 0 ? "visible" : "collapse";
            goldCostElement.text = gold_cost;
            goldCostElement.style.textShadow = "1px 1px 1px 3.0 #000000";
            var manaCostElement = buttonSize.FindChildTraverse("ManaCost");
            manaCostElement.style.visibility = lumber_cost > 0 ? "visible" : "collapse";
            manaCostElement.style.marginRight = "0px";
            manaCostElement.style.marginBottom = "14px";
            manaCostElement.style.color = "#00d700";
            manaCostElement.style.fontWeight = "bold";
            manaCostElement.style.fontSize = "14px";
            manaCostElement.text = lumber_cost;
            manaCostElement.style.textShadow = "1px 1px 1px 3.0 #000000";

            if (abilitySlot > 5) {
                UpdateAbilityCustomHotkey(selectedUnit, abilitySlot, abilityPanel, x);
            }
        }
    }
}

function UpdateItemTooltips() {
    //$.Msg("UpdateItemTooltips");
    const inventoryListContainer = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("inventory_list_container");
    for (var i = 0; i < 6; i++) {
        var inventoryPanel = inventoryListContainer.FindChildTraverse("inventory_slot_" + i);
        if (inventoryPanel != null) {
            var buttonWell = inventoryPanel.FindChildTraverse("ButtonWell");
            inventoryPanel.SetPanelEvent("onmouseover", (function (index, tooltipParent, inventoryPanel) {
                return function () {
                    if (inventoryPanel.BHasClass("no_ability")) {
                        return;
                    }
                    var entityIndex = Players.GetLocalPlayerPortraitUnit();
                    var abilityName = Abilities.GetAbilityName(Entities.GetItemInSlot(entityIndex, index));
                    $.DispatchEvent("UIShowCustomLayoutParametersTooltip", tooltipParent, "AbilityTooltip",
                        "file://{resources}/layout/custom_game/ability_tooltip.xml", "entityIndex=" + entityIndex + "&abilityName=" + abilityName);
                }
            })(i, buttonWell, inventoryPanel));
            inventoryPanel.SetPanelEvent("onmouseout",
                function () {
                    $.DispatchEvent("UIHideCustomLayoutTooltip", "AbilityTooltip");
                });
        }
    }
}

function UpdateItemTooltipsAndAbilityCustomHotkeys() {
    UpdateItemTooltips();
    UpdateAbilityCustomHotkeys();
}

function UpdateAbilityCustomHotkeys() {
    CleanUpUiSchedules();
    //$.Msg("UpdateAbilityCustomHotkeys");
    const abilityListPanel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("abilities");
    var selectedUnit = Players.GetLocalPlayerPortraitUnit();
    //$.Msg("Selected unit: ", selectedUnit);
    var x = {nextHotkeyIndex: 0};
    unusedHotkeyAbilitySlots = [];
    var abilityCount = Entities.GetAbilityCount(selectedUnit);
    for (var i = 6; i < abilityCount; i++) {
        var abilityID = Entities.GetAbility(selectedUnit, i);
        if (abilityID === -1) {
            break;
        }
        if (!Abilities.IsDisplayedAbility(abilityID)) {
            continue;
        }

        waitForValveUI(i, 0);

        function waitForValveUI(abilitySlot, tries) {
            var abilityPanel = abilityListPanel.FindChildTraverse("Ability" + abilitySlot);
            if (abilityPanel == null) {
                if (tries < 3) {
                    uiWaitingSchedules.push($.Schedule(0.1, function () {
                        waitForValveUI(abilitySlot, tries + 1);
                    }));
                }
                return;
            }
            UpdateAbilityCustomHotkey(selectedUnit, abilitySlot, abilityPanel, x);
        }
    }
}

function UpdateAbilityCustomHotkey(selectedUnit, abilitySlot, abilityPanel, x) {
    var hotkey = null;
    while (hotkey == null && x.nextHotkeyIndex < itemHotkeys.length) {
        if (IsHotkeyAvailable(selectedUnit, x.nextHotkeyIndex)) {
            hotkey = itemHotkeys[x.nextHotkeyIndex];
        }
        x.nextHotkeyIndex = x.nextHotkeyIndex + 1;
    }
    var foundFreeItemHotkey = hotkey != null;
    var hotkeyPanel = abilityPanel.FindChildTraverse("HotkeyContainer").FindChildTraverse("Hotkey");
    hotkeyPanel.SetHasClass("no_hotkey", !foundFreeItemHotkey);
    hotkeyPanel.style.visibility = foundFreeItemHotkey ? "visible" : "collapse";
    hotkeyPanel.FindChild("HotkeyText").text = foundFreeItemHotkey ? hotkey : "hotkey";
    if (foundFreeItemHotkey) {
        unusedHotkeyAbilitySlots[hotkey] = abilitySlot;
        //$.Msg("Adding hotkey: ", hotkey, "; for ability slot: ", abilitySlot);
    }
}

function IsHotkeyAvailable(selectedUnit, index) {
    if (index === 0) {
        return true;
    }
    return Entities.GetItemInSlot(selectedUnit, index - 1) === -1;
}

function CleanUpUiSchedules() {
    for (var a = 0; a < uiWaitingSchedules.length; a++) {
        try {
            $.Msg("Canceling schedule: ", uiWaitingSchedules[a]);
            $.CancelScheduled(uiWaitingSchedules[a]);
        } catch (e) {
            $.Msg("................................................................An error occured: ", e);
        }
    }
    uiWaitingSchedules.length = 0;
}

// Utility method to get hotkey
// name is string, like: "IventoryTp"
function GetKeyBind(name) {
    const context_panel = $.GetContextPanel();
    context_panel.BCreateChildren('<DOTAHotkey keybind="' + name + '" />');

    const key_element = context_panel.GetChild(context_panel.GetChildCount() - 1);
    key_element.DeleteAsync(0);

    return (key_element.GetChild(0)).text;
}


function HidePickScreen() {
    var dotaHud = $.GetContextPanel().GetParent().GetParent();
    dotaHud.FindChild("PreGame").visible = false;
}
