
(function()
{
    function show(){
        $.GetContextPanel().RemoveClass('hidden');
        $.GetContextPanel().AddClass('showed');
    }

    function hide(){
        $.GetContextPanel().RemoveClass('showed');
        $.GetContextPanel().AddClass('hidden');
    }

    $.GetContextPanel().onDataUpdate = function(data){

        if(!data){
            return;
        }

        var labelText = $.GetContextPanel().FindChildTraverse('Text');
        if(data.text){
            labelText.text = data.text
        }

        if(data.width){
            //labelText.style.width = data.width + "px";
        }

        if(data.showed){
            show();
        } else {
            hide();
        }
    };

    //$.GetContextPanel().BLoadLayoutSnippet('bubble');
    $.GetContextPanel().GetParent().GetParent().GetParent().style['z-index'] = '-10';
})();