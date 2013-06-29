<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main.xsl"/>
<xsl:include href="_subedit.xsl"/>

    <xsl:template name="translation_dialog">
        <div class="top-up f470 window" id="translation_dialog" style="display: none">
            <div class="top png"></div>
            <div class="middle png">
                <a class="close jqmClose" href="#"></a>
                <h2>Переводы поля</h2>
                <div class="help" id="translation_inner"/>
                <input type="button" id="translation_button" value="Сохранить" onclick="return saveTranslate();"/>&#160;&#160;<a class="botdash jqmClose" href="#">Отмена</a>
            </div>
            <div class="bottom png"></div>
        </div>
    </xsl:template>


<xsl:template match="option" mode="radio">
<xsl:param name="xname" select="1"/>
<xsl:param name="xvalue" select="1"/>
                    <input type="radio" id="{$xname}-6-1" name="{$xname}" value="{@value}"><xsl:if test="@value = $xvalue"><xsl:attribute name="checked"></xsl:attribute></xsl:if></input>
                    <label for="{$xname}-6-1" class="radio-inline"><xsl:value-of select="."/></label>
</xsl:template>

<xsl:template match="col[type=9 and internal='y']" mode="edit">
<tr id="tr-{@name}">
<td colspan="2"><h2><xsl:apply-templates select="name"/></h2></td>
</tr>
</xsl:template>


<xsl:template match="error" mode="edit">
    <p class="correct"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="col[read_only='y'][type=1 or type=3 or type=4 or type=5 or type=12]" mode="edit">
<tr id="tr-{@name}"><xsl:if test="/page/data/errors/error[@name=current()/@name]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if>
<td><p class="lbl"><label for="id-{@name}"><xsl:apply-templates select="name"/></label></p></td><td  class="tbcontent">
<xsl:apply-templates select="/page/data/errors/error[@name=current()/@name]" mode="edit"/>

        <span class="input-txt">
        <input type="text" id="id-{@name}" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" class="txt f437" size="{@size}">
            <xsl:attribute name="onfocus">blur();</xsl:attribute>
        </input>
        </span>

</td></tr>
</xsl:template>

<xsl:template match="col[read_only='y'][type=6]" mode="edit">
<tr id="tr-{@name}"><xsl:if test="/page/data/errors/error[@name=current()/@name]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if>
<td><p class="lbl"><label for="id-{@name}"><xsl:apply-templates select="name"/></label></p></td><td  class="tbcontent">
<xsl:apply-templates select="/page/data/errors/error[@name=current()/@name]" mode="edit"/>

        <select name="{@name}" id="id-{@name}" class="f185"><xsl:attribute name="onfocus">blur();</xsl:attribute>
        <xsl:if test="ref/none"><option value="0"><xsl:value-of select="ref/none"/></option></xsl:if>
        <xsl:copy-of select="/page/data/values/multioptions/*[name()=current()/@name]/*"/>
        </select>

</td></tr>
</xsl:template>

    <xsl:template match="*" mode="flag">
        <xsl:apply-templates select="item" mode="flag_draw"/>
    </xsl:template>

    <xsl:template match="*" mode="flag_draw">
        <img src="{/page/root}/images/localization/{image}" width="32" height="32" alt="{language_name}" title="{language_name}"/>
    </xsl:template>

    <xsl:template match="*" mode="function_argument">
        '<xsl:value-of select="item[@item_id = 0]"/>', '<xsl:value-of select="item[@item_id = 1]"/>'
    </xsl:template>

