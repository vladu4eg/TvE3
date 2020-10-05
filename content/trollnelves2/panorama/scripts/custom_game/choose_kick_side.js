"use strict";
var plID = -1;
var name;
var casterID = -1
function ChooseKickSide(yesNo){
	GameEvents.SendCustomGameEventToServer( "choose_kick_side", { vote:yesNo, playerID1:plID,casterID:casterID });
	$("#ChooseKickContainer").style.visibility = "collapse";
}

function ShowKickOptions(event_data){
	name = event_data["name"];
	plID = event_data["id"];
	casterID = event_data["casterID"];
	$("#ChooseKickContainer").style.visibility = "visible";
	$("#idKickLabel").text = `Votekick: ${name}`;
	$.Schedule(30,function(){
		$("#ChooseKickContainer").style.visibility = "collapse";
	});
}


(function () {
	GameEvents.Subscribe("show_votekick_options",ShowKickOptions);
})();