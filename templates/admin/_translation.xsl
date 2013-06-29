<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="page">
            <xsl:apply-templates select="data"></xsl:apply-templates>
</xsl:template>

    <xsl:template match="item" mode="flag_draw">
        <img src="{/page/root}/images/localization/{image}" width="32" height="32" alt="{language_name}" title="{language_name}"/>
    </xsl:template>

    <xsl:template match="data[@mode = 'flag']">
        <xsl:apply-templates select="translation/item" mode="flag_draw"/>
    </xsl:template>

<xsl:template match="data">
    <form id="translate_form" class="scrollpop">
        <input type="hidden" name="name_table" id="name_table" value="{name_table}"/>
        <input type="hidden" name="name_field" id="name_field" value="{name_field}"/>
        <input type="hidden" name="record_id" id="record_id" value="{record_id}"/>
        <input type="hidden" name="languages" id="languages" value="{record_id}"><xsl:attribute name="value"><xsl:apply-templates select="translation/item" mode="value"/></xsl:attribute></input>
        <xsl:apply-templates select="translation/item"></xsl:apply-templates>
    </form>
</xsl:template>

    <xsl:template match="item">
        <img src="/images/localization/{image}" width="32" heigh="32"/> <xsl:value-of select="language_name"/>
        <textarea name="lang_{language_id}"  id="id-{language_id}" rows="10" cols="90" class="f379"><xsl:value-of select="translation"/></textarea>
        <br clear="all" /><br/>
    </xsl:template>

    <xsl:template match="item" mode="value">
        <xsl:value-of select="language_id"/><xsl:if test="position() != last()">;</xsl:if>
    </xsl:template>

</xsl:stylesheet>