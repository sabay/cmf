<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="../treelist.xsl"/>

<xsl:template match="*[name() = 'type']" mode="head" />
<xsl:template match="*[name() = 'type']" mode="col" />

<xsl:template name="row_style">
    <xsl:if test="type = '3'">background-color: #e4ecf6; font-size: 0.7em;</xsl:if>
</xsl:template>

<xsl:template match="name[../type = '3']" mode="col">
    <td class="expanded">
        <xsl:attribute name="class">level<xsl:value-of select="../@level"/></xsl:attribute>
        <xsl:apply-templates/>
    </td>
</xsl:template>

</xsl:stylesheet>