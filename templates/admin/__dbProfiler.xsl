<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" version="1.0" omit-xml-declaration="yes" encoding="utf-8" media-type="text/xml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

<xsl:template match="query">
<tr><td><xsl:value-of select="@time"/></td><td><xsl:value-of select="."/></td></tr>
</xsl:template>

<xsl:template match="summary">
<table cellpadding="3" cellspacing="0" style="border:#00AAFF 1px solid">
<tr><td>����� ��������</td><td><xsl:value-of select="@count"/></td></tr>
<tr><td>��������� �������</td><td><xsl:value-of select="@totalTime"/> ���.</td></tr>
<tr><td>������� ����������������� �������</td><td><xsl:value-of select="@averageQueryLength"/> ���.</td></tr>
<tr><td>��������������� ������������������</td><td><xsl:value-of select="@queriesPerSecond"/> �������� � ���.</td></tr>
<tr><td>����� ������� �������</td><td><xsl:value-of select="@longestQueryLength"/></td></tr>
<tr><td>����� ������� �������</td><td><xsl:value-of select="longestQuery"/></td></tr>
</table>
</xsl:template>

<xsl:template match="/page">
<html>
<head><title>����� �� �������� � ��</title></head>
<body>
<xsl:apply-templates select="summary"/>
<h3>������ ��������</h3>
<table cellpadding="3" cellspacing="0" style="border:#00AAFF 1px solid">
<xsl:apply-templates select="query"/>
</table>
</body>
</html>
</xsl:template>

</xsl:stylesheet>