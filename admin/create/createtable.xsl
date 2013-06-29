<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="utf-8"/>

<xsl:template match="table|joined" mode="sequence">
    INSERT IGNORE INTO sequences (name, id) VALUES ('<xsl:value-of select="@name"/>', '0');</xsl:template>

<xsl:template match="col" name="base_col" mode="base">
    <xsl:apply-templates select="@name"/><xsl:text> </xsl:text>
	<xsl:choose>
		<xsl:when test="@datatype">
			<xsl:value-of select="@datatype"/>
		</xsl:when>
		<xsl:when test="ref/@type='text'">
			<xsl:apply-templates select="/config/coltypes_indirect/option[@value=1]"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="/config/coltypes_indirect/option[@value=current()/@type]"/>
		</xsl:otherwise>
	</xsl:choose>
    <xsl:if test="@primary='y' or @not_null = 'y'"> NOT NULL</xsl:if>
    <xsl:if test="@default"> DEFAULT <xsl:value-of select="@default" /></xsl:if>
</xsl:template>

<xsl:template match="col" mode="name">
    <xsl:call-template name="base_col" />
    <xsl:value-of select="/config/coltypes_indirect/option[@value=current()/@type]/@parent_table_option" />
	<xsl:if test="position() != last()">,
        </xsl:if>
</xsl:template>

<xsl:template match="col" mode="primary">
	<xsl:apply-templates select="@name"/><xsl:if test="position() != last()">, </xsl:if>
</xsl:template>

<xsl:template match="table" mode="create">
	DROP TABLE IF EXISTS <xsl:apply-templates select="@name"/>;
	CREATE TABLE <xsl:apply-templates select="@name"/> (
        <xsl:if test="@multisite='y'">SITE_ID int(12) unsigned, </xsl:if>
        <xsl:apply-templates select="col[not(@bitfield = 'y')]" mode="name"/>
        <xsl:if test="col/@primary">,
        PRIMARY KEY(<xsl:if test="@multisite='y'">SITE_ID, </xsl:if><xsl:apply-templates select="col[@primary]" mode="primary"/>)</xsl:if>
    )<xsl:if test="@engine"> Engine=<xsl:value-of select="@engine"/></xsl:if>;
</xsl:template>

<xsl:template match="table/joined" mode="create">
	DROP TABLE IF EXISTS <xsl:apply-templates select="@name"/>;
	CREATE TABLE <xsl:apply-templates select="@name"/> (
	    <xsl:apply-templates select="../col[@primary]" mode="base"/>,
	    <xsl:apply-templates select="col" mode="name"/>,
        PRIMARY KEY(<xsl:apply-templates select="../col[@primary] | col[@primary]" mode="primary"/>)
    );
</xsl:template>

<xsl:template match="col" mode="indexname">
	<xsl:apply-templates select="@name"/><xsl:if test="position() != last()">, </xsl:if>
</xsl:template>

<!-- xsl:template match="index"><xsl:value-of select="."/><xsl:if test="position()!=last()">_</xsl:if></xsl:template -->
<xsl:key name="table_index" match="col" use="concat(../@name, index)"/>