<xsl:template match="col" mode="edit">
<!--<xsl:apply-templates select="/page/data/errors/error[@name=current()/@name]" mode="edit"/>-->
<tr id="tr-{@name}"><xsl:if test="/page/data/errors/error[@name=current()/@name]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if><xsl:if test="noform"><xsl:attribute name="style">display:none</xsl:attribute></xsl:if>
<td><p class="lbl"><label for="id-{@name}"><xsl:apply-templates select="name"/></label></p></td><td  class="tbcontent">
<xsl:apply-templates select="/page/data/errors/error[@name=current()/@name]" mode="edit"/>
<xsl:choose>
    <xsl:when test="type=1 and translate='y' and /page/data/@edit">
        <div style="border: 1px solid rgb(238, 238, 238); height: 55px; width: 442px;">
        <span class="input-txt">
            <input type="text" id="id-{@name}" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" class="txt f437" size="{@size}"></input>
            <div class="neutral" style="float:right; margin: 5px"><a href="#"><xsl:attribute name="onclick">return editTranslate(<xsl:apply-templates select="/page/data/translation_meta/*[name()=current()/@name]" mode='function_argument'/>);</xsl:attribute>Перевод</a></div>
            <span id="flag_{@name}"><xsl:apply-templates select="/page/data/translation/*[name()=current()/@name]" mode="flag"></xsl:apply-templates></span>
        </span>
        </div>
    </xsl:when>
    <xsl:when test="type=1">
        <span class="input-txt">
            <input type="text" id="id-{@name}" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" class="txt f437" size="{@size}"></input>
        </span>
    </xsl:when>
    <xsl:when test="type=2 and translate='y' and /page/data/@edit">
        <div style="border: 1px solid rgb(238, 238, 238); height: 108px; width: 442px;">
            <span class="input-txt">
                <textarea name="{@name}"  id="id-{@name}" rows="{rows}" cols="{cols}" class="f441"><xsl:value-of select="/page/data/values/*[name()=current()/@name]"/></textarea>
                <div class="neutral" style="float:right; margin: 5px"><a href="#"><xsl:attribute name="onclick">return editTranslate(<xsl:apply-templates select="/page/data/translation_meta/*[name()=current()/@name]" mode='function_argument'/>);</xsl:attribute>Перевод</a></div>
                <span id="flag_{@name}"><xsl:apply-templates select="/page/data/translation/*[name()=current()/@name]" mode="flag"></xsl:apply-templates></span>
            </span>
        </div>
    </xsl:when>
    <xsl:when test="type=2">
        <textarea name="{@name}"  id="id-{@name}" rows="{rows}" cols="{cols}" class="f441"><xsl:value-of select="/page/data/values/*[name()=current()/@name]"/></textarea>
    </xsl:when>
    <xsl:when test="type=3">
        <span class="input-txt">
        <input type="text" name="{@name}"  id="id-{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}" class="txt f437"/>
        </span>
    </xsl:when>
    <xsl:when test="type=4">
        <span class="input-txt">
        <input type="text" name="{@name}" id="id-{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}" class="txt f437"/>
        </span>
    </xsl:when>
    <xsl:when test="type=5">
        <span class="input-txt">
        <input type="text" name="{@name}" id="id-{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}" class="txt f185"><xsl:if test="@panelize='y'"><xsl:attribute name="onfocus">_XDOC=this;</xsl:attribute><xsl:attribute name="onkeydown">_etaKey(event)</xsl:attribute></xsl:if></input>
        </span>
    </xsl:when>
    <xsl:when test="type=6">
    <xsl:choose>
    <xsl:when test="autocomplete='y'">
        <span class="input-txt">
        <input type="hidden" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" id="id-{@name}"/>
        <input type="text" value="{/page/data/values/multioptions/*[name()=current()/@name]/option[@value=/page/data/values/*[name()=current()/@name]]}" class="txt f437" id="id-{@name}-suggest"/>
        </span>
        <script type="text/javascript">
            $(document).ready(function() {
                $('#id-<xsl:value-of select="@name" />-suggest')
                    .autocomplete('<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name" />/suggest/',
                                  {
                                  extraParams: {field: '<xsl:value-of select="@name" />'},
                                  scroll: true,
                                  formatItem: function(row, i, max, term) {
                                    return row.email;
                                  },
                                  parse: function(data) {
                                    var parsed = [];
                                    var rows = eval(data);
                                    for (var i=0; i &lt; rows.length; i++) {
                                        var row = rows[i];
                                        parsed[parsed.length] = {
                                            data: row,
                                            value: "" + row['<xsl:value-of select="@name" />'],
                                            result: row['<xsl:value-of select="ref/visual" />']
                                        };
                                    }
                                    return parsed;
                                  }
                                  })
                    .result(function(event, data) {
                        $('#id-<xsl:value-of select="@name" />').val(data.<xsl:value-of select="@name" />);
                    });
            });
        </script>
    </xsl:when>
    <xsl:when test="popup='y'">
        <span class="input-txt">
        <input type="hidden" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" id="id-{@name}"/>
        <input type="text" name="v_{@name}" value="{/page/data/values/multioptions/*[name()=current()/@name]/*}" id="vid-{@name}" class="txt f437" onfocus="this.blur();"/>
