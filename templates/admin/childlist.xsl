<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main.xsl"/>
<xsl:include href="_pager.xsl"/>
<xsl:include href="_filter.xsl"/>
<xsl:include href="_toolbar.xsl"/>

<xsl:template name="section_url"><xsl:param name="cur" select="1"/><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/&amp;pid=<xsl:value-of select="/page/data/@pid"/></xsl:template>


<!--xsl:template match="col" mode="head">
<td><a>
        <xsl:attribute name="href">&amp;pid=<xsl:value-of select="/page/data/@pid"/>&amp;s=<xsl:value-of select="@name"/>:0<xsl:call-template name="url-collector"><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:attribute>
        <xsl:attribute name="onclick">setQ('s','<xsl:value-of select="@name"/>:0','not_state');</xsl:attribute>
<xsl:choose>
    <xsl:when test="@sort = 1">
        <xsl:attribute name="class">up</xsl:attribute>
        <xsl:attribute name="href">&amp;pid=<xsl:value-of select="/page/data/@pid"/>&amp;s=<xsl:value-of select="@name"/>:0<xsl:call-template name="url-collector"><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:attribute>
    <xsl:attribute name="onclick">setQ('s','<xsl:value-of select="@name"/>:0','not_state');</xsl:attribute>
    </xsl:when>
    <xsl:when test="@sort = 0">
        <xsl:attribute name="class">down</xsl:attribute>
        <xsl:attribute name="href">&amp;pid=<xsl:value-of select="/page/data/@pid"/>&amp;s=<xsl:value-of select="@name"/>:1<xsl:call-template name="url-collector"><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:attribute>
        <xsl:attribute name="onclick">setQ('s','<xsl:value-of select="@name"/>:1','not_state');</xsl:attribute>
    </xsl:when>
</xsl:choose>
    <span><xsl:apply-templates/></span></a>
</td>
</xsl:template-->

    <xsl:template match="col" mode="head">
        <td><a>
            <xsl:attribute name="href"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/sort/&amp;s=<xsl:value-of select="@name"/>:0<xsl:call-template name="url-collector"><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/><xsl:with-param name="add-pid" select="1"/></xsl:call-template></xsl:attribute>
            <xsl:choose>
                <xsl:when test="@sort = 1">
                    <xsl:attribute name="class">up</xsl:attribute>
                    <xsl:attribute name="href"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/sort/&amp;s=<xsl:value-of select="@name"/>:0<xsl:call-template name="url-collector"><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/><xsl:with-param name="add-pid" select="1"/></xsl:call-template></xsl:attribute>
                </xsl:when>
                <xsl:when test="@sort = 0">
                    <xsl:attribute name="class">down</xsl:attribute>
                    <xsl:attribute name="href"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/sort/&amp;s=<xsl:value-of select="@name"/>:1<xsl:call-template name="url-collector"><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/><xsl:with-param name="add-pid" select="1"/></xsl:call-template></xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <span><xsl:apply-templates/></span></a>
        </td>
    </xsl:template>

<xsl:template match="*" mode="col">
<td><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="row">
<tr><xsl:if test="@state!='1' or @status!=1"><xsl:attribute name="class">inactive</xsl:attribute></xsl:if>
<td class="first"><input type="checkbox" name="id[]" value="{@id}"/></td>
<xsl:apply-templates select="*" mode="col"></xsl:apply-templates>
<td class="l9">
<a><xsl:attribute name="href"><xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="/page/data/name"/>/edit/?id=<xsl:value-of select="@id"/>&amp;pid=<xsl:value-of select="/page/data/@pid"/><xsl:call-template name="url-collector"><xsl:with-param name="add-pagesize" select="0"/><xsl:with-param name="add-count" select="0"/><xsl:with-param name="add-s" select="0"/></xsl:call-template></xsl:attribute><img src="{/page/root}/i/adm/i/ed.gif" border="0" title="Редактировать"/></a>
<xsl:if test="/page/data/@ordering = 'y'">
<a href="{/page/root}/admin/{/page/data/name}/up/?id={@id}"><img hspace="5" border="0" title="Вверх" src="{/page/root}/i/adm/up.gif"/></a>
<a href="{/page/root}/admin/{/page/data/name}/dn/?id={@id}"><img hspace="5" border="0" title="Вниз" src="{/page/root}/i/adm/dn.gif"/></a>
</xsl:if>
</td></tr>
</xsl:template>


<xsl:template match="data">
<h1>
    <xsl:if test="mainTitle"><xsl:value-of select="mainTitle"/>:&#160;</xsl:if>
    <xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/>
</h1>
<xsl:apply-templates select="filt"/>
<xsl:apply-templates select="tabs" mode="child"/>
<form action="{/page/root}/admin/{name}/" method="POST" ENCTYPE="multipart/form-data" name="form-list" id="id-form">
<xsl:apply-templates select="pager"/>
<xsl:call-template name="toolbar"/>

<input type="hidden" name="p" value="{pager/@page}"/>
<input type="hidden" name="pid" value="{@pid}"/>

<table class="type-2">
<thead>
<tr><td class="f33 first"><input type="checkbox" onclick="return SelectAll(this.form,checked,'id[]');"/></td>
<xsl:apply-templates select="cols/col" mode="head"/><td></td></tr>
</thead>
<xsl:apply-templates select="rows/row"/>
</table>
<xsl:apply-templates select="pager"><xsl:with-param name="page-size" select="1"/></xsl:apply-templates>
</form>
</xsl:template>


</xsl:stylesheet>