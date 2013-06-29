<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main_simple.xsl"/>
<xsl:include href="_subedit.xsl"/>

<xsl:template match="option" mode="radio">
<xsl:param name="xname" select="1"/>
<xsl:param name="xvalue" select="1"/>
					<input type="radio" id="{$xname}-6-1" name="{$xname}" value="{@value}"><xsl:if test="@value = $xvalue"><xsl:attribute name="checked"></xsl:attribute></xsl:if></input>
					<label for="{$xname}-6-1" class="radio-inline"><xsl:value-of select="."/></label>
</xsl:template>


<xsl:template match="error" mode="edit">
	<p class="correct"><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="col[type=15 and internal='y']" mode="edit">
<tr id="tr-{@name}"><xsl:if test="/page/data/errors/error[@name=current()/@name]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if>
<td colspan="2">
<script>
var cur_<xsl:value-of select='@name'/>=<xsl:value-of select="count(/page/data/values/*[name()=current()/@name]/row)"/>;
$('#but-add-<xsl:value-of select='@name'/>').click(function(){
        cur_<xsl:value-of select='@name'/>=cur_<xsl:value-of select='@name'/>+1;
        $('#phones').append('<tr>'+
'<td><input type="checkbox" name="phones['+curphone+'][delete]" value="1"/></td>'+
'<td><select name="phones['+curphone+'][type]">'+'<option value="1">тел.</option>'+'<option value="2">факс.</option></select></td>'+
'<td><input type="text" name="phones['+curphone+'][country_code]" size="5" value="{country_code}"/></td>'+
'<td><input type="text" name="phones['+curphone+'][city_code]" size="5" value="{city_code}"/></td>'+
'<td><input type="text" name="phones['+curphone+'][number]" size="20" value="{number}"/></td>'+
'<td><input type="text" name="phones['+curphone+'][additional_number]" size="10" value="{additional_number}"/></td>'+
'<td><input type="text" name="phones['+curphone+'][comment]" size="50" value="{comment}"/></td>'+
'<td><input type="checkbox" name="phones['+curphone+'][status]" value="1"/></td>'+
'</tr>');
        return false;
});
</script>

		<ul class="addel">
			<li class="pos"><a href="#"  id="but-add-{@name}">Добавить</a></li>
			<li class="neg"><a href="#" id="but-del-{@name}">Удалить</a></li>
		</ul>

<table class="type-2">
<thead>
<tr><td class="f33 first"><input type="checkbox" onclick="return SelectAll(this.form,checked,'subid-{@name}[]');"/></td>
<xsl:apply-templates select="cols/*" mode="subhead"/><td>тип</td>
<td>код страны</td>
<td>код города</td>
<td>номер</td>
<td>доб.</td>
<td>примеч.</td>
<td></td></tr>
</thead>
<xsl:apply-templates select="cols/*" mode="edit"/>
</table>
</td></tr>
</xsl:template>


<xsl:template match="col" mode="edit">
<!--<xsl:apply-templates select="/page/data/errors/error[@name=current()/@name]" mode="edit"/>-->
<tr id="tr-{@name}"><xsl:if test="/page/data/errors/error[@name=current()/@name]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if>
<td><p class="lbl"><label for="id-{@name}"><xsl:apply-templates select="name"/></label></p></td><td  class="tbcontent">
<xsl:apply-templates select="/page/data/errors/error[@name=current()/@name]" mode="edit"/>
<xsl:choose>
	<xsl:when test="type=1">
		<span class="input-txt">
		<input type="text" id="id-{@name}" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" class="txt f437" size="{@size}"></input>
		</span>
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
		<input type="text" name="{@name}" id="id-{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}" class="f185"><xsl:if test="@panelize='y'"><xsl:attribute name="onfocus">_XDOC=this;</xsl:attribute><xsl:attribute name="onkeydown">_etaKey(event)</xsl:attribute></xsl:if></input>
		</span>
	</xsl:when>
	<xsl:when test="type=6">
	<xsl:choose>
	<xsl:when test="popup='y'">
		<span class="input-txt">
		<input type="hidden" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" id="id-{@name}"/>
		<input type="text" name="v_{@name}" value="{/page/data/values/multioptions/*[name()=current()/@name]/*}" id="vid-{@name}" class="txt f437" onfocus="this.blur();"/>
