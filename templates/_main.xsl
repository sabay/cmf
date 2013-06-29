<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:include href="_base.xsl"/>

<xsl:template match="error">
	<p class="incorrect">
		<xsl:apply-templates />
	</p>
</xsl:template>

<xsl:template match="menu" mode="footer">
	<li><a href="{/page/root}/doc{path}/"><xsl:if test="url!=''"><xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute></xsl:if><xsl:value-of select="name" /></a></li>
</xsl:template>

<xsl:template match="menu[@sel='1']" mode="footer">
	<li><strong><xsl:value-of select="name" /></strong><i></i></li>
</xsl:template>

<xsl:template match="menu" mode="splash">
	<a href="{/page/root}/doc{path}/"><xsl:if test="url!=''"><xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute></xsl:if><xsl:if test="@new='1'"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if><xsl:value-of select="name" /></a><xsl:if test="position()!=last()"> | </xsl:if>
</xsl:template>

<xsl:template match="menu[@sel='1']" mode="splash">
	<strong><xsl:value-of select="name" /></strong><xsl:if test="position()!=last()"> | </xsl:if>
</xsl:template>

<xsl:template match="page">
<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> ]]></xsl:text>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="{/page/root}/css/main.css" />
<xsl:text disable-output-escaping="yes">&lt;!--[if lte IE 7]&gt;</xsl:text><link rel="stylesheet" type="text/css"><xsl:attribute name="href"><xsl:value-of select="/page/root"/>/css/<xsl:value-of select="/page/update_id"/>/ie.css</xsl:attribute></link><xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>
<title><xsl:value-of select="title" /></title>
</head>

<body>
<div class="page">
	<div class="wrap">
		<div class="l-logo">
			<h1><a href="{/page/root}/">CMS</a></h1>
		</div>
		<div class="splashmenu">
			<xsl:apply-templates select="menu" mode="splash"/>
		</div>
		<xsl:apply-templates select="data"/>
	</div>
</div>
<div class="footer">
	<p class="lt">© 2011 Profit - Wizard</p>
	<ul>
		<xsl:apply-templates select="footer/menu" mode="footer"/>
	</ul>
</div>
</body>
</html>
</xsl:template>


</xsl:stylesheet>