<!--        <input type="button" onclick="return DictPopUp('{ref/table}','{@name}');" value="&#187;"/>-->
        <input type="button" onclick="field_activator = 'id-{@name}'; field_selector = '{ref/visual}'  ;return DictPopUp('{/page/root}/admin/{controller}Sp/');" value="&#187;"/>
        </span>
    </xsl:when>
    <xsl:otherwise>
        <select name="{@name}" id="id-{@name}" class="f185">
        <xsl:if test="ref/none"><option value="0"><xsl:value-of select="ref/none"/></option></xsl:if>
        <xsl:copy-of select="/page/data/values/multioptions/*[name()=current()/@name]/*"/>
        </select>
    </xsl:otherwise>
    </xsl:choose>
    </xsl:when>

    <xsl:when test="type=7">
    <input type="hidden" name="old_{@name}" value="{/page/data/values/*[name()=current()/@name]/full}">
    <xsl:if test="/page/data/values/*[name()=concat('old_',current()/@name)]"><xsl:attribute name="value"><xsl:value-of select="/page/data/values/*[name()=concat('old_',current()/@name)]"/></xsl:attribute></xsl:if>
    </input>
    <input type="hidden" name="clr_{@name}" value="0" id="clr_{@name}"/>
    <xsl:choose>
    <xsl:when test="/page/data/values/*[name()=current()/@name]/w &gt; 0">
            <img class="preview" src="{/page/root}/images{/page/data/@imgpath}{dir}{/page/data/values/*[name()=current()/@name]/src}" alt="" width="{/page/data/values/*[name()=current()/@name]/w}" height="{/page/data/values/*[name()=current()/@name]/h}"/>
            <p class="type-photo"><a href="{/page/root}/images{/page/data/@imgpath}{dir}{/page/data/values/*[name()=current()/@name]/src}" target="_blank"><xsl:value-of select="/page/data/values/*[name()=current()/@name]/src"/>&#160;(<xsl:value-of select="/page/data/values/*[name()=current()/@name]/w"/>x<xsl:value-of select="/page/data/values/*[name()=current()/@name]/h"/>)</a></p>
            <p class="type-photo" id="inter-{@name}"><a class="interact" href="#" onclick="return delImg('{@name}');">Удалить</a> или <a class="interact" href="#" onclick="return loadImg('{@name}');">загрузить другой файл</a></p>
            <p class="type-photo" style="display: none" id="del-{@name}"><span class="delete">Будет удалена при сохранении</span> (<a class="interact" href="#" onclick="return undelImg('{@name}');">отменить</a>)</p>

        <table class="nopad" style="display: none" id="browse-{@name}">
            <tbody><tr>
                <td><p class="bti">Выберите файл:</p></td>
                <td>
                    <div class="input-file f224">
                        <label>
                        <span>Browse</span>
                        <input type="file" name="{@name}" id="id-{@name}"/>
                        </label>
                        <div class="var">
                        <span class="input-txt"><input type="text" readonly="readonly" value="" id="id-text-{@name}" name="text-{@name}" class="txt" tabindex="-1"/></span>
                        </div>
                    </div>
                </td>
                <td><p class="bti"><a class="interact" href="#" onclick="return notloadImg('{@name}');">отменить</a></p></td>
                </tr>
        </tbody></table>
    </xsl:when>
    <xsl:otherwise>
        <table class="nopad">
            <tbody><tr>
                <td><p class="bti">Выберите файл:</p></td>
                <td>
                    <div class="input-file f224">
                        <label>
                        <span>Browse</span>
                        <input type="file" name="{@name}" id="id-{@name}" onchange="$('#cancel-{@name}').show('');"/>
                        </label>
                        <div class="var">
                        <span class="input-txt"><input type="text" readonly="readonly" value="" id="id-text-{@name}" name="text-{@name}" class="txt" tabindex="-1"/></span>
                        </div>
                    </div>
                </td>
                <td><p class="bti"><a class="interact" style="display:none;" id='cancel-{@name}' href="#" onclick="$('#id-text-{@name}').val(''); $('#id-{@name}').val(''); return false;">отменить</a></p></td>
                </tr>
        </tbody></table>
    </xsl:otherwise>
    </xsl:choose>
    <script>
    $(document).ready( function(){new FileUploadUI('<xsl:value-of select="@name"/>');});
    </script>
    </xsl:when>


    <xsl:when test="type=8">
        <input type='checkbox' name='{@name}' id="id-{@name}" class="check" value='1'><xsl:if test="/page/data/values/*[name()=current()/@name]='1'"><xsl:attribute name="checked"></xsl:attribute></xsl:if></input>
    </xsl:when>

    <xsl:when test="type=10">
        <xsl:choose>
            <xsl:when test="radio = 'y'">
                <div class="radio-block">
                    <xsl:apply-templates select="/page/data/values/multioptions/*[name()=current()/@name]/*" mode="radio">
                    <xsl:with-param name="xname" select="@name"/>
                    <xsl:with-param name="xvalue" select="/page/data/values/*[name()=current()/@name]"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>

            <xsl:otherwise>
                <select name="{@name}" id="id-{@name}" class="f185"><xsl:copy-of select="/page/data/values/multioptions/*[name()=current()/@name]/*"/></select>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:when>

    <xsl:when test="type=12">
        <span class="input-txt">
        <input type="text" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" id="id-{@name}" class="txt f222"/>
        </span>
        <xsl:if test="calendar">

        <script type="text/javascript">
            $(document).ready(function(){
                $("#id-<xsl:value-of select="@name"/>").datepicker({
                dateFormat: "yy-mm-dd",
            showStatus: true,
            showOn: "button",
            buttonImage: "<xsl:value-of select="/page/root"/>/i/adm/calendar.gif",
            buttonImageOnly: true});
                $('#dialog_link, ul#icons li').hover(
                    function() { $(this).addClass('ui-state-hover'); },
                    function() { $(this).removeClass('ui-state-hover'); }
                );
        $("#id-<xsl:value-of select="@name"/>").datepicker($.datepicker.regional['ru']);
            });
        </script>
        </xsl:if>&#160;(YYYY-MM-DD)
    </xsl:when>
    <xsl:when test="type=13">
        <select name="{@name}" id="id-{@name}" class="f185"><xsl:if test="ref/none"><option value="0"><xsl:value-of select="ref/none"/></option></xsl:if>V_STR_<xsl:value-of select="@name"/></select>
    </xsl:when>
