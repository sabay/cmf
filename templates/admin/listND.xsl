<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="list.xsl"/>
<xsl:include href="_toolbarND.xsl"/>


<xsl:template match="data">
<h1><xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/></h1>
<xsl:apply-templates select="filter"/>
<xsl:apply-templates select="tabs" mode="list"/>
<form action="{/page/root}/site/admin/{name}/" method="POST" ENCTYPE="multipart/form-data" name="form-list" id="id-form">
<xsl:if test="@input='y'"><xsl:attribute name="action"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>/saveindex/</xsl:attribute></xsl:if>
<xsl:apply-templates select="pager"/>
<xsl:call-template name="toolbarND"/>
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