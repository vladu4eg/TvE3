"use strict";

function ChooseSide( teamNumber){
	var pID = Players.GetLocalPlayer();
	GameEvents.SendCustomGameEventToServer( "choose_help_side", { team:teamNumber,playerID:pID });
	$("#ChooseHelpContainer").style.visibility = "collapse";
}

function ShowHelperOptions(){
	$("#ChooseHelpContainer").style.visibility = "visible";
	$.Schedule(30,function(){
		$("#ChooseHelpContainer").style.visibility = "collapse";
	});
}

(function () {
	GameEvents.Subscribe("show_helper_options",ShowHelperOptions);
})();