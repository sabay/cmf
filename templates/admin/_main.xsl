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
        <xsl:param name="add-pid" select="0"/>
<xsl:if test="$add-p = 1">&amp;p=<xsl:value-of select="/page/data/pager/@page"/>
</xsl:if><xsl:if test="$add-count = 1">&amp;count=<xsl:value-of select="/page/data/pager/@count"/>
</xsl:if><xsl:if test="$add-s = 1">&amp;s=<xsl:value-of select="/page/data/@s"/>
</xsl:if><xsl:if test="$add-pagesize = 1">&amp;pagesize=<xsl:value-of select="/page/data/@pagesize"/>
</xsl:if><xsl:if test="$add-pid = 1">&amp;pid=<xsl:value-of select="/page/data/@pid"/>
</xsl:if><xsl:if test="$add-url = 1"><xsl:value-of select="/page/data/add-url"/>
</xsl:if>
</xsl:template>

<!--  шаблоны визуального оформления по сохраненным стейтам-->
<xsl:template match="Estate"></xsl:template>
<xsl:template match="Estate[Esection='aside'][value=1]" mode="content_living">padding-left: 40px;</xsl:template>
<xsl:template match="Estate[Esection='aside'][value=1]" mode="aside">width: 0px;display: none;</xsl:template>
<xsl:template match="Estate[Esection='aside'][value=1]" mode="body">hidemenu</xsl:template>
<xsl:template match="Estate[Esection='aside'][value=0]" mode="body"/>
<xsl:template match="Estate[Esection='filter'][value=1]" mode="filter">display:none;</xsl:template>
<xsl:template match="Estate[Esection='filter'][value=1]" mode="filter-title">collapsed</xsl:template>
<xsl:template match="Estate[Esection='leftMenuItem'][value=1]" mode="leftMenu">collapsed</xsl:template>
<xsl:template match="Estate[Esection='leftMenuItem'][value=1]" mode="subleftMenu">display:none;</xsl:template>


<xsl:template match="menu" mode="page_top">
        <li><a href="{/page/root}/admin/&amp;id={id}"><xsl:if test="url!=''"><xsl:attribute name="href"><xsl:value-of select="/page/root"/>/<xsl:value-of select="url"/></xsl:attribute></xsl:if><xsl:value-of select="name"/></a></li>
</xsl:template>

<xsl:template match="menu[sel = 1]" mode="page_top">
        <li class="active"><a href="{/page/root}/admin/&amp;id={id}"><xsl:if test="url!=''"><xsl:attribute name="href"><xsl:value-of select="/page/root"/>/<xsl:value-of select="url"/></xsl:attribute></xsl:if><xsl:value-of select="name"/></a></li>
</xsl:template>

<xsl:template match="menu" mode="left">
            <xsl:variable name="mid"><xsl:apply-templates select="id"/></xsl:variable>
                                        <li id="leftMenuItem{id}"><xsl:attribute name="class"><xsl:apply-templates select="/page/head/profile/Estates/Estate[Esection='leftMenuItem'][id=$mid]" mode="leftMenu"/></xsl:attribute>
                                            <a href="#" onclick="return leftMenuItemCollapse('{id}');"><span><xsl:apply-templates select="name"/></span></a>
                                                <ul><xsl:attribute name="style"><xsl:apply-templates select="/page/head/profile/Estates/Estate[Esection='leftMenuItem'][id=$mid]" mode="leftMenu"/></xsl:attribute>
                                                        <xsl:apply-templates select="menu" mode="sub_left"/>
                                                </ul>
                                        </li>
</xsl:template>

<xsl:template match="menu" mode="sub_left">
        <li><a href="{/page/root}{url}" title="{description}"><xsl:apply-templates select="name"/></a></li>
</xsl:template>

<xsl:template match="menu[sel = 1]" mode="sub_left">
        <li class="active"><a href="{/page/root}{url}" title="{description}"><xsl:apply-templates select="name"/></a></li>
</xsl:template>

<xsl:template match="menu" mode="breadcrumbs">
<xsl:choose>
<xsl:when test="menu[sel = 1]">
        <span><xsl:apply-templates select="name"/></span><img alt="" src="{/page/root}/i/adm/rarr.gif"/><xsl:apply-templates select="menu[sel = 1]" mode="breadcrumbs_follow"/>
