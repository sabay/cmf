<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main_simple.xsl"/>
<xsl:include href="_pager.xsl"/>
<xsl:include href="_filter.xsl"/>
<xsl:include href="_toolbar.xsl"/>

<xsl:template name="section_url"><xsl:param name="cur" select="1"/><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/</xsl:template>


<xsl:template match="col" mode="head">
<td><a>
	<xsl:attribute name="href"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/sort/&amp;s=<xsl:value-of select="@name"/>:0<xsl:call-template name="url-collector"><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:attribute>
<xsl:choose>
	<xsl:when test="@sort = 1">
		<xsl:attribute name="class">up</xsl:attribute>
		<xsl:attribute name="href"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/sort/&amp;s=<xsl:value-of select="@name"/>:0<xsl:call-template name="url-collector"><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:attribute>
	</xsl:when>
	<xsl:when test="@sort = 0">
		<xsl:attribute name="class">down</xsl:attribute>
		<xsl:attribute name="href"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/sort/&amp;s=<xsl:value-of select="@name"/>:1<xsl:call-template name="url-collector"><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:attribute>
	</xsl:when>
</xsl:choose>
	<span><xsl:apply-templates/></span></a>
</td>
</xsl:template>

<xsl:template match="*" mode="col"><td><xsl:apply-templates/></td></xsl:template>

<xsl:template match="col" mode="array">'<xsl:value-of select="@realname"/>'<xsl:if test="position() != last()">,</xsl:if></xsl:template>

<xsl:template match="row">
<tr id="tr-{@id}"><xsl:if test="@state!='1' or @status!=1"><xsl:attribute name="class">inactive</xsl:attribute></xsl:if>
<xsl:if test="/page/data/errors/error[@id=current()/@id]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if>

<td>
<xsl:choose>
	<xsl:when test="/page/data/@popup = 'spopup'"><a href="#">
		<xsl:attribute name="onclick">return getArr(this,<xsl:value-of select="@id"/>);</xsl:attribute>
		<img src="{/page/root}/i/adm/move.gif"/></a>
	</xsl:when>
	<xsl:when test="/page/data/@popup = 'mpopup'"><input type="checkbox" name="id[]" value="{@id}"/></xsl:when>
</xsl:choose>
</td>
<xsl:apply-templates select="*" mode="col"/>
<xsl:if test="/page/data/@ordering = 'y'">
<td class="l9">
<a href="{/page/root}/admin/{/page/data/name}/up/?id={@id}"><img hspace="5" border="0" title="Вверх" src="{/page/root}/i/adm/up.gif"/></a>
<a href="{/page/root}/admin/{/page/data/name}/dn/?id={@id}"><img hspace="5" border="0" title="Вниз" src="{/page/root}/i/adm/dn.gif"/></a>
</td>
</xsl:if>
</tr>
</xsl:template>

<xsl:template match="data">
<script>
function getArr(obj,id){
var f = Array(<xsl:apply-templates select="cols/col" mode="array"/>);
var a = Array();
jQuery(obj).parent().parent().children('td').each(function(i){
	if(i>0) a[f[i-1]] = jQuery(this).text();
});
opener.pSet(id,a,window);
return false;
}
</script>
<xsl:apply-templates select="filter"/>
<form action="{/page/root}/admin/{name}/" method="POST" ENCTYPE="multipart/form-data" name="form-list" id="id-form">
<xsl:if test="cols/col/@realname!='' and @input='y'"><xsl:attribute name="action"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>/saveindex/</xsl:attribute></xsl:if>
<xsl:apply-templates select="pager"/>
<input type="hidden" name="p" value="{pager/@page}"/>
<table class="type-2">
<thead>
<tr><td class="f33 first"><xsl:if test="@popup = 'mpopup'"><input type="checkbox" onclick="return SelectAll(this.form,checked,'id[]');"/></xsl:if></td>
<xsl:apply-templates select="cols/col" mode="head"/><xsl:if test="@ordering = 'y'"><td></td></xsl:if></tr>
</thead>
<xsl:apply-templates select="rows/row"/>
</table>
<xsl:apply-templates select="pager"><xsl:with-param name="page-size" select="1"/></xsl:apply-templates>
</form>
</xsl:template>


</xsl:stylesheet>