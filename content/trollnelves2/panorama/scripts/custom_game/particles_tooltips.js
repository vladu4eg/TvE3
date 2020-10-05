function setupTooltip(){
    var num = $.GetContextPanel().GetAttributeString( "num", "notfound" );
    if($("#cam")==null && num < 18)
    {
        $("#toolpanel").BCreateChildren("<DOTAScenePanel id='cam' style='width:400px;height:400px;' particleonly='false' map='cameras' camera='camera"+num+"' />");//unit='npc_dota_custom_creep_1_1'
        //$("#toolpanel").BCreateChildren("<DOTAScenePanel id='cam' style='width:400px;height:400px;' light='global_light' renderdeferred='false' particleonly='false' map='cameras' camera='camera"+num+"'/>");
        //$("#toolpanel").BCreateChildren("<DOTAScenePanel id='cam' style='width:400px;height:400px;' map='cameras' camera='camera"+num+"'/>");
        //$("#toolpanel").BCreateChildren("<DOTAScenePanel id='cam' style='width:400px;height:400px;' renderdeferred='false' antialias='true' particleonly='false' allowrotation='true' unit='npc_dota_custom_creep_5_1' />");
        //$.DispatchEvent("DOTAGlobalSceneFireEntityInput", "cam", "donkey", "RunScriptFile", "ptooltips");
    }
    else if($("#cam")==null && num >= 18)
    {
     $("#toolpanel").BCreateChildren("<DOTAScenePanel id='cam' style='width:400px;height:400px;' particleonly='false' map='camera2' camera='camera"+num+"' />");
    }
       
    //$.Msg(num);
}