<!--
    <xsl:when test="type=14">
        <input type="hidden" name="old_{@name}" value="{/page/data/values/*[name()=current()/@name]/full}"><xsl:if test="/page/data/values/*[name()=concat('old_',current()/@name)]"><xsl:attribute name="value"><xsl:value-of select="/page/data/values/*[name()=concat('old_',current()/@name)]"/></xsl:attribute></xsl:if></input>
        <table><tr><td><input type="file" name="{@name}" size="1"/><br/><input type="checkbox" name="clr_{@name}" value="1"/>сбросить файл.</td>
        <td>&#160;</td>
        <td>
            size=<xsl:value-of select="/page/data/values/*[name()=current()/@name]/size"/><br/>
            name=<xsl:value-of select="/page/data/values/*[name()=current()/@name]/href"/>
        </td></tr></table>
    </xsl:when>
-->

    <xsl:when test="type=14">
    <input type="hidden" name="old_{@name}" value="{/page/data/values/*[name()=current()/@name]/full}">
    <xsl:if test="/page/data/values/*[name()=concat('old_',current()/@name)]"><xsl:attribute name="value"><xsl:value-of select="/page/data/values/*[name()=concat('old_',current()/@name)]"/></xsl:attribute></xsl:if>
    </input>
    <input type="hidden" name="clr_{@name}" value="0" id="clr_{@name}"/>
    <xsl:choose>
    <xsl:when test="/page/data/values/*[name()=current()/@name]/href !=''">
            <img class="preview" src="{/page/root}/i/1.gif" alt="" width="1" height="1" style="display:none"/>

            <p class="type-photo"><a href="{/page/root}/images{/page/data/@imgpath}{dir}{/page/data/values/*[name()=current()/@name]/href}" target="_blank"><xsl:value-of select="/page/data/values/*[name()=current()/@name]/href"/></a></p>
            <p class="type-photo" id="inter-{@name}"><a class="interact" href="#" onclick="return delImg('{@name}');">Удалить</a> или <a class="interact" href="#" onclick="return loadImg('{@name}');">загрузить другой файл</a></p>
            <p class="type-photo" style="display: none" id="del-{@name}"><span class="delete">Будет удален при сохранении</span> (<a class="interact" href="#" onclick="return undelImg('{@name}');">отменить</a>)</p>

        <table class="nopad" style="display: none" id="browse-{@name}">
            <tbody><tr>
                <td><p class="bti">Выберите файл:</p></td>
                <td>
                    <div class="input-file f224">
                        <label>
                        <span>Browse</span>
                        <input type="file" name="{@name}" id="id-{@name}"/>
                        </label>
                        <div class="var">
                        <span class="input-txt"><input type="text" readonly="readonly" value="" id="id-text-{@name}" name="text-{@name}" class="txt" tabindex="-1"/></span>
                        </div>
                    </div>
                </td>
                <td><p class="bti"><a class="interact" href="#" onclick="return notloadImg('{@name}');">отменить</a></p></td>
                </tr>
        </tbody></table>
    </xsl:when>
    <xsl:otherwise>
        <table class="nopad">
            <tbody><tr>
                <td><p class="bti">Выберите файл:</p></td>
                <td>
                    <div class="input-file f224">
                        <label>
                        <span>Browse</span>
                        <input type="file" name="{@name}" id="id-{@name}" onchange="$('#cancel-{@name}').show('');"/>
                        </label>
                        <div class="var">
                        <span class="input-txt"><input type="text" readonly="readonly" value="" id="id-text-{@name}" name="text-{@name}" class="txt" tabindex="-1"/></span>
                        </div>
                    </div>
                </td>
                <td><p class="bti"><a class="interact" style="display:none;" id='cancel-{@name}' href="#" onclick="$('#id-text-{@name}').val(''); $('#id-{@name}').val(''); return false;">отменить</a></p></td>
                </tr>
        </tbody></table>
    </xsl:otherwise>
    </xsl:choose>
    <script>
    $(document).ready( function(){new FileUploadUI('<xsl:value-of select="@name"/>');});
    </script>
    </xsl:when>

