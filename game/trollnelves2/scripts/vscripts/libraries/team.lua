Team = Team or {}

function Team.GetGoldGained(team)
  local sum = 0
  for i = 1, PlayerResource:GetPlayerCountForTeam(team) do
    local pID = PlayerResource:GetNthPlayerIDOnTeam(team, i)
    sum = sum + PlayerResource:GetGoldGained(pID)
  end
  return sum
end

function Team.GetGoldGiven(team)
  local sum = 0
  for i = 1, PlayerResource:GetPlayerCountForTeam(team) do
    local pID = PlayerResource:GetNthPlayerIDOnTeam(team, i)
    sum = sum + PlayerResource:GetGoldGiven(pID)
  end
  return sum
end

function Team.GetAverageGoldGained(team)
  return Team.GetGoldGained(team) / PlayerResource:GetPlayerCountForTeam(team)
end

function Team.GetAverageGoldGiven(team)
  return Team.GetGoldGiven(team) / PlayerResource:GetPlayerCountForTeam(team)
end

function Team.GetLumberGained(team)
  local sum = 0
  for i = 1, PlayerResource:GetPlayerCountForTeam(team) do
    local pID = PlayerResource:GetNthPlayerIDOnTeam(team, i)
    sum = sum + PlayerResource:GetLumberGained(pID)
  end
  return sum
end

function Team.GetLumberGiven(team)
  local sum = 0
  for i = 1, PlayerResource:GetPlayerCountForTeam(team) do
    local pID = PlayerResource:GetNthPlayerIDOnTeam(team, i)
    sum = sum + PlayerResource:GetLumberGiven(pID)
  end
  return sum
end

function Team.GetAverageLumberGained(team)
  return Team.GetLumberGained(team) / PlayerResource:GetPlayerCountForTeam(team)
end

function Team.GetAverageLumberGiven(team)
  return Team.GetLumberGiven(team) / PlayerResource:GetPlayerCountForTeam(team)
end

function Team.GetScore(team)
  local sum = 0
  for i = 1, PlayerResource:GetPlayerCountForTeam(team) do
    local pID = PlayerResource:GetNthPlayerIDOnTeam(team, i)
    sum = sum + PlayerResource:GetScore(pID, team)
  end
  return sum
end

function Team.GetAverageScore(team)
  return Team.GetScore(team) / PlayerResource:GetPlayerCountForTeam(team)
end

function Team.GetAllAverages(team)
  local sum = 0
  sum = sum + Team.GetAverageGoldGained(team) + Team.GetAverageGoldGiven(team) + Team.GetAverageLumberGained(team) + Team.GetAverageLumberGiven(team)
  return sum
end

function Team.GetAllAveragesAverage(team)
  return Team.GetAllAverages / 4
end
