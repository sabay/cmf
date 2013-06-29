<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main.xsl"/>
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

<xsl:template match="col[@type = 1]" mode="input">
<xsl:param name="cur_value" select="0"/>
<xsl:param name="id_value" select="0"/>
<xsl:if test="/page/data/errors/error[@id = $id_value] and /page/data/errors/error[@name = current()/@realname]"><div class="incorrect"><xsl:value-of select="/page/data/errors/error[@id = $id_value and @name = current()/@realname]"/><strong/></div></xsl:if>
<input type="text" name="{/page/data/name}[{$id_value}][{@realname}]" id="{/page/data/name}[{$id_value}][{@realname}]" value="{$cur_value}" onchange="$('#tr-{$id_value}').addClass('spec');">
<xsl:if test="/page/data/errors/error[@id = $id_value] and /page/data/errors/error[@name = current()/@realname]">
<xsl:attribute name="value"><xsl:value-of select="/page/data/row_values/value[@id = $id_value and @name = current()/@name]"/></xsl:attribute>
</xsl:if>
</input>
</xsl:template>

<xsl:template match="*" mode="col">
<xsl:variable name="pos" select="position()"/>
<td>
	<xsl:choose>
	<xsl:when test="/page/data/cols/col[$pos]/@type"><xsl:apply-templates select="/page/data/cols/col[$pos]" mode="input"><xsl:with-param name="cur_value" select="."/><xsl:with-param name="id_value" select="../@id"/></xsl:apply-templates></xsl:when>

	<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
	</xsl:choose>
</td>
</xsl:template>


<xsl:template match="row">
<tr id="tr-{@id}"><xsl:if test="@state!='1' or @status!=1"><xsl:attribute name="class">inactive</xsl:attribute></xsl:if>
<xsl:if test="/page/data/errors/error[@id=current()/@id]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if>

<td class="first"><input type="checkbox" name="id[]" value="{@id}"/></td>
<xsl:apply-templates select="*" mode="col"></xsl:apply-templates>
<td>

<xsl:if test="/page/data/@ordering = 'y'">
    <a href="{/page/root}/admin/{/page/data/name}/up/?id={@id}"><img hspace="5" border="0" title="Вверх" src="{/page/root}/i/adm/up.gif"/></a>
    <a href="{/page/root}/admin/{/page/data/name}/dn/?id={@id}"><img hspace="5" border="0" title="Вниз" src="{/page/root}/i/adm/dn.gif"/></a>
</xsl:if>

<xsl:if test="@status">
    <a href="{/page/root}/admin/{/page/data/name}/vs/?id={@id}"><img src="{/page/root}/i/adm/i/v{1-@status}.gif" border="0"/></a> 
</xsl:if>

    <a><xsl:attribute name="href"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/edit/?id=<xsl:value-of select="@id"/><xsl:call-template name="url-collector"><xsl:with-param name="add-pagesize" select="0"/><xsl:with-param name="add-count" select="0"/><xsl:with-param name="add-s" select="0"/></xsl:call-template></xsl:attribute>
    <img src="{/page/root}/i/adm/i/ed.gif" border="0" title="Редактировать"/></a>
	
</td></tr>
</xsl:template>

<xsl:template match="data">
<h1><xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/></h1>
<xsl:apply-templates select="filter"/>
<xsl:apply-templates select="tabs" mode="list"/>
<form action="{/page/root}/admin/{name}/" method="POST" ENCTYPE="multipart/form-data" name="form-list" id="id-form">
<xsl:if test="@input='y'"><xsl:attribute name="action"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>/saveindex/</xsl:attribute></xsl:if>
<xsl:apply-templates select="pager"/>
<xsl:call-template name="toolbar"/>
<input type="hidden" name="p" value="{pager/@page}"/>
<table class="type-2">
<thead>
<tr><td class="f33 first"><input type="checkbox" onclick="return SelectAll(this.form,checked,'id[]');"/></td>
<xsl:apply-templates select="cols/col" mode="head"/><td class="f10"><xsl:if test="@ordering = 'y'"><xsl:attribute name="class">f84</xsl:attribute></xsl:if>Ред.</td></tr>
</thead>
<xsl:apply-templates select="rows/row"/>
</table>
<xsl:apply-templates select="pager"><xsl:with-param name="page-size" select="1"/></xsl:apply-templates>
</form>
</xsl:template>


</xsl:stylesheet>