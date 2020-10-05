"use strict";

(function()
{
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	$.Msg("Initializing multiteam_end_screen.js");
	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_end_screen_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/multiteam_end_screen_player.xml",
	};

	var endScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" ) );
	$.GetContextPanel().SetHasClass( "endgame", 1 );

	var teamInfoList = ScoreboardUpdater_GetSortedTeamInfoList( endScoreboardHandle );
	var delay = 0.2;
	var delay_per_panel = 1 / teamInfoList.length;
	for ( var teamInfo of teamInfoList )
	{
	    var teamId = teamInfo.team_id;
		var teamPanel = ScoreboardUpdater_GetTeamPanel( endScoreboardHandle, teamId );
		teamPanel.SetHasClass( "team_endgame", false );
		var callback = function( panel )
		{
			return function(){ panel.SetHasClass( "team_endgame", 1 ); }
		}( teamPanel );
		$.Schedule( delay, callback );
		delay += delay_per_panel;


		var teamPlayers = Game.GetPlayerIDsOnTeam( teamId );
		var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
		if ( playersContainer )
		{
			for (var playerId of teamPlayers ) {
				var playerPanel = playersContainer.FindChild("_dynamic_player_" + playerId);
				if(playerPanel){
					var playerResourceStats = CustomNetTables.GetTableValue("resources",playerId + "_resource_stats");
                    if(playerResourceStats) {
						$.Msg("Setting end game resources for playerId: ", playerId, "; playerResourceStats: ", playerResourceStats, "; ");
						_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerGoldAmount", Math.round(playerResourceStats.gold/1000) );
						_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerLumberAmount", Math.round(playerResourceStats.lumber/1000) );
						_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerGPSAmount", Math.round(playerResourceStats.goldGained/playerResourceStats.timePassed) );
						_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerLPSAmount", Math.round(playerResourceStats.lumberGained/playerResourceStats.timePassed) );
						_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerGoldGivenAmount", Math.round(playerResourceStats.goldGiven/1000) );
					    _ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerLumberGivenAmount", Math.round(playerResourceStats.lumberGiven/1000) );
						_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerScore", playerResourceStats.playerScore );
					}
				}
			}
		}
	}

	var winningTeamId = Game.GetGameWinner();
	var winningTeamDetails = Game.GetTeamDetails( winningTeamId );
	var endScreenVictory = $( "#EndScreenVictory" );
	if ( endScreenVictory )
	{
		endScreenVictory.SetDialogVariable( "winning_team_name", winningTeamId == DOTATeam_t.DOTA_TEAM_BADGUYS && "The Mighty Troll has slain everyone!" || "Elves have defended successfully!" );

		if ( GameUI.CustomUIConfig().team_colors )
		{
			var teamColor = GameUI.CustomUIConfig().team_colors[ winningTeamId ];
			teamColor = teamColor.replace( ";", "" );
			endScreenVictory.style.color = teamColor + ";";
		}
	}

	var winningTeamLogo = $( "#WinningTeamLogo" );
	if ( winningTeamLogo )
	{
		var logo_xml = GameUI.CustomUIConfig().team_logo_large_xml;
		if ( logo_xml )
		{
			winningTeamLogo.SetAttributeInt( "team_id", winningTeamId );
			winningTeamLogo.BLoadLayout( logo_xml, false, false );
		}
	}
})();