</xsl:choose></td></tr>
</xsl:template>

<xsl:template match="data[@new]">
<xsl:if test="meta/col/type = 12">
        <link type="text/css" href="{/page/root}/css/adm/smoothness/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
        <script src="{/page/root}/js/adm/jquery-ui.js"></script>
        <script src="{/page/root}/js/adm/ui.datepicker-ru.js"></script>
</xsl:if>
<xsl:if test="meta/col/type = 7 or meta/col/type = 14">
      <script src="{/page/root}/js/adm/fileup.ui.js"></script>
</xsl:if>
<xsl:if test="meta/col/autocomplete='y'">
    <script type="text/javascript" src="{/page/root}/js/jquery.autocomplete.js"></script>
    <link rel="stylesheet" type="text/css" href="{/page/root}/css/jquery.autocomplete.css" />
</xsl:if>
<h1><xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/></h1>

    <xsl:apply-templates select="tabs" mode="edit"/>

<form method="POST" id="id-form" action="{/page/root}/admin/{name}/insert/" ENCTYPE="multipart/form-data">
<input type="reset" id="reset-form" style="display:none"/>

<input type="hidden" name="p" value="{@p}"/>

<table class="type-1">
    <col class="f173"/>
    <col class="l50"/>
<xsl:apply-templates select="meta/col[not(primary) and not(parent) and not(internal)]" mode="edit"/>
</table>
<div class="neutral save-all"><a href="#"><xsl:attribute name="onclick">$('#id-form').attr({'action':'<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>/insert/'});$('#id-form').submit(); return false;</xsl:attribute>Добавить</a></div>
</form>
<script>
$(':input').change(function(){
var xid = 'tr-'+$(this).attr('name');
$("#"+xid).addClass('spec');});
</script>
<br/>
</xsl:template>

