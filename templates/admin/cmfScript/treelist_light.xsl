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

    <xsl:template match="row">
        <tr id="tr{@id}"><xsl:if test="@rstate!='1'"><xsl:attribute name="class">inactive</xsl:attribute></xsl:if>
            <xsl:attribute name="style">
                <xsl:call-template name="row_style" />
                <xsl:if test="@level &gt; 1 and not(@openleaf)">display:none;</xsl:if>
            </xsl:attribute>
            <xsl:apply-templates select="*[name()!='row']" mode="col"></xsl:apply-templates>
            <td nowrap="" >
                <a href="{/page/root}/admin/{/page/data/name}/edit/?id={@id}"><img src="{/page/root}/i/adm/i/ed.gif" border="0" title="Изменить" hspace="5"/></a>
            </td>
        </tr>
        <xsl:apply-templates select="row"/>
    </xsl:template>

</xsl:stylesheet>