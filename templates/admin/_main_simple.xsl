<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" version="1.0" omit-xml-declaration="yes" encoding="utf-8"
    media-type="text/xml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

<xsl:decimal-format name="spaced" NaN="-" grouping-separator=" " digit="#" zero-digit="0" decimal-separator="," />
<xsl:template match="*" mode="spaced_float">
    <xsl:if test=". &gt;= 1000 or . &lt;= -1000">
        <xsl:attribute name="class">nbr</xsl:attribute>
    </xsl:if>
    <xsl:value-of select="format-number(., '### ##0,00', 'spaced')"/>
</xsl:template>

<xsl:template name="url-collector">
        <xsl:param name="add-p" select="1"/>
        <xsl:param name="add-count" select="1"/>
        <xsl:param name="add-s" select="1"/>
        <xsl:param name="add-pagesize" select="1"/>
        <xsl:param name="add-url" select="1"/>
<xsl:if test="$add-p = 1">&amp;p=<xsl:value-of select="/page/data/pager/@page"/>
</xsl:if><xsl:if test="$add-count = 1">&amp;count=<xsl:value-of select="/page/data/pager/@count"/>
</xsl:if><xsl:if test="$add-s = 1">&amp;s=<xsl:value-of select="/page/data/@s"/>
</xsl:if><xsl:if test="$add-pagesize = 1">&amp;pagesize=<xsl:value-of select="/page/data/@pagesize"/>
</xsl:if><xsl:if test="$add-url = 1"><xsl:value-of select="/page/data/add-url"/>
</xsl:if>
</xsl:template>


<xsl:template match="/page">
<html>
<head>
        <title>Система управления сайтом - <xsl:apply-templates select="name"/></title>
        <link href="{/page/root}/css/adm/main.css" rel="stylesheet" type="text/css" />

<xsl:comment>[if lte IE 7]&gt;&lt;link rel="stylesheet" type="text/css" href="/css/adm/ie.css"/&gt;&lt;![endif]</xsl:comment>
        <script src="{/page/root}/js/jquery.js"></script>
        <script src="{/page/root}/js/adm/admin.js"></script>
</head>
<body>
<div class="wopen">
				<xsl:apply-templates select="data"/>

</div>
</body>
</html>
</xsl:template>

</xsl:stylesheet>