<xsl:template match="table|joined" mode="index">
	<xsl:for-each select="col[count(. | key('table_index', concat(../@name, index))[1])=1]">
		<xsl:if test="index">CREATE <xsl:choose><xsl:when test="index/@unique|following-sibling::col[index=current()/index]/index/@unique">UNIQUE</xsl:when><xsl:when test="index/@fulltext|following-sibling::col[index=current()/index]/index/@fulltext">FULLTEXT</xsl:when></xsl:choose> INDEX idx_<xsl:apply-templates select="../@name"/>_<xsl:value-of select="index[.=current()/index]"/> ON <xsl:apply-templates select="../@name"/> (<xsl:if test="../@multisite='y'">SITE_ID, </xsl:if><xsl:apply-templates select=".|following-sibling::col[index=current()/index]" mode="indexname"><xsl:sort select="index[.=current()/index]/@order"/></xsl:apply-templates>);
	</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template match="table" mode="type" xml:space="preserve"><xsl:if test="@type">INSERT INTO cmf_xmls_article (type, article, edit) VALUES (<xsl:value-of select="@type"/>, '<xsl:choose><xsl:when test="@article"><xsl:value-of select="@article"/></xsl:when><xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise></xsl:choose>', '<xsl:value-of select="@name"/>.php?e=ED&amp;id=%id%<xsl:if test="@parentscript">&amp;pid=%pid%</xsl:if><xsl:if test="@pagesize">&amp;p=%p%</xsl:if><xsl:if test="@letter">&amp;l=%l%</xsl:if><xsl:if test="@treechild">&amp;r=%r%</xsl:if>');
	-- <xsl:value-of select="@type"/> -- <xsl:value-of select="@name"/>
</xsl:if></xsl:template>

<xsl:template match="table" mode="foreign_key">
    <xsl:for-each select="col[ref]">
    ALTER TABLE <xsl:value-of select="../@name" />
        ADD FOREIGN KEY (<xsl:value-of select="@name" />)
        REFERENCES <xsl:value-of select="ref/table" /> (<xsl:value-of select="ref/field" />);
    </xsl:for-each>
</xsl:template>

<xsl:template match="table/joined" mode="foreign_key">
    ALTER TABLE <xsl:value-of select="@name" />
        ADD FOREIGN KEY (<xsl:value-of select="../col[@primary]/@name" />)
        REFERENCES <xsl:value-of select="../@name" /> (<xsl:value-of select="../col[@primary]/@name" />);
    <xsl:for-each select="col[ref]">
    ALTER TABLE <xsl:value-of select="../@name" />
        ADD FOREIGN KEY (<xsl:value-of select="@name" />)
        REFERENCES <xsl:value-of select="ref/table" /> (<xsl:value-of select="ref/field" />);
    </xsl:for-each>
</xsl:template>

<xsl:template match="config">
	USE <xsl:value-of select="/config/basename"/>;
        SET OPTION CHARACTER SET utf8;
	<!-- create sequence SEQ_<xsl:value-of select="table/@name"/> start with 1 increment by 1 nominvalue nomaxvalue nocycle nocache; -->
	<xsl:apply-templates select="table" mode="create"/>
	<xsl:apply-templates select="table/joined" mode="create"/>
	--
	<xsl:apply-templates select="table" mode="index"/>
	<xsl:apply-templates select="table/joined" mode="index"/>

    <!--
    <xsl:apply-templates select="table" mode="foreign_key"/>
    <xsl:apply-templates select="table/joined" mode="foreign_key"/>
    -->

	<xsl:apply-templates select="table" mode="type"><xsl:sort select="@type"/></xsl:apply-templates>

INSERT INTO `user` VALUES (1,'admin@gmail.com','be72a100181ad94db88a33434b1a1194',NULL,'Rootov','Root',NULL,NULL);

INSERT INTO `cmf_role` VALUES (1,'СуперАдмин','СуперАдмин','/admin/&id=2');
INSERT INTO `cmf_user_role_link` VALUES (1,1,1);
INSERT INTO `module` VALUES (1,'Все ( для суперадмина )');
INSERT INTO `cmf_role_module_link` VALUES (1,1,1,1);