<!-- Темплейт для добавления дополнительных контролов в форму редактирования -->
<xsl:template name="additional_edit_controls" />

<xsl:template match="data[@edit]">
<xsl:if test="meta/col/type = 12">
        <link type="text/css" href="{/page/root}/css/adm/smoothness/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
        <script src="{/page/root}/js/adm/jquery-ui.js"></script>
        <script src="{/page/root}/js/adm/ui.datepicker-ru.js"></script>
</xsl:if>
<xsl:if test="meta/col/type = 7 or meta/col/type = 14">
      <script src="{/page/root}/js/adm/fileup.ui.js"></script>
</xsl:if>
<xsl:if test="meta/col/autocomplete='y'">
    <script type="text/javascript" src="{/page/root}/js/jquery.autocomplete.js"></script>
    <link rel="stylesheet" type="text/css" href="{/page/root}/css/jquery.autocomplete.css" />
</xsl:if>
<xsl:if test="meta/col/popup = 'y'">
      <script>var field_activator = null; var field_selector = null;</script>
</xsl:if>
<xsl:if test="meta/col/translate='y'">
    <style type="text/css">@import url(/css/<xsl:value-of select="/page/update_id" />/jqModal.css);</style>
    <script type="text/javascript" src="{/page/root}/js/{/page/update_id}/jqModal.js"></script>
</xsl:if>

<h1><xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/></h1>

    <xsl:apply-templates select="tabs" mode="edit"/>

<form method="POST" id="id-form" action="{/page/root}/admin/{name}/update/" ENCTYPE="multipart/form-data">

<input type="hidden" name="id" value="{@id}"/>
<input type="hidden" name="p" value="{@p}"/>

<input type="reset" id="reset-form" style="display:none"/>

<table class="type-1">
    <col class="f173"/>
    <col class="l50"/>
    <xsl:apply-templates select="meta/col[not(primary) and not(parent) and (not(internal) or (internal and (type=15 or type=9))) and not(@name='xml')]" mode="edit"/>
    <xsl:if test="meta/col[@name='xml']">
    <tr>
        <td />
        <td>
            <a href="{/page/root}/admin/Editor/?id={@id}&amp;type={meta/col[@name='xml']/type}">xml</a>
        </td>
    </tr>
    </xsl:if>
    <xsl:call-template name="additional_edit_controls"/>
</table>

<div class="neutral save-all"><a href="#"><xsl:attribute name="onclick">$('#id-form').attr({'action':'<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>/update/'});$('#id-form').submit(); return false;</xsl:attribute>Сохранить</a></div>
</form>
<script>
$(':input').change(function(){
var xid = 'tr-'+$(this).attr('name');
$("#"+xid).addClass('spec');});
</script>
<br/>
    <xsl:if test="meta/col/translate='y'">
        <xsl:call-template name="translation_dialog"/>
        <script>
        var baseUrl = '<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>';
        var tname = '';
        var fname = '';
        var rid = <xsl:value-of select="@id"/>;

        $(function() {
            $('#translation_dialog').jqm({
                toTop:true,
                onShow: function(hash) {
                    hash.w.css({top: $(window).scrollTop() + Math.max(Math.floor(($(window).height()-670) / 2), 0)-200}).show();
                }
            });
        });

        function editTranslate(table_name, field_name) {
            tname = table_name;
            fname = field_name;
            $('#translation_inner').html('<p>Подождите. идет загрузка...</p>');
            $('#translation_inner').load(baseUrl + '/ajxTranslate/?tname=' + tname + <![CDATA['&fname=' + fname + '&rid=' + rid]]>);
            $('#translation_dialog').jqmShow();
            return false;
        }

        function saveTranslate() {
            fname = $('#name_field').val();

            $.post(baseUrl + '/ajxSaveTranslate/', $('#translate_form').serialize(), function(data){
                $("#flag_"+fname).html(data);
            });

            $('#translation_dialog').jqmHide();
            return false;
        }
        </script>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>