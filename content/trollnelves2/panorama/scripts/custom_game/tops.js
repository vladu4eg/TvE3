function UpdateTopPlays(info)
{
    for (var i = 1; i <= 100;i++)
    {
        if (info[i.toString()] != null)
        {
            $("#top"+i).steamid = info[i.toString()].id;
            $("#coltop"+i).text = info[i.toString()].col;
        }
        else
        {
            if ($("#coltop"+i) != null)
            {
                $("#coltop"+i).text = "-";
            }
            if ($("#top"+i) != null)
            {
                $("#top"+i).steamid = "";
            }
        }
    }
}

function UpdateTopWins(info)
{
    for (var i = 1; i <= 100;i++)
    {
        if (info[i.toString()] != null)
        {
            $("#norm"+i).steamid = info[i.toString()].id;
            $("#colnorm"+i).text = info[i.toString()].col;
        }
        else
        {
            if ($("#colnorm"+i) != null)
            {
                $("#colnorm"+i).text = "-";
            }
            if ($("#norm"+i) != null)
            {
                $("#norm"+i).steamid = "";
            }
        }
    }
}

function UpdateTopHardWins(info)
{
    for (var i = 1; i <= 100;i++)
    {
        if (info[i.toString()] != null)
        {
            $("#hard"+i).steamid = info[i.toString()].id;
            $("#colhard"+i).text = info[i.toString()].col;
        }
        else
        {
            if ($("#colhard"+i) != null)
            {
                $("#colhard"+i).text = "-";
            }
            if ($("#hard"+i) != null)
            {
                $("#hard"+i).steamid = "";
            }
        }
    }
}

(function()
{
    GameEvents.Subscribe( "UpdateTopPlays", UpdateTopPlays)
    GameEvents.Subscribe( "UpdateTopWins", UpdateTopWins)
    GameEvents.Subscribe( "UpdateTopHardWins", UpdateTopHardWins)
    
    GameEvents.SendCustomGameEventToServer( "UpdateTops", {} );
})();