INSERT INTO `module_scripts` VALUES (1,1);
INSERT INTO `module_scripts` VALUES (1,2);
INSERT INTO `module_scripts` VALUES (1,3);
INSERT INTO `module_scripts` VALUES (1,4);
INSERT INTO `module_scripts` VALUES (1,5);
INSERT INTO `module_scripts` VALUES (1,6);
INSERT INTO `module_scripts` VALUES (1,7);
INSERT INTO `module_scripts` VALUES (1,8);
INSERT INTO `module_scripts` VALUES (1,9);
INSERT INTO `module_scripts` VALUES (1,10);
INSERT INTO `module_scripts` VALUES (1,11);
INSERT INTO `module_scripts` VALUES (1,13);
INSERT INTO `module_scripts` VALUES (1,14);
INSERT INTO `module_scripts` VALUES (1,15);
INSERT INTO `module_scripts` VALUES (1,16);
INSERT INTO `module_scripts` VALUES (1,17);
INSERT INTO `module_scripts` VALUES (1,18);

INSERT INTO `cmf_script` VALUES (1,0,'INDEX','Главный скрипт','index.php','',NULL,NULL,NULL,NULL,0,1,1,1,0);
INSERT INTO `cmf_script` VALUES (2,1,'ADMIN','Админ','','',NULL,NULL,NULL,NULL,0,1,1,1,0);
INSERT INTO `cmf_script` VALUES (3,2,'SYSTEM','Системные функции','','',NULL,NULL,'3.gif#28#26','#336699',0,1,1,1,0);
INSERT INTO `cmf_script` VALUES (4,2,'RIGHTS','Управление правами','','',NULL,NULL,'4.gif#28#26','#70B1E4',0,1,1,1,0);
INSERT INTO `cmf_script` VALUES (5,3,'CmfScript','Скрипты','/admin/CmfScript/','Управление Админским меню',NULL,NULL,NULL,NULL,0,1,1,2,1);
INSERT INTO `cmf_script` VALUES (6,3,'MYSQLEDITOR','Mysql Editor','/admin/sql/','Редактор MySQL для ручного управления базой',NULL,NULL,'',NULL,0,1,1,4,1);
INSERT INTO `cmf_script` VALUES (7,3,'cmf_xmls_article','Типы для XML редактора','cmf_xmls_article.php','',NULL,NULL,'','',0,1,1,5,1);
INSERT INTO `cmf_script` VALUES (8,3,'cmf_bug','Отчет о багах','cmf_bug.php','',NULL,NULL,NULL,NULL,0,0,0,6,1);
INSERT INTO `cmf_script` VALUES (9,4,'User','Пользователи системы','/admin/user/','Удаление и добавление пользователей системы',NULL,'Пользователь','',NULL,0,1,1,1,0);
INSERT INTO `cmf_script` VALUES (10,4,'CmfRole','Роли','/admin/CmfRole/','Управление ролями',NULL,NULL,'',NULL,0,1,1,2,1);
INSERT INTO `cmf_script` VALUES (11,4,'module','Модули','/admin/module/','Модули',NULL,NULL,'','',0,1,1,2,1);
INSERT INTO `cmf_script` VALUES (13,1,'fdg','РЕДАКТОР','','',NULL,NULL,'','',0,1,1,3,0);
INSERT INTO `cmf_script` VALUES (14,13,'for','Сайт','','',NULL,NULL,'12.gif#30#26','#339900',0,1,1,1,0);
INSERT INTO `cmf_script` VALUES (15,13,'for','Справочники','','',NULL,NULL,'','#339900',0,1,1,1,1);
INSERT INTO `cmf_script` VALUES (16,14,'another_pages','Страницы сайта','another_pages.php','',NULL,NULL,'','',0,1,1,1,1);
INSERT INTO `cmf_script` VALUES (17,14,'EDITER','Редактор XML','EDITER.php','',NULL,NULL,'','',0,1,1,2,1);
INSERT INTO `cmf_script` VALUES (18,9,'CmfURole','Роли пользователя','/admin/CmfURole/',NULL,NULL,NULL,'',NULL,0,1,1,1,1);

    <!--
	<xsl:apply-templates select="table" mode="sequence"/>
	<xsl:apply-templates select="table/joined" mode="sequence"/>
    -->

</xsl:template>


</xsl:stylesheet>