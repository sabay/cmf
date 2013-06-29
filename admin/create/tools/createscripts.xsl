<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="utf-8"/>
<xsl:include href="_script.xsl"/>
<xsl:include href="_childscript.xsl"/>
<xsl:include href="_treescript.xsl"/>

<xsl:template match="/config"><xsl:apply-templates select="table[not(@nogen)]"/></xsl:template>

</xsl:stylesheet>
