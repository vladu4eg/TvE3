"use strict";


const scoreboardConfig = {
  teamXmlName: "file://{resources}/layout/custom_game/multiteam_flyout_scoreboard_team.xml",
  playerXmlName: "file://{resources}/layout/custom_game/multiteam_flyout_scoreboard_player.xml",
};

function setSecondInterval(func, seconds) {
  let enabled = true;
  function repeat() {
    $.Schedule(seconds, () => {
      if (enabled) {
        func();
        repeat();
      }
    })
  }
  repeat();
  return () => {
    enabled = false;
  };
}

(function() {
  let g_ScoreboardHandle = null;
  const teamsContainer = $( "#TeamsContainer" );
  if (!ScoreboardUpdater_InitializeScoreboard) {
    $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." );
    return;
  }

  g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, teamsContainer);

  function setScoreboardVisibility(visible) {
    $.GetContextPanel().SetHasClass("flyout_scoreboard_visible", visible );
    ScoreboardUpdater_SetScoreboardActive(g_ScoreboardHandle, visible);
  }

  setScoreboardVisibility(false);

  let disable;
  $.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), function ( bVisible ) {
    if (!bVisible && disable) {
      disable();
      disable = null;
    }
    if (!disable && bVisible) {
      disable = setSecondInterval(() => {
        g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard(scoreboardConfig, teamsContainer);
      }, 1);
    }

    setScoreboardVisibility(bVisible);
  });
})();
