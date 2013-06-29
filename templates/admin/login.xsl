<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" version="1.0" omit-xml-declaration="yes" encoding="utf-8"
    media-type="text/xml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

<xsl:template match="/page">
<xsl:apply-templates select="data"/>
</xsl:template>

    <xsl:template match="error">
        <p class="correct">
            <xsl:value-of select="." />
        </p>
    </xsl:template>

<xsl:template match="data">
    <html>
        <head>
            <script type="text/javascript" src="{/page/root}/js/jquery.js"></script>
            <link rel="stylesheet" type="text/css" href="{/page/root}/css/adm/main.css" />
            <!--[if lte IE 7]><link rel="stylesheet" type="text/css" href="/css/adm/ie.css"><![endif]-->
            <title>Система управления сайтом</title>
            <link rel="icon" type="image/png" href="/favicon.png"/>
        </head>

        <body class="hidemenu">
            <div class="page">
                <div class="header">

                    <a href="../../" id="logo"><h1>CMS</h1></a>
                    <div class="main"></div>
                </div>

                <div class="wrap">
                    <div class="content">
                        <div class="lining center">
                            <form action="{/page/root}/admin/login/" method="POST" class="login">
                                <input type="hidden" name="act" value="login"/>
                                <table class="type-1">
                                    <tr>
                                        <td colspan="2"><h2><img src="{/page/root}/i/adm/login.png" width="17" height="24" alt="" />Вход для администратора</h2></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <xsl:apply-templates select="error[@type='email']" />
                                            <xsl:apply-templates select="error[@type='password']" />
                                            <input type="text" name="email" class="txt f247" value="{email}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input type="password" name="pass" class="txt f247"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="l85">
                                            <input type="submit" value="Войти" class="btn" />
                                        </td>
                                    </tr>
                                </table>

                            </form>
                        </div>
                    </div>
                </div>

            </div>
            <div class="footer">
                <p class="copy">© Profit Wizard, 2011</p>
            </div>

        </body>
    </html>
</xsl:template>

</xsl:stylesheet>