{
    //$.Msg(data);
    var names = new Array("DEVELOPER", "WINNER", "HELPER", "TOP", "DISCORD", "BUTTERFLIES", "DONATOR", "ALLHEROES", "NEW YEAR", "BIRTHDAY", "PATRON LVL 1", "PATRON LVL 2", "PATRON LVL 3", "PATRON LVL 4", "PATRON LVL 5", "HARD WINNER", "BIRTHDAY 2019", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39","40");
    $("#Line"+(data["1"]+1)+"Label").text = data["2"]+$.Localize("#useseffect")+names[data["3"]-1];
    $("#hero"+(data["1"]+1)).heroname = data["4"];
    $("#Line"+(data["1"]+1)).visible = true;
    $("#Line"+(data["1"]+1)).RemoveClass("OffPanelClass")
    $("#Line"+(data["1"]+1)).AddClass("OffPanelClass")
}

(function()
{
    $("#Line1").visible = false;
    $("#Line2").visible = false;
    $("#Line3").visible = false;
    $("#Line4").visible = false;
    $("#Line5").visible = false;
    GameEvents.Subscribe( "UpdateParticlesUI", UpdateParticlesUI);
})();