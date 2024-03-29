<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="new.xsl"/>

<xsl:template match="data[@new]">
<xsl:if test="meta/col/type = 12">
        <link type="text/css" href="{/page/root}/css/adm/smoothness/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
        <script src="{/page/root}/js/adm/jquery-ui.js"></script>
        <script src="{/page/root}/js/adm/ui.datepicker-ru.js"></script>
</xsl:if>
<xsl:if test="meta/col/type = 7 or meta/col/type = 14">
      <script src="{/page/root}/js/adm/fileup.ui.js"></script>
</xsl:if>

<h1><xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/></h1>

    <xsl:apply-templates select="tabs" mode="edit"/>

<form method="POST" id="id-form" action="{/page/root}/admin/{name}/insert/" ENCTYPE="multipart/form-data">
<input type="reset" id="reset-form" style="display:none"/>
<input type="hidden" name="parent_id" value="{/page/data/@pid}"/>
<input type="hidden" name="id" value="{/page/data/@pid}"/>
<table class="type-1">
    <col class="f185"/>
    <col class="l100"/>
<xsl:apply-templates select="meta/col[not(primary) and not(parent) and not(internal) and not(noform)]" mode="edit"/>
</table>
<div class="neutral save-all"><a href="#"><xsl:attribute name="onclick">$('#id-form').attr({'action':'<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>/insert/'});$('#id-form').submit();</xsl:attribute>��������</a></div>
</form>
<script>
$(':input').change(function(){
var xid = 'tr-'+$(this).attr('name');
$("#"+xid).addClass('spec');});
</script>
<br/>
</xsl:template>

<xsl:template match="data[@edit]">
<xsl:if test="meta/col/type = 12">
        <link type="text/css" href="{/page/root}/css/adm/smoothness/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
        <script src="{/page/root}/js/adm/jquery-ui.js"></script>
        <script src="{/page/root}/js/adm/ui.datepicker-ru.js"></script>
</xsl:if>
<xsl:if test="meta/col/type = 7 or meta/col/type = 14">
      <script src="{/page/root}/js/adm/fileup.ui.js"></script>
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

<input type="reset" id="reset-form" style="display:none"/>

<table class="type-1">
    <col class="f185"/>
    <col class="l100"/>
    <xsl:apply-templates select="meta/col[not(primary) and not(parent) and not(noform) and (not(internal) or (internal and type=15))]" mode="edit"/>
    <tr>
        <td />
        <td>
            <a href="{/page/root}/admin/Editor/?id={@id}&amp;type={meta/col[@name='xml']/type}&amp;reurl={/page/root}/admin/{name}/edit/?id={@id}">xml</a>
        </td>
    </tr>
</table>

<div class="neutral save-all"><a href="#"><xsl:attribute name="onclick">$('#id-form').attr({'action':'<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>/update/'});$('#id-form').submit();</xsl:attribute>���������</a></div>
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
            $('#translation_inner').html('<p>���������. ���� ��������...</p>');
            $('#translation_inner').load(baseUrl + '/ajxTranslate/?tname=' + tname + <![CDATA['&fname=' + fname + '&rid=' + rid]]>);
            $('#translation_dialog').jqmShow();
            return false;
        }

        function saveTranslate() {
            fname = $('#name_field').val();
            $("#flag_"+fname).load(baseUrl + '/ajxSaveTranslate/?' + $('#translate_form').serialize());
            $('#translation_dialog').jqmHide();
            return false;
        }
        </script>
    </xsl:if>
</xsl:template>


</xsl:stylesheet>
