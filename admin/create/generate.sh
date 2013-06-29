#!/bin/bash

echo "create.sql"
xsltproc createtable.xsl config.xml > create.sql 
echo "tmpcontr.tpl"
xsltproc tools/_script.xsl config.xml > tmpcontr.tpl
echo "tmpcontr_ch.tpl"
xsltproc tools/_childscript.xsl config.xml > tmpcontr_ch.tpl
echo "tmpcontr_tr.tpl"
xsltproc tools/_treescript.xsl config.xml > tmpcontr_tr.tpl
echo "tmpcontr.tpl"
xsltproc createEntity.xsl config.xml > tmp.tpl
rm -r src
rm -r models
mkdir src
mkdir src/admin
mkdir models
mkdir models/entity
php spliter.php
php spliterc.php
iconv -f cp1251 -t utf-8 create.sql > create_utf8.sql
