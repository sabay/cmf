<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="../list.xsl"/>

<xsl:template match="row">
<tr id="tr-{@id}"><xsl:if test="@state!='1' or @status!=1"><xsl:attribute name="class">inactive</xsl:attribute></xsl:if>
<xsl:if test="/page/data/errors/error[@id=current()/@id]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if>

<td class="first"><input type="checkbox" name="id[]" value="{@id}"/></td>
<xsl:apply-templates select="*" mode="col"></xsl:apply-templates>
<td nowrap="yes">

<xsl:if test="/page/data/@ordering = 'y'">
    <a href="{/page/root}/admin/{/page/data/name}/up/?id={@id}"><img hspace="5" border="0" title="Вверх" src="{/page/root}/i/adm/up.gif"/></a>
    <a href="{/page/root}/admin/{/page/data/name}/dn/?id={@id}"><img hspace="5" border="0" title="Вниз" src="{/page/root}/i/adm/dn.gif"/></a>
</xsl:if>

<xsl:if test="@status">
    <a href="{/page/root}/admin/{/page/data/name}/vs/?id={@id}"><img src="{/page/root}/i/adm/i/v{1-@status}.gif" border="0"/></a> 
</xsl:if>
    <a href="{/page/root}/admin/trafSetup?pid={@id}"><img src="{/page/root}/i/adm/i/flt.gif" border="0" title="Настройки закупки трафа"/></a>&#160;
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
<thead>
<tr><td></td><td></td><td>Итого:</td><td><xsl:value-of select="@sumpercent"/></td><td></td></tr>
</thead>
</table>
<xsl:apply-templates select="pager"><xsl:with-param name="page-size" select="1"/></xsl:apply-templates>
</form>
</xsl:template>

</xsl:stylesheet>