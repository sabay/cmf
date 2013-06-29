<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main.xsl"/>

<xsl:template name="section_url"><xsl:param name="cur" select="1"/>/site/admin/<xsl:value-of select="/page/data/name"/>/</xsl:template>

<xsl:template match="status_message">
    <h2><xsl:value-of select="." /></h2>
</xsl:template>

<xsl:template match="data">
<h1><xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/></h1>

<form action="/site/admin/{name}/doit/" method="POST" ENCTYPE="multipart/form-data" name="form-list" id="id-form">
<xsl:apply-templates select="status_message"/>
<xsl:value-of select="status_text" disable-output-escaping="yes" />
<div class="neutral save-all"><a onclick="$('#id-form').submit();" href="#">Выполнить операцию</a></div>

</form>
</xsl:template>


</xsl:stylesheet>