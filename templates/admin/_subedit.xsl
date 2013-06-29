<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="error" mode="subedit">
<xsl:attribute name="style">color:red</xsl:attribute><xsl:apply-templates/>
</xsl:template>

<xsl:template match="*" mode="subhead">
<td><xsl:apply-templates/></td>
</xsl:template>


<xsl:template match="row" mode="subedit">
<tr>
<td>
	<input type="checkbox" name="{@name}[{position()}][delete]" value="1"/>
	<input type="hidden" name="{@name}[{position()}][{@name}_id]" value="{phone_id}"/>
</td>
<td>
<xsl:apply-templates select="/page/data/errors/error[@name=current()/@name]" mode="edit"/>
<xsl:choose>
	<xsl:when test="type=1">
		<input type="text" id="id-{@name}" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" class="txt f437" size="{@size}"></input>
	</xsl:when>
	<xsl:when test="type=3">
		<input type="text" name="{@name}"  id="id-{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}" class="txt f437"/>
	</xsl:when>
	<xsl:when test="type=4">
		<input type="text" name="{@name}" id="id-{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}" class="txt f437"/>
	</xsl:when>
	<xsl:when test="type=5">
		<input type="text" name="{@name}" id="id-{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}" class="f185"><xsl:if test="@panelize='y'"><xsl:attribute name="onfocus">_XDOC=this;</xsl:attribute><xsl:attribute name="onkeydown">_etaKey(event)</xsl:attribute></xsl:if></input>
	</xsl:when>
	<xsl:when test="type=6">
	<xsl:choose>
	<xsl:when test="popup='y'">
		<input type="hidden" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" id="id-{@name}"/>
		<input type="text" name="v_{@name}" value="{/page/data/values/multioptions/*[name()=current()/@name]/*}" id="vid-{@name}" class="txt f437" size="{@size}"/>
		<input type="button" onclick="return DictPopUp('{ref/table}','{@name}');" value="&#187;"/>
	</xsl:when>
	<xsl:otherwise>
		<select name="{@name}" id="id-{@name}" class="f185" size="{@size}">
		<xsl:if test="ref/none"><option value="0"><xsl:value-of select="ref/none"/></option></xsl:if>
		<xsl:copy-of select="/page/data/values/multioptions/*[name()=current()/@name]/*"/>
		</select>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:when>

	<xsl:when test="type=8">
		<input type='checkbox' name='{@name}' id="id-{@name}" class="check" value='1' select="@name"><xsl:if test="/page/data/values/*[name()=current()/@name]='1'"><xsl:attribute name="checked"></xsl:attribute></xsl:if></input>
	</xsl:when>

	<xsl:when test="type=10">
		<select name="{@name}" id="id-{@name}" class="f185" size="{@size}"><xsl:copy-of select="/page/data/values/multioptions/*[name()=current()/@name]/*"/></select>
	</xsl:when>

	<xsl:when test="type=12">
		<input type="text" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" id="id-{@name}" class="f185" size="{@size}"/>
		<xsl:if test="calendar">
		<link title="Flora (Default)" media="screen" type="text/css" href="/css/adm/flora.datepicker.css" rel="stylesheet"/>
		<script>$(document).ready(function(){$('#id-<xsl:value-of select="@name"/>').datepicker();});</script>
		<script>
		$("#id-<xsl:value-of select="@name"/>").datepicker($.extend({}, 
		$.datepicker.regional["ru"], {
    		    dateFormat: "yy-mm-dd", 
		    showStatus: true, 
		    showOn: "button", 
		    buttonImage: "/i/adm/calendar.gif", 
		    buttonImageOnly: true 
		}));
		</script></xsl:if>&#160;(YYYY-MM-DD)
	</xsl:when>
</xsl:choose>
</td></tr>
</xsl:template>


</xsl:stylesheet>