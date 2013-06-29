<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="list.xsl"/>

<xsl:template match="row" mode="simple">
<tr id="tr-{@id}"><xsl:if test="@state!='1' or @status!=1"><xsl:attribute name="class">inactive</xsl:attribute></xsl:if>
<xsl:if test="/page/data/errors/error[@id=current()/@id]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if>

<td class="first">45<input type="checkbox" name="id[]" value="{@id}"/></td>
<xsl:apply-templates select="*" mode="col"></xsl:apply-templates>
</tr>
</xsl:template>

<xsl:template match="data">
<h1><xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/></h1>
<xsl:apply-templates select="filter"/>
<xsl:apply-templates select="tabs" mode="list"/>
<form action="/site/admin/{name}/" method="POST" ENCTYPE="multipart/form-data" name="form-list" id="id-form">
<xsl:if test="@input='y'"><xsl:attribute name="action"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>/saveindex/</xsl:attribute></xsl:if>
<xsl:apply-templates select="pager"/>
<input type="hidden" name="p" value="{pager/@page}"/>
<table class="type-2">
<thead>
<tr>
<xsl:apply-templates select="cols/col" mode="head"/></tr>
</thead>
<xsl:apply-templates select="rows/row" mode="simple"/>
</table>
<xsl:apply-templates select="pager"><xsl:with-param name="page-size" select="1"/></xsl:apply-templates>
</form>
</xsl:template>

</xsl:stylesheet>