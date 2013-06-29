(function(){
    $(function(){ initTransitUrlUI(); });

    var $transitUrlCheckbox;
    var $transitUrlLinkTR;
    var $transitUrlLinkInput;

    function initTransitUrlUI()
    {
        $transitUrlCheckbox = $("#id-transit_url");

        var campaignHasTransitTeazers = $('#campaignHasTransitTeazers').val();

        $transitUrlCheckbox.parents('tr').after('<tr id="tr-transit_url_link" style="display:none;"'
            +(campaignHasTransitTeazers?' class="warning"':'')
            +'><td><p class="lbl"><label for="id-transit_url_link">URL транзитной страницы</label></p></td><td class="tbcontent">'
            +(campaignHasTransitTeazers?'<p class="correct">У некоторых объявлений уже указана транзитная ссылка, они не будут изменены</p>':'')
            +'<span class="input-txt"><input type="text" id="id-transit_url_link" name="transit_url_link" value="" class="txt f437" size=""/></span></td></tr>'
        );

        $transitUrlLinkTR = $('#tr-transit_url_link');
        $transitUrlLinkInput = $('#id-transit_url_link');

        $transitUrlCheckbox.bind('click.initTransitUrlUI', function(){ clickedCheckbox(); });

        clickedCheckbox();
    }

    function clickedCheckbox()
    {
        var checked = $transitUrlCheckbox.is(':checked');

        if(checked){
            $transitUrlLinkTR.fadeIn('normal');
        } else {
            $transitUrlLinkTR.fadeOut('normal', function(){ $transitUrlLinkInput.val(''); });
        }
    }
})();
