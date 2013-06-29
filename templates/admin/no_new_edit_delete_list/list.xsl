<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="../list.xsl"/>

    <xsl:template match="data">
        <h1><xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/></h1>
        <xsl:apply-templates select="filter"/>
        <xsl:apply-templates select="tabs" mode="list"/>
        <form action="/site/admin/{name}/" method="POST" ENCTYPE="multipart/form-data" name="form-list" id="id-form">
            <xsl:if test="@input='y'"><xsl:attribute name="action">/site/admin/<xsl:value-of select="name"/>/saveindex/</xsl:attribute></xsl:if>
            <xsl:apply-templates select="pager"/>
            <xsl:call-template name="toolbar"/>
            <input type="hidden" name="p" value="{pager/@page}"/>
            <table class="type-2">
                <thead>
                    <tr>
                        <xsl:apply-templates select="cols/col" mode="head"/>
                    </tr>
                </thead>
                <xsl:apply-templates select="rows/row"/>
            </table>
            <xsl:apply-templates select="pager"><xsl:with-param name="page-size" select="1"/></xsl:apply-templates>
        </form>
    </xsl:template>

    <xsl:template match="trigger_text" mode="col">
        <td>
            <xsl:choose>
                <xsl:when test="../@filter_type = 3"><a href="/images/blocked/{.}" target="_blank"><img src="/images/blocked/{.}" width="50px" height="50px"></img></a></xsl:when>
                <xsl:when test="../@filter_type = 1"><a href="{.}" target="_blank"><xsl:value-of select="."/></a></xsl:when>
                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
        </td>
    </xsl:template>

    <xsl:template match="row">
        <tr id="tr-{@id}"><xsl:if test="@state!='1' or @status!=1"><xsl:attribute name="class">inactive</xsl:attribute></xsl:if>
            <xsl:if test="/page/data/errors/error[@id=current()/@id]"><xsl:attribute name="class">warning</xsl:attribute></xsl:if>
            <xsl:apply-templates select="*" mode="col"></xsl:apply-templates>
        </tr>
    </xsl:template>

    <xsl:template name="toolbar">
    </xsl:template>

</xsl:stylesheet>