<!--		<input type="button" onclick="return DictPopUp('{ref/table}','{@name}');" value="&#187;"/>-->
		<input type="button" onclick="field_activator = 'id-{@name}'; field_selector = '{ref/visual}'  ;return DictPopUp('/admin/{controller}Sp/');" value="&#187;"/>
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
	<input type="hidden" name="CLR_{@name}" value="0" id="CLR_{@name}"/>
	<xsl:choose>
	<xsl:when test="/page/data/values/*[name()=current()/@name]/w &gt; 0">
			<img class="preview" src="/images{/page/data/@imgpath}{dir}{/page/data/values/*[name()=current()/@name]/src}" alt="" width="{/page/data/values/*[name()=current()/@name]/w}" height="{/page/data/values/*[name()=current()/@name]/h}"/>
			<p class="type-photo"><a href="/images{/page/data/@imgpath}{dir}{/page/data/values/*[name()=current()/@name]/src}" target="_blank"><xsl:value-of select="/page/data/values/*[name()=current()/@name]/src"/>&#160;(<xsl:value-of select="/page/data/values/*[name()=current()/@name]/w"/>x<xsl:value-of select="/page/data/values/*[name()=current()/@name]/h"/>)</a></p>
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
						<input type="file" name="{@name}" id="id-{@name}"/>
						</label>
						<div class="var">
						<span class="input-txt"><input type="text" readonly="readonly" value="" id="id-text-{@name}" name="text-{@name}" class="txt" tabindex="-1"/></span> 
						</div>
					</div>									
				</td>
				<td><p class="bti"><a class="interact" href="#" onclick="$('#id-text-{@name}').val(''); $('#id-{@name}').val(''); return false;">отменить</a></p></td>
				</tr>
		</tbody></table>
	</xsl:otherwise>
	</xsl:choose>
	<script>
	$(document).ready( function(){new FileUploadUI('<xsl:value-of select="@name"/>');});
	</script>
	</xsl:when>


	<xsl:when test="type=8">
		<input type='checkbox' name='{@name}' id="id-{@name}" class="check" value='1' select="@name"><xsl:if test="/page/data/values/*[name()=current()/@name]='1'"><xsl:attribute name="checked"></xsl:attribute></xsl:if></input>
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
		<input type="text" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" id="id-{@name}" class="txt f185"/>
		</span>
		<xsl:if test="calendar">
		<link title="Flora (Default)" media="screen" type="text/css" href="/css/adm/flora.datepicker.css" rel="stylesheet"/>
		<script>$(document).ready(function(){
		$("#id-<xsl:value-of select="@name"/>").datepicker($.extend({}, 
		$.datepicker.regional["ru"], {
    		    dateFormat: "yy-mm-dd", 
		    showStatus: true, 
		    showOn: "button", 
		    buttonImage: "/i/adm/calendar.gif", 
		    buttonImageOnly: true}));

		$('#id-<xsl:value-of select="@name"/>').datepicker();});
		</script>
		</xsl:if>&#160;(YYYY-MM-DD)
	</xsl:when>
	<xsl:when test="type=13">
		<select name="{@name}" id="id-{@name}" class="f185"><xsl:if test="ref/none"><option value="0"><xsl:value-of select="ref/none"/></option></xsl:if>V_STR_<xsl:value-of select="@name"/></select>
	</xsl:when>

	<xsl:when test="type=14">
		<input type="hidden" name="old_{@name}" value="{/page/data/values/*[name()=current()/@name]/full}"><xsl:if test="/page/data/values/*[name()=concat('old_',current()/@name)]"><xsl:attribute name="value"><xsl:value-of select="/page/data/values/*[name()=concat('old_',current()/@name)]"/></xsl:attribute></xsl:if></input>
		<table><tr><td><input type="file" name="{@name}" size="1"/><br/><input type="checkbox" name="CLR_{@name}" value="1"/>сбросить файл.</td>
		<td>&#160;</td><td>size=<xsl:value-of select="@name"/><br/>/images/<xsl:value-of select="@name"/>
		</td></tr></table>
	</xsl:when>
</xsl:choose></td></tr>
</xsl:template>

<xsl:template match="data[@new]">
<xsl:if test="meta/col/type = 12">
        <script src="{/page/root}/js/adm/ui.datepicker.js"></script>
        <script src="{/page/root}/js/adm/ui.datepicker-ru.js"></script>
</xsl:if>
<xsl:if test="meta/col/type = 7">
      <script src="{/page/root}/js/adm/fileup.ui.js"></script>
</xsl:if>

<h1>Добавление - <xsl:apply-templates select="name"/></h1>

	<xsl:apply-templates select="tabs" mode="edit"/>

<form method="POST" id="id-form" action="/admin/{name}/insert/" ENCTYPE="multipart/form-data">
<input type="reset" id="reset-form" style="display:none"/>

<input type="hidden" name="p" value="{@p}"/>

<table class="type-1">
	<col class="f185"/>
	<col class="l100"/>
<xsl:apply-templates select="meta/col[not(primary) and not(parent) and not(internal) and not(noform)]" mode="edit"/>
</table>
<div class="neutral save-all"><a href="#"><xsl:attribute name="onclick">$('#id-form').attr({'action':'/admin/<xsl:value-of select="name"/>/insert/'});$('#id-form').submit();</xsl:attribute>Добавить</a></div>
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
        <script src="{/page/root}/js/adm/ui.datepicker.js"></script>
        <script src="{/page/root}/js/adm/ui.datepicker-ru.js"></script>
</xsl:if>
<xsl:if test="meta/col/type = 7">
      <script src="{/page/root}/js/adm/fileup.ui.js"></script>
</xsl:if>
<xsl:if test="meta/col/popup = 'y'">
      <script>var field_activator = null; var field_selector = null;</script>
</xsl:if>

	<h1>Редактирование - <xsl:apply-templates select="name"/></h1>

	<xsl:apply-templates select="tabs" mode="edit"/>

<form method="POST" id="id-form" action="/admin/{name}/update/" ENCTYPE="multipart/form-data">

<input type="hidden" name="id" value="{@id}"/>
<input type="hidden" name="p" value="{@p}"/>

<input type="reset" id="reset-form" style="display:none"/>

<table class="type-1">
	<col class="f185"/>
	<col class="l100"/>
	<xsl:apply-templates select="meta/col[not(primary) and not(parent) and not(noform) and (not(internal) or (internal and (type=15 or type=9)))]" mode="edit"/>
</table>

<div class="neutral save-all"><a href="#"><xsl:attribute name="onclick">$('#id-form').attr({'action':'/admin/<xsl:value-of select="name"/>/update/'});$('#id-form').submit();</xsl:attribute>Сохранить</a></div>
</form>
<script>
$(':input').change(function(){
var xid = 'tr-'+$(this).attr('name');
$("#"+xid).addClass('spec');});
</script>
<br/>
</xsl:template>

</xsl:stylesheet>