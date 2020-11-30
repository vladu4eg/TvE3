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


(function()
{
    GameEvents.Subscribe( "UpdateTopPlaysEvent", UpdateTopPlays)
    
    GameEvents.SendCustomGameEventToServer( "UpdateTopsEvent", {} );
})();