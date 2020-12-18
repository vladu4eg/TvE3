var names = new Array("TOP1 AUTUMN", "TOP1 WINTER ", "TOP1 SPRING", "TOP1 SUMMER", "PET LVL 1", "PET LVL 2", "PET LVL 3", "PET LVL 4", "PET LVL 5", "PET LVL 6", "DESERT EVENT");
					//        1              2                  3          4            5           6         7           8             9          10            11              12               13             14              15          16                     17       18           19           20         21             22          23        24       25              26         27               28                29              30             31           32         33                 34                35                 36
var needs = new Array("#ptop1autumn", "#ptop1winter", "#ptop1spring", "#ptop1summer", "#ppatron1", "#ppatron2", "#ppatron3", "#ppatron4", "#ppatron5", "#ppatron6", "#peventdesert");
var poriadok = new Array( 0,1,  2, 3, 4, 5, 6, 7, 8,9,10);//"#birthday2"
					
function UpdateParticles( table_name, key, data )
{
    var ID = Players.GetLocalPlayer();
	//$.Msg( ID, ": ", "Table ", table_name, " changed: '", key, "' = ", data );
    var myint = 1;
    if (ID == key)
    {
        if (data != null)
        {
            for (var x = 1; x < names.length+1; x = x + 1)
            {
                if (data[poriadok[x-1]+1] != null)
                {
                    $("#NAPartButt"+x).visible = false;
                    if (data[poriadok[x-1]+1] != "nill")
                    {
                        if (data[poriadok[x-1]+1] != "normal")
                        {
                            $("#NewPartButt"+myint).visible = true;
                            $("#partname"+myint).text = names[poriadok[x-1]];
                            $("#partnote"+myint).text = data[poriadok[x-1]+1];
                            $("#NewPartNum"+myint).text = poriadok[x-1]+1;
                            if ($("#NewTooltip"+myint) == null)
                            {
                                $("#NewPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                            }
                            else
                            {
                                $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                                $("#NewPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                            }
                            myint = myint + 1;
                        }
                        else 
                        {
                            $("#NewPartButt"+myint).visible = true;
                            $("#partname"+myint).text = names[poriadok[x-1]];
                            $("#partnote"+myint).text = $.Localize(needs[poriadok[x-1]]);
                            $("#NewPartNum"+myint).text = poriadok[x-1]+1;
                            if ($("#NewTooltip"+myint) == null)
                            {
                                $("#NewPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                            }
                            else
                            {
                                $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                                $("#NewPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                            }
                            myint = myint + 1;
                        }
                    }
                    else
                    {
                        if (needs[poriadok[x-1]] != false)
                        {
                            $("#NAPartButt"+myint).visible = true;
                            $("#napartname"+myint).text = names[poriadok[x-1]];
                            $("#napartnote"+myint).text = $.Localize(needs[poriadok[x-1]]);
                            if ($("#NewTooltip"+myint) == null)
                            {
                                $("#NAPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                            }
                            else
                            {
                                $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                                $("#NAPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                            }
                            myint = myint + 1;
                        }
                    }
                }
                else
                {
                    if (needs[poriadok[x-1]] != false)
                    {
                        $("#NAPartButt"+myint).visible = true;
                        $("#napartname"+myint).text = names[poriadok[x-1]];
                        $("#napartnote"+myint).text = $.Localize(needs[poriadok[x-1]]);
                        if ($("#NewTooltip"+myint) == null)
                        {
                            $("#NAPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                        }
                        else
                        {
                            $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                            $("#NAPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                        }
                        myint = myint + 1;
                    }
                }
            }
        }
        else
        {
            for (var x = 1; x < names.length+1; x = x + 1)
            {
                if (needs[poriadok[x-1]] != false)
                {
                    $("#NAPartButt"+myint).visible = true;
                    $("#napartname"+myint).text = names[poriadok[x-1]];
                    $("#napartnote"+myint).text = $.Localize(needs[poriadok[x-1]]);
                    if ($("#NewTooltip"+myint) == null)
                    {
                        $("#NAPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                    }
                    else
                    {
                        $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                        $("#NAPartButt"+myint).BCreateChildren("<Panel id='NewTooltip"+myint+"' class='NewTooltip' onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip"+myint+",file://{resources}/layout/custom_game/pets_tooltips.xml,num="+(poriadok[x-1]+1)+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip"+myint+")' />");
                    }
                    myint = myint + 1;
                }
            }
        }
    }
}
var selectedpart = null;
function SelectPart(num)
{
    if (selectedpart != num)
    {
        if (selectedpart != null)
        {
            $("#partapngb"+selectedpart).visible = false;
        }
        GameEvents.SendCustomGameEventToServer( "SelectPets", { id: Players.GetLocalPlayer(),part:$("#NewPartNum"+num).text, offp:false, name:$("#partname"+num).text } );
        $("#partapngb"+num).visible = true;
        selectedpart = num;
    }
    else
    {
        GameEvents.SendCustomGameEventToServer( "SelectPets", { id: Players.GetLocalPlayer(),part:$("#NewPartNum"+num).text, offp:true, name:$("#partname"+num).text } );
        $("#partapngb"+selectedpart).visible = false;
        selectedpart = null;
    }
    //$.Msg("SelectedPart = "+selectedpart);
}

function DefaultButtonReady()
{
    $("#DefaultButton").RemoveClass("DefaultButtondis");
    $("#DefaultButton").AddClass("DefaultButtonact");
}

function DefaultButton()
{
    if (selectedpart != null)
    {
        GameEvents.SendCustomGameEventToServer( "SetDefaultPets", { id: Players.GetLocalPlayer(),part:$("#NewPartNum"+selectedpart).text} );
        //$.Msg($("#NewPartNum"+selectedpart).text);
    }
    else
    {
        GameEvents.SendCustomGameEventToServer( "SetDefaultPart", { id: Players.GetLocalPlayer(),part:""} );
    } 
    $("#DefaultButton").RemoveClass("DefaultButtonact");
    $("#DefaultButton").AddClass("DefaultButtondis");
}

function SetSelectedParticles(data)
{
    for (var x = 1; x < names.length+1; x = x + 1)
    {
        if ($("#NewPartNum"+x).text == data["3"])
            selectedpart = x.toString();
    }
    $("#partapngb"+selectedpart).visible = true;
}

(function()
{
    GameEvents.Subscribe( "DefaultButtonReady", DefaultButtonReady);
    GameEvents.Subscribe( "SetSelectedParticles", SetSelectedParticles);
    for (var x = 1; x < names.length+1; x = x + 1)
    {
        var stl = (100*(x-1)) + 20
        $("#CustomUIContainer").BCreateChildren("<Button id='NewPartButt"+x+"' class='NewPartButt' onactivate='SelectPart("+x+");' style='margin-top:"+stl+"px;'/>");// onmouseover='UIShowCustomLayoutParametersTooltip(ParticleTooltip,file://{resources}/layout/custom_game/pets_tooltips.xml,num="+x+")' onmouseout='UIHideCustomLayoutTooltip(ParticleTooltip)' />");
        $("#NewPartButt"+x).BCreateChildren("<Image id='pereg"+x+"' src='file://{images}/custom_game/all/st.png' style='width:5px; margin-top:0px; margin-left:150px;'/>");
        $("#NewPartButt"+x).BCreateChildren("<Image id='partapngb"+x+"' src='file://{images}/custom_game/all/activbutt.png'/>");
        $("#NewPartButt"+x).BCreateChildren("<Label id='NewPartNum"+x+"' text='0'/>");
        $("#NewPartButt"+x).BCreateChildren("<Label id='partname"+x+"' text='Название эффекта' style='margin-top:20px; margin-left:10px;'/>");
        $("#NewPartButt"+x).BCreateChildren("<Label id='partnote"+x+"' text='Описание/причина выдачи/примечание' style='margin-top:5px; margin-left:180px;'/>");

        
        $("#NewPartButt"+x).visible = false;
        $("#NewPartNum"+x).visible = false;
        $("#partapngb"+x).visible = false;
        $("#CustomUIContainer").BCreateChildren("<Button id='NAPartButt"+x+"' class='NAPartButt' style='margin-top:"+stl+"px;'/>");
        $("#NAPartButt"+x).BCreateChildren("<Image id='napereg"+x+"' src='file://{images}/custom_game/all/st.png' style='width:5px; margin-top:0px; margin-left:150px;'/>");
        $("#NAPartButt"+x).BCreateChildren("<Label id='napartname"+x+"' text='Название эффекта' style='margin-top:20px; margin-left:10px;'/>");
        $("#NAPartButt"+x).BCreateChildren("<Label id='napartnote"+x+"' text='Описание/причина выдачи/примечание' style='margin-top:5px; margin-left:180px;'/>");
        $("#NAPartButt"+x).visible = false;
    }
    CustomNetTables.SubscribeNetTableListener( "Pets_Tabel", UpdateParticles );
    UpdateParticles( "Pets_Tabel", Players.GetLocalPlayer(), CustomNetTables.GetTableValue( "Pets_Tabel", Players.GetLocalPlayer() ) );
})();