</xsl:when>
<xsl:otherwise>
        <span><xsl:apply-templates select="name"/></span><img alt="" src="{/page/root}/i/adm/rarr.gif"/>Добро пожаловать!
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="menu" mode="breadcrumbs_follow">
<xsl:choose>
        <xsl:when test="/page/data/@pid and (/page/data/@edit or /page/data/@new) and url!='' and menu">
                <a href="{/page/root}{url}&amp;p={/page/data/@p}"><xsl:apply-templates select="name"/></a><img alt="" src="{/page/root}/i/adm/rarr.gif"/>
                <a href="{/page/root}{url}cancel/&amp;id={/page/data/@pid}"><xsl:apply-templates select="tabname"/></a>
                <xsl:if test="menu[sel = 1]">
                        <img alt="" src="{/page/root}/i/adm/rarr.gif"/><xsl:apply-templates select="menu[sel = 1]" mode="breadcrumbs_follow"/>
                </xsl:if>
        </xsl:when>

        <xsl:when test="/page/data/@pid and (/page/data/@edit or /page/data/@new) and url!=''">
                <a href="{/page/root}{url}return/&amp;pid={/page/data/@pid}"><xsl:apply-templates select="name"/></a>
                <xsl:if test="menu[sel = 1]">
                        <img alt="" src="{/page/root}/i/adm/rarr.gif"/><xsl:apply-templates select="menu[sel = 1]" mode="breadcrumbs_follow"/>
                </xsl:if>
        </xsl:when>

        <xsl:when test="/page/data/@pid and menu and url!=''">
                <a href="{/page/root}{url}&amp;p={/page/data/@p}"><xsl:apply-templates select="name"/></a><img alt="" src="{/page/root}/i/adm/rarr.gif"/>
                <a href="{/page/root}{url}edit/&amp;id={/page/data/@pid}"><xsl:apply-templates select="tabname"/></a>
                <xsl:if test="menu[sel = 1]">
                        <img alt="" src="{/page/root}/i/adm/rarr.gif"/><xsl:apply-templates select="menu[sel = 1]" mode="breadcrumbs_follow"/>
                </xsl:if>
        </xsl:when>


        <xsl:when test="(/page/data/@edit or /page/data/@new) and not(menu[sel = 1])">
                <a href="{/page/root}{url}&amp;p={/page/data/@p}"><xsl:apply-templates select="name"/></a>
        </xsl:when>

        <xsl:otherwise>
                <span><xsl:apply-templates select="name"/></span>
                <xsl:if test="menu[sel = 1]">
                        <img alt="" src="{/page/root}/i/adm/rarr.gif"/><xsl:apply-templates select="menu[sel = 1]" mode="breadcrumbs_follow"/>
                </xsl:if>
        </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="menu" mode="h1">
<xsl:choose>
<xsl:when test="menu[sel = 1]">
        <xsl:apply-templates select="menu[sel = 1]" mode="h1"/>
</xsl:when>
<xsl:otherwise>
        <xsl:apply-templates select="name"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="menu" mode="filter">
<xsl:choose>
<xsl:when test="menu[sel = 1]">
        <xsl:apply-templates select="menu[sel = 1]" mode="filter"/>
</xsl:when>
<xsl:otherwise>
        <xsl:apply-templates select="id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="tabname[.='']">
    <xsl:apply-templates select="./name"/>
</xsl:template>

<xsl:template match="tabname[.='']" mode="child">
    <xsl:apply-templates select="./name"/>
</xsl:template>

<xsl:template match="tab" mode="edit"><li><a href="{/page/root}{url}&amp;pid={/page/data/@id}"><xsl:apply-templates select="name"/></a></li></xsl:template>
<xsl:template match="tab[1]" mode="edit"><li class="active"><a href="{/page/root}{url}edit/&amp;id={/page/data/@id}"><xsl:apply-templates select="tabname"/></a></li></xsl:template>
<xsl:template match="tabs" mode="edit">
    <xsl:choose>
        <xsl:when test="count(tab)=1"><h2><xsl:apply-templates select="tab[1]/tabname"/></h2></xsl:when>
        <xsl:otherwise>
            <ul class="details level"><xsl:apply-templates select="tab" mode="edit"/></ul>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="tab[1]" mode="child"><li><a href="{/page/root}{url}edit/&amp;id={/page/data/@pid}"><xsl:apply-templates select="tabname" mode="child"/></a></li></xsl:template>
<xsl:template match="tab" mode="child"><li><a href="{/page/root}{url}&amp;pid={/page/data/@pid}"><xsl:apply-templates select="name"/></a></li></xsl:template>
<xsl:template match="tab[cur = 1]" mode="child"><li class="active"><a href="{/page/root}{url}&amp;pid={/page/data/@pid}"><xsl:apply-templates select="name"/></a></li></xsl:template>
<xsl:template match="tabs" mode="child"><ul class="details level"><xsl:apply-templates select="tab" mode="child"/></ul></xsl:template>

<!-- new style end-->
<xsl:template match="/page">
<html>
<head>
        <title>Система управления сайтом - <xsl:apply-templates select="name"/></title>
        <link href="{/page/root}/css/adm/main.css" rel="stylesheet" type="text/css" />

<xsl:comment>[if lte IE 7]&gt;&lt;link rel="stylesheet" type="text/css" href="/css/adm/ie.css"/&gt;&lt;![endif]</xsl:comment>

        <script src="{/page/root}/js/jquery.js"></script>
        <script src="{/page/root}/js/adm/admin.js"></script>
        <link rel="icon" type="image/png" href="/favicon.png"/>
</head>
<body><xsl:attribute name="class"><xsl:apply-templates select="/page/head/profile/Estates/Estate[Esection='aside']" mode="body"/></xsl:attribute>
<div class="page">

<xsl:if test="data/name and (data/@edit or data/@new or data/@input='y')">
        <div class="panel">
                <ul>
                        <li><a href="#" onclick="return false;"><xsl:if test="data/name and (data/@edit or data/@new or data/@input='y')"><xsl:attribute name="onclick">$('#id-form').submit();</xsl:attribute></xsl:if><img alt="" src="{/page/root}/i/adm/save.gif"/><span>Сохр.</span></a></li>
<!--                    <li><a href="#" onclick="return false;"><xsl:if test="data/name"><xsl:attribute name="onclick">$('#id-form').submit();</xsl:attribute></xsl:if><img alt="" src="{/page/root}/i/adm/save.gif"/><span>Сохр.</span></a></li>-->
                        <li><a href="#" onclick="return false;">
                                <xsl:choose>
                                        <xsl:when test="data/name and (data/@edit)"><xsl:attribute name="onclick">$('#id-form').attr({'action':'<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="data/name"/>/cancel/'}); $('#id-form').submit();return false;</xsl:attribute></xsl:when>
                                        <xsl:when test="data/name and (data/@new)"><xsl:attribute name="onclick">$('#id-form').attr({'action':'<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="data/name"/>/new/<xsl:if test="data/@pid">&amp;pid=<xsl:value-of select="data/@pid"/></xsl:if>'}); $('#id-form').submit();return false;</xsl:attribute></xsl:when>

                                </xsl:choose>
                        <img alt="" src="{/page/root}/i/adm/cancel.gif"/><span>Отм.</span></a></li>
                        <li><a href="#" onclick="return false;" id="panel_back"><xsl:if test="data/name and (data/@edit or data/@new)"><xsl:attribute name="onclick">$('#id-form').attr({'action':'<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="data/name"/>/'}); $('#id-form').submit();return false;</xsl:attribute></xsl:if><img alt="" src="{/page/root}/i/adm/back.gif"/><span>Назад</span></a></li>
                </ul>
        </div>
</xsl:if>

        <div class="header">
                <ul class="serv">
                        <li><a href="{/page/root}/admin/login/&amp;act=logout">Выход</a></li>
<!--                        <li><a href="#">Помощь</a></li>
                        <li><a href="#">English</a></li>
                        <li><a href="#">Настройки</a></li>-->
                        <li><xsl:apply-templates select="head/profile/email"/></li>
                        <xsl:if test="head/profile/role_id=5">
                        <li><a style="color: red;" href="/smanager/UserSites/">Перейти к интерфейсу менеджера</a></li>
                        </xsl:if>
                </ul>

                <a href="/" id="logo"><h1>CMS</h1></a>

                <ul class="main">
                        <xsl:apply-templates select="menu" mode="page_top"/>
                </ul>
        </div>
        <div class="wrap">
                <div class="content">
                        <div class="lining" id="content_living"><xsl:attribute name="style"><xsl:apply-templates select="/page/head/profile/Estates/Estate[Esection='aside']" mode="content_living"/></xsl:attribute>
                            <div class="breadcrumbs">
                                    <xsl:apply-templates select="menu[sel = 1]" mode="breadcrumbs"/>
                            </div>
                                <div class="show" onclick="return leftMenuCollapse();"></div>
                                <xsl:apply-templates select="data"/>
                        </div>
                </div>

                <div class="aside" id="aside"><xsl:attribute name="style"><xsl:apply-templates select="/page/head/profile/Estates/Estate[Esection='aside']" mode="aside"/></xsl:attribute>
                        <div class="lining">
                <div class="hide">
                        <a href="#" onclick="return leftMenuCollapse();"><span>Спрятать меню</span></a>
                </div>
                                <ul class="nav">
                                        <xsl:apply-templates select="menu[sel=1]/menu" mode="left"/>
                                </ul>
                        </div>
                </div>

        </div>

</div>
<div class="footer">
        <!--ul class="serv">
                <li><a href="#">Контакты</a></li>
        </ul-->
        <p class="copy">&#169; ProfitWizard, 2011<xsl:if test="/page/year != 2009"> - <xsl:value-of select="/page/year"/></xsl:if></p>
</div>
</body>
</html>
</xsl:template>

<xsl:template match="error">
    <p class="correct"><xsl:apply-templates/></p>
</xsl:template>

</xsl:stylesheet>