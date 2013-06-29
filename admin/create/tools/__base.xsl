<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="utf-8"/>

<xsl:strip-space elements="panel"/>

<xsl:template match="panel" mode="edit" xml:space="preserve">
<tr bgcolor="#FFFFFF"><td></td><td>
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr><td><button class="buttt" unselectable="On" onclick="document.execCommand('Cut');" title="Вырезать"><img src="i/e/cut.gif"/></button></td>
<td><button class="buttt" unselectable="On" onclick="document.execCommand('Copy');" title="Скопировать"><img src="i/e/copy.gif"/></button></td>
<td><button class="buttt" unselectable="On" onclick="document.execCommand('Paste')" title="Вставить"><img src="i/e/paste.gif"/></button></td>
<td><button class="buttt" unselectable="On" onclick="document.execCommand('Undo')" title="Отменить"><img src="i/e/back.gif"/></button></td>
<td>&#160;&#160;</td>
<td><button class="buttt" unselectable="On" onclick="return command('p','');" title="Абзац"><B>&#160;P&#160;</B></button></td>
<td><button class="buttt" unselectable="On" onclick="return commandone('br');" title="Перенос"><img src="i/e/br.gif"/></button>&#160;</td>
<td>&#160;&#160;</td>
<td><button class="buttt" unselectable="On" onclick="return command('p',' align=&quot;right&quot;');" title="Вправо"><img src="i/e/rt.gif"/></button></td>
<td><button class="buttt" unselectable="On" onclick="return command('p',' align=&quot;center&quot;');" title="По центру"><img src="i/e/center.gif"/></button></td>
<td>&#160;&#160;&#160;</td>
<td><button class="buttt" unselectable="On" onclick="return ins_ol_ul('ol');" title="Список числовой"><img src="i/e/ol.gif"/></button></td>
<td><button class="buttt" unselectable="On" onclick="return ins_ol_ul('ul');" title="Список"><img src="i/e/ul.gif"/></button></td>
<td>&#160;&#160;</td>
<td><button class="buttt" unselectable="On" onclick="return tabler();" title="По центру"><img src="i/e/table.gif"/></button></td>
<td>&#160;&#160;&#160;</td>
<td><button class="buttt" unselectable="On" onclick="return command('b','');" title="Bold"><B>&#160;Ж&#160;</B></button></td>
<td><button class="buttt" unselectable="On" onclick="return command('i','');" title="Italic"><B><I>&#160;К&#160;</I></B></button></td>
<td><button class="buttt" unselectable="On" onclick="return command('u','');" title="Underline"><B>&#160;<U>Ч</U>&#160;</B></button></td>
<td>&#160;</td>
<td><button class="buttt" unselectable="On" onclick="return command('sup','');" title="Верхний индекс"><B>&#160;^&#160;</B></button></td>
<td><button class="buttt" unselectable="On" onclick="return command('sub','');" title="Нижний индекс"><B>&#160;_&#160;</B></button></td>
<td>&#160;&#160;</td>
<td><button class="buttt" unselectable="On" onclick="return _link();" title="Ссылка"><img src="i/e/link.gif"/></button></td>
<td><button class="buttt" unselectable="On" onclick='return _style();' title="Стили"><B>Стили</B></button></td>
</tr></table>
</td></tr>
</xsl:template>

<xsl:template match="pseudocol" mode="edit" xml:space="preserve"><xsl:if test="ifsection">
EOF;
<xsl:value-of select="ifsection" disable-output-escaping="yes"/>{
print @<xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
</xsl:if><tr bgcolor="#FFFFFF"><th width="1%"><b><xsl:apply-templates select="name"/>:<br/><img src="img/hi.gif" width="125" height="1"/></b></th><td width="100%"><xsl:value-of select="data" disable-output-escaping="yes"/></td></tr><xsl:if test="ifsection">
EOF;
};
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
</xsl:if></xsl:template>

<xsl:template match="pseudocol[@fullrow]" mode="edit" xml:space="preserve"><xsl:if test="ifsection">
EOF;
<xsl:value-of select="ifsection" disable-output-escaping="yes"/>{
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
</xsl:if><xsl:value-of select="data" disable-output-escaping="yes"/><xsl:if test="ifsection">
EOF;
};
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF</xsl:if></xsl:template>

<xsl:template match="extrakey"><input type="submit" name="{name}" value="{comment}" class="gbut" unselectable="on"><xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if></input>
</xsl:template>

<xsl:template match="extrakey[@src]"><input type="image" name="{name}" src="{@src}" border="0" alt="{comment}" title="{comment}" hspace="4" class="gbut"/>
</xsl:template>

<xsl:template match="child_script"><a href="{@name}.php?pid=$V_{../col[@primary='y']/@name}"><img src="{@image}" border="0" title="{@title}"/></a>
</xsl:template>

<xsl:template match="col" mode="head"><th><xsl:apply-templates select="name"/></th></xsl:template>

<xsl:template match="col" mode="formvalid"><xsl:if test="ifsection">
EOF;
<xsl:value-of select="ifsection" disable-output-escaping="yes"/>{ print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
</xsl:if><xsl:if test="not(@internal) and not(@novalid='y')">
<xsl:choose>
<xsl:when test="@type=1"><xsl:text disable-output-escaping="yes"> &amp;&amp; </xsl:text>checkXML(<xsl:value-of select="@name"/>)</xsl:when>
<xsl:when test="@type=2"><xsl:text disable-output-escaping="yes"> &amp;&amp; </xsl:text>checkXML(<xsl:value-of select="@name"/>)</xsl:when>
<xsl:when test="@type=5"><xsl:text disable-output-escaping="yes"> &amp;&amp; </xsl:text>checkEmail(<xsl:value-of select="@name"/>)</xsl:when>
</xsl:choose></xsl:if><xsl:if test="ifsection">
EOF;
};
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
</xsl:if>
</xsl:template>

<xsl:template match="col" mode="name"><xsl:choose><xsl:when test="@type=12">DATE_FORMAT(<xsl:apply-templates select="@name"/>,"%Y-%m-%d %h:%i")</xsl:when><xsl:otherwise><xsl:apply-templates select="@name"/></xsl:otherwise></xsl:choose><xsl:if test="position() != last()">,</xsl:if></xsl:template>
<xsl:template match="col" mode="aname"><xsl:choose><xsl:when test="@visualityname"><xsl:value-of select="@visualityname" disable-output-escaping="yes"/></xsl:when><xsl:when test="@type=12">DATE_FORMAT(A.<xsl:apply-templates select="@name"/>,"%Y-%m-%d %h:%i")</xsl:when><xsl:otherwise>A.<xsl:apply-templates select="@name"/></xsl:otherwise></xsl:choose><xsl:if test="position() != last()">,</xsl:if></xsl:template>
<xsl:template match="calccol" mode="aname"><xsl:value-of select="@name"/><xsl:if test="position() != last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="name_insert"><xsl:apply-templates select="@name"/><xsl:if test="position() != last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="update"><xsl:apply-templates select="@name"/>=<xsl:choose><xsl:when test="@type=12">?</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose><xsl:if test="position() != last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="vars">$V_<xsl:apply-templates select="@name"/><xsl:if test="position() != last()">,</xsl:if></xsl:template>
<xsl:template match="calccol" mode="vars">$V_<xsl:value-of select="@variable"/><xsl:if test="position() != last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="vars_init"><xsl:choose><xsl:when test="@default"><xsl:value-of select="@default"/></xsl:when><xsl:otherwise>''</xsl:otherwise></xsl:choose><xsl:if test="position() != last()">,</xsl:if></xsl:template>


<xsl:template match="col[(@type=1 or @type=2) and not(@noxmlcorrect)]" mode="form">$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Velform($_REQUEST['<xsl:choose><xsl:when test="@parent='y'">pid</xsl:when><xsl:otherwise><xsl:apply-templates select="@name"/></xsl:otherwise></xsl:choose>'])<xsl:if test="position() != last()">,</xsl:if></xsl:template>
<xsl:template match="col" mode="form">$_REQUEST['<xsl:choose><xsl:when test="@parent='y'">pid</xsl:when><xsl:otherwise><xsl:apply-templates select="@name"/></xsl:otherwise></xsl:choose>']<xsl:if test="@type=3 or @type=4 or @type=6">+0</xsl:if><xsl:if test="position() != last()">,</xsl:if></xsl:template>
<xsl:template match="col[@internal='y']" mode="form"><xsl:choose><xsl:when test="@type=3 or @type=4 or @type=6">0</xsl:when><xsl:otherwise>''</xsl:otherwise></xsl:choose><xsl:if test="position() != last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="insert">
$sth-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>bind_param(<xsl:value-of select="position()"/>,$_REQUEST['<xsl:apply-templates select="@name"/>']);</xsl:template>

<xsl:template match="col" mode="vopros"><xsl:choose><xsl:when test="@type=12">?</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose><xsl:if test="position() != last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="number">:<xsl:value-of select="position()"/><xsl:if test="position() != last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="forminput">$_REQUEST['<xsl:choose><xsl:when test="@parent='y'">pid</xsl:when><xsl:otherwise><xsl:apply-templates select="@name"/></xsl:otherwise></xsl:choose>_'.$id]<xsl:if test="position() != last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="varsprint"><td><xsl:choose><xsl:when test="@input='y'"><input onchange="ch(this)" type="text" name="{@name}_$V_{../col[@primary='y' and not(@parent)]/@name}" class="i"><xsl:attribute name="value">$V_<xsl:apply-templates select="@name"/></xsl:attribute><xsl:attribute name="tabindex">$TABposition</xsl:attribute></input></xsl:when><xsl:otherwise>$V_<xsl:apply-templates select="@name"/><xsl:if test="@primary='y' and (@type=6 or @type=13)">_STR</xsl:if></xsl:otherwise></xsl:choose></td></xsl:template>
<!-- xsl:template match="col" mode="varsprint"><td>$V_<xsl:apply-templates select="@name"/><xsl:if test="@primary='y' and (@type=6 or @type=13)">_STR</xsl:if></td></xsl:template -->
<xsl:template match="col[@child]" mode="varsprint"><td><a href="{@child}.php?pid=$V_{../col[@primary='y']/@name}" class="b">$V_<xsl:apply-templates select="@name"/><xsl:if test="@primary='y' and (@type=6 or @type=13)">_STR</xsl:if></a></td></xsl:template>

<xsl:template match="type"><input type="submit" name="event" onclick="this.form.type.value='{@id}';this.form.action='EDITER.php';" value="&#160;&#160;{text()}" class="gbt bxml"/>&#160;&#160;</xsl:template>

<xsl:template match="calccol" mode="varsprint">
<td>
EOF;
<xsl:value-of select="data" disable-output-escaping="yes"/>
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
</td>
</xsl:template>

<xsl:template match="enum/option"><xsl:if test="@value"><xsl:value-of select="@value" /> =<xsl:text disable-output-escaping="yes">&gt;</xsl:text> </xsl:if>'<xsl:apply-templates/>'<xsl:if test="position()!=last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="enumcreate" xml:space="preserve">
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>ENUM_<xsl:value-of select="@name"/>=array(<xsl:apply-templates select="enum/option"/>);
</xsl:template>

<xsl:template match="col|calccol" mode="sortnames">'<xsl:value-of select="name"/>'<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
<xsl:template match="col" mode="sortquerys">'order by <xsl:choose><xsl:when test="@sortasc"><xsl:value-of select="@sortasc"/></xsl:when><xsl:otherwise>A.<xsl:value-of select="@name"/></xsl:otherwise></xsl:choose> ','order by <xsl:choose><xsl:when test="@sortdesc"><xsl:value-of select="@sortdesc"/></xsl:when><xsl:otherwise>A.<xsl:value-of select="@name"/></xsl:otherwise></xsl:choose> desc '<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
<xsl:template match="calccol" mode="sortquerys">'<xsl:choose><xsl:when test="@sortasc">order by <xsl:value-of select="@sortasc" disable-output-escaping="yes"/><xsl:text> </xsl:text></xsl:when><xsl:when test="@name">order by <xsl:value-of select="@name"/><xsl:text> </xsl:text></xsl:when></xsl:choose>','<xsl:choose><xsl:when test="@sortdesc">order by <xsl:value-of select="@sortdesc" disable-output-escaping="yes"/> desc<xsl:text> </xsl:text></xsl:when><xsl:when test="@name">order by <xsl:value-of select="@name"/> desc<xsl:text> </xsl:text></xsl:when></xsl:choose>'<xsl:if test="position()!=last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="previsible">
<xsl:choose>
<xsl:when test="@type=6">
<xsl:choose>
        <xsl:when test="@primary='y'">
$V_<xsl:apply-templates select="@name"/>_STR=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_arrayQ('SELECT <xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/> WHERE <xsl:apply-templates select="ref/field"/>=?',$V_<xsl:apply-templates select="@name"/>);
        </xsl:when>
        <xsl:otherwise>
$V_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_arrayQ('SELECT <xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/> WHERE <xsl:apply-templates select="ref/field"/>=?',$V_<xsl:apply-templates select="@name"/>);
        </xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="@type=7">
$IM_<xsl:value-of select="position()"/>=split('#',$V_<xsl:apply-templates select="@name"/>);
if(isset($IM_<xsl:value-of select="position()"/>[1]) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> $IM_<xsl:value-of select="position()"/>[1] <xsl:text disable-output-escaping="yes">&gt;</xsl:text> 150){$IM_<xsl:value-of select="position()"/>[2]=$IM_<xsl:value-of select="position()"/>[2]*150/$IM_<xsl:value-of select="position()"/>[1]; $IM_<xsl:value-of select="position()"/>[1]=150;}
$V_<xsl:apply-templates select="@name"/>=@"<xsl:text disable-output-escaping="yes">&lt;</xsl:text>img src='/images{$VIRTUAL_IMAGE_PATH}{$IM_<xsl:value-of select="position()"/>[0]}' width='{$IM_<xsl:value-of select="position()"/>[1]}' height='{$IM_<xsl:value-of select="position()"/>[2]}'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>";
</xsl:when>
<xsl:when test="@type=13">
<xsl:choose>
        <xsl:when test="@primary='y'">
($V_<xsl:apply-templates select="@name"/>_STR)=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>GetTreePath('SELECT parent_id,<xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/> WHERE <xsl:apply-templates select="ref/field"/>=?',$V_<xsl:apply-templates select="@name"/>);
        </xsl:when>
        <xsl:otherwise>
$V_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_arrayQ('SELECT <xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/> WHERE <xsl:apply-templates select="ref/field"/>=?',$V_<xsl:apply-templates select="@name"/>);
        </xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="@type=8">
if(!$V_<xsl:apply-templates select="@name"/>) {$V_<xsl:apply-templates select="@name"/>='Нет';} else {$V_<xsl:apply-templates select="@name"/>='Да';}
</xsl:when>
<xsl:when test="@type=10">
$V_<xsl:value-of select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>ENUM_<xsl:value-of select="@name"/>[$V_<xsl:value-of select="@name"/>];
</xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template match="col" mode="preedit">
<xsl:choose>
<xsl:when test="@type=6">
<xsl:choose>
<xsl:when test="@popup='y'">
$V_STR_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_arrayQ('SELECT <xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/> WHERE <xsl:apply-templates select="ref/field"/>=?<xsl:value-of select="ref/where" disable-output-escaping="yes"/> ',$V_<xsl:apply-templates select="@name"/><xsl:value-of select="ref/attributes" disable-output-escaping="yes"/>);
</xsl:when>
<xsl:otherwise>
$V_STR_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Spravotchnik($V_<xsl:apply-templates select="@name"/>,'SELECT <xsl:apply-templates select="ref/field"/>,<xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/><xsl:text> </xsl:text><xsl:value-of select="ref/where" disable-output-escaping="yes"/> order by <xsl:choose><xsl:when test="ref/order"><xsl:apply-templates select="ref/order"/></xsl:when><xsl:otherwise><xsl:apply-templates select="ref/visual"/></xsl:otherwise></xsl:choose>'<xsl:value-of select="ref/attributes" disable-output-escaping="yes"/>);
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="@type=13">
$V_STR_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>TreeSpravotchnik($V_<xsl:apply-templates select="@name"/>,'SELECT <xsl:apply-templates select="ref/field"/>,<xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/><xsl:text> </xsl:text>WHERE parent_id=?<xsl:value-of select="ref/where" disable-output-escaping="yes"/> order by <xsl:choose><xsl:when test="ref/order"><xsl:apply-templates select="ref/order"/></xsl:when><xsl:otherwise><xsl:apply-templates select="ref/visual"/></xsl:otherwise></xsl:choose>',0);</xsl:when>
<xsl:when test="@type=7">
$IM_<xsl:value-of select="@name"/>=split('#',$V_<xsl:value-of select="@name"/>);
if(isset($IM_<xsl:value-of select="position()"/>[1]) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> $IM_<xsl:value-of select="@name"/>[1] <xsl:text disable-output-escaping="yes">&gt;</xsl:text> 150){$IM_<xsl:value-of select="@name"/>[2]=$IM_<xsl:value-of select="@name"/>[2]*150/$IM_<xsl:value-of select="@name"/>[1]; $IM_<xsl:value-of select="@name"/>[1]=150;}</xsl:when>
<xsl:when test="@type=8">
$V_<xsl:apply-templates select="@name"/>=$V_<xsl:apply-templates select="@name"/>?'checked':'';</xsl:when>
<xsl:when test="@type=10">
$V_STR_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Enumerator($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>ENUM_<xsl:value-of select="@name"/>,$V_<xsl:apply-templates select="@name"/>);</xsl:when>
<xsl:when test="@type=14">
$IM_<xsl:value-of select="@name"/>=split('#',$V_<xsl:value-of select="@name"/>);</xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template match="col" mode="preadd">
<xsl:choose>
<xsl:when test="@type=6">
<xsl:choose>
<xsl:when test="@popup='y'">
$V_STR_<xsl:apply-templates select="@name"/>='';
</xsl:when>
<xsl:otherwise>
$V_STR_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Spravotchnik($V_<xsl:apply-templates select="@name"/>,'SELECT <xsl:apply-templates select="ref/field"/>,<xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/><xsl:text> </xsl:text><xsl:value-of select="ref/where" disable-output-escaping="yes"/> order by <xsl:choose><xsl:when test="ref/order"><xsl:apply-templates select="ref/order"/></xsl:when><xsl:otherwise><xsl:apply-templates select="ref/visual"/></xsl:otherwise></xsl:choose>'<xsl:value-of select="ref/attributes" disable-output-escaping="yes"/>);
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="@type=13">
$V_STR_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>TreeSpravotchnik($V_<xsl:apply-templates select="@name"/>,'SELECT <xsl:apply-templates select="ref/field"/>,<xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/><xsl:text> </xsl:text>WHERE parent_id=?<xsl:value-of select="ref/where" disable-output-escaping="yes"/> order by <xsl:choose><xsl:when test="ref/order"><xsl:apply-templates select="ref/order"/></xsl:when><xsl:otherwise><xsl:apply-templates select="ref/visual"/></xsl:otherwise></xsl:choose>',0);</xsl:when>
<xsl:when test="@type=7">
$IM_<xsl:value-of select="@name"/>=array('','','');<!-- split('#',$V_<xsl:value-of select="@name"/>); --></xsl:when>
<xsl:when test="@type=8">
$V_<xsl:apply-templates select="@name"/>='<xsl:if test="@default=1">checked</xsl:if>';</xsl:when>
<xsl:when test="@type=10">
$V_STR_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Enumerator($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>ENUM_<xsl:value-of select="@name"/>,-1<!-- $V_<xsl:apply-templates select="@name"/> -->);</xsl:when>
<xsl:when test="@type=12">
$V_<xsl:apply-templates select="@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT now()');</xsl:when>
<xsl:when test="@type=14">
$IM_<xsl:value-of select="@name"/>=split('#',$V_<xsl:value-of select="@name"/>);</xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template match="col" mode="preinsert" xml:space="preserve"><xsl:choose>
<xsl:when test="@type=7">$_REQUEST['<xsl:apply-templates select="@name"/>']=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>PicturePost('NOT_<xsl:apply-templates select="@name"/>',$_REQUEST['<xsl:apply-templates select="@name"/>'],'<xsl:value-of select="@prefix"/>'.$_REQUEST['id']<xsl:if test="name(..)='joined'">.'_'.$_REQUEST['iid']</xsl:if>.'<xsl:value-of select="@postfix"/>',$VIRTUAL_IMAGE_PATH<xsl:if test="@dir">.'<xsl:value-of select="@dir"/>'</xsl:if>);
if(isset($_REQUEST['CLR_<xsl:apply-templates select="@name"/>']) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> $_REQUEST['CLR_<xsl:apply-templates select="@name"/>']){$_REQUEST['<xsl:apply-templates select="@name"/>']=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>UnlinkFile($_REQUEST['<xsl:apply-templates select="@name"/>'],$VIRTUAL_IMAGE_PATH);}
</xsl:when>
<xsl:when test="@type=8">$_REQUEST['<xsl:apply-templates select="@name"/>']=isset($_REQUEST['<xsl:apply-templates select="@name"/>']) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> $_REQUEST['<xsl:apply-templates select="@name"/>']?1:0;</xsl:when>
<xsl:when test="@type=14">$_REQUEST['<xsl:apply-templates select="@name"/>']=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>FilePost('NOT_<xsl:apply-templates select="@name"/>',$_REQUEST['<xsl:apply-templates select="@name"/>'],'<xsl:value-of select="@prefix"/>'.$_REQUEST['id']<xsl:if test="name(..)='joined'">.'_'.$_REQUEST['iid']</xsl:if>.'<xsl:value-of select="@postfix"/>',$VIRTUAL_IMAGE_PATH<xsl:if test="@dir">.'<xsl:value-of select="@dir"/>'</xsl:if>);
if(isset($_REQUEST['CLR_<xsl:apply-templates select="@name"/>']) <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> $_REQUEST['CLR_<xsl:apply-templates select="@name"/>']){$_REQUEST['<xsl:apply-templates select="@name"/>']=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>UnlinkFile($_REQUEST['<xsl:apply-templates select="@name"/>'],$VIRTUAL_IMAGE_PATH<xsl:if test="@dir">.'<xsl:value-of select="@dir"/>'</xsl:if>);}
</xsl:when>
</xsl:choose></xsl:template>

<xsl:template match="col" mode="edit" xml:space="preserve"><xsl:if test="ifsection">
EOF;
<xsl:value-of select="ifsection" disable-output-escaping="yes"/>{
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
</xsl:if><tr bgcolor="#FFFFFF"><th width="1%"><b><xsl:apply-templates select="name"/>:<br/><img src="img/hi.gif" width="125" height="1"/></b></th><td width="100%"><xsl:choose>
<xsl:when test="@type=1"><input type="text" name="{@name}" value="$V_{@name}" size="{@size}"><xsl:if test="@panelize='y'"><xsl:attribute name="onfocus">_XDOC=this;</xsl:attribute><xsl:attribute name="onkeydown">_etaKey(event)</xsl:attribute></xsl:if></input><br/></xsl:when>
<xsl:when test="@type=2">
<xsl:choose>
<xsl:when test="@wysiwyg">
<!-- textarea name="{@name}" rows="{@rows}" cols="{@cols}">$V_<xsl:value-of select="@name"/></textarea -->
EOF;
include_once("../fckeditor/fckeditor.php") ;
$oFCKeditor = new FCKeditor('<xsl:value-of select="@name"/>') ;
$oFCKeditor-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Config['AutoDetectLanguage']=true;
$oFCKeditor-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Config['DefaultLanguage']='ru';
$oFCKeditor-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Value = htmlspecialchars_decode($V_<xsl:value-of select="@name"/>);
$oFCKeditor-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Height="<xsl:value-of select="16*number(@rows)"/>px";
$oFCKeditor-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>ToolbarSet="Basic";
$oFCKeditor-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Create() ;
<!-- $oFCKeditor-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>ReplaceTextarea(); -->
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
</xsl:when>
<xsl:otherwise>
<textarea name="{@name}" rows="{@rows}" cols="{@cols}"><xsl:if test="styles"><xsl:attribute name="style"><xsl:value-of select="styles"/></xsl:attribute></xsl:if><xsl:if test="@panelize='y'"><xsl:attribute name="onfocus">_XDOC=this;</xsl:attribute><xsl:attribute name="onkeydown">_etaKey(event)</xsl:attribute></xsl:if>$V_<xsl:value-of select="@name"/></textarea>
</xsl:otherwise>
</xsl:choose><br/></xsl:when>
<xsl:when test="@type=3"><input type="text" name="{@name}" value="$V_{@name}" size="{@size}"/><br/></xsl:when>
<xsl:when test="@type=4"><input type="text" name="{@name}" value="$V_{@name}" size="{@size}"/><br/></xsl:when>
<xsl:when test="@type=5"><input type="text" name="{@name}" value="$V_{@name}" size="{@size}"><xsl:if test="@panelize='y'"><xsl:attribute name="onfocus">_XDOC=this;</xsl:attribute><xsl:attribute name="onkeydown">_etaKey(event)</xsl:attribute></xsl:if></input><br/></xsl:when>
<xsl:when test="@type=6">
<xsl:choose>
<xsl:when test="@popup='y'">
<input type="hidden" name="{@name}" value="$V_{@name}"/><input type="text" name="v_{@name}" value="$V_STR_{@name}"/><input type="button" onclick="return DictPopUp('{ref/table}','{@name}');" value="&#187;"/><br/>
</xsl:when>
<xsl:otherwise>
<select name="{@name}"><xsl:if test="styles"><xsl:attribute name="style"><xsl:value-of select="styles"/></xsl:attribute></xsl:if><xsl:if test="onchange"><xsl:attribute name="onchange"><xsl:value-of select="onchange"/></xsl:attribute></xsl:if><xsl:if test="ref/none"><option value="0"><xsl:value-of select="ref/none"/></option></xsl:if>$V_STR_<xsl:value-of select="@name"/></select><br/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="@type=13"><select name="{@name}"><xsl:if test="ref/none"><option value="0"><xsl:value-of select="ref/none"/></option></xsl:if>$V_STR_<xsl:value-of select="@name"/></select><br/></xsl:when>
<xsl:when test="@type=7"><input type="hidden" name="{@name}" value="$V_{@name}"/>
<table><tr><td>
<img src="/images/$VIRTUAL_IMAGE_PATH/{@dir}$IM_{@name}[0]" width="$IM_{@name}[1]" height="$IM_{@name}[2]"/></td>
<td><input type="file" name="NOT_{@name}" size="1"/><br/>
<input type="checkbox" name="CLR_{@name}" value="1"/>Сбросить карт.
</td></tr></table></xsl:when>
<xsl:when test="@type=8"><xsl:text disable-output-escaping="yes">&lt;</xsl:text>input type='checkbox' name='<xsl:value-of select="@name"/>' value='1' $V_<xsl:value-of select="@name"/>/<xsl:text disable-output-escaping="yes">&gt;</xsl:text><br/></xsl:when>
<xsl:when test="@type=10"><select name="{@name}">$V_STR_<xsl:value-of select="@name"/></select><br/></xsl:when>
<xsl:when test="@type=12"><input type="text" name="{@name}" value="$V_{@name}"/><xsl:if test="@calendar">
        <img id="c_anc_{@name}" src="imgs/hi.gif" width="1" height="1" />
        <input type="image" src="i/c/cal.gif" width="34" class="button" onClick="return showCalendar(this,'{@name}');"/>
        <div id="c_div_{@name}" style="position:absolute;"></div>
</xsl:if>(YYYY-MM-DD)<br/></xsl:when>
<xsl:when test="@type=14"><input type="hidden" name="{@name}" value="$V_{@name}"/>
<table><tr><td><input type="file" name="NOT_{@name}" size="1"/><br/><input type="checkbox" name="CLR_{@name}" value="1"/>Сбросить файл.</td>
<td>&#160;</td><td>size=$IM_<xsl:value-of select="@name"/>[1]<br/>/images/$VIRTUAL_IMAGE_PATH$IM_<xsl:value-of select="@name"/>[0]
</td></tr></table></xsl:when>
</xsl:choose></td></tr><xsl:if test="ifsection">
EOF;
};
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
</xsl:if></xsl:template>

<xsl:template match="table/joined" mode="events" xml:space="preserve">
if(!isset($_REQUEST['e<xsl:value-of select="position()"/>']))$_REQUEST['e<xsl:value-of select="position()"/>']='';
if(!isset($_REQUEST['p']))$_REQUEST['p']='';

if(($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('e<xsl:value-of select="position()"/>') == 'Удалить') and is_array($_REQUEST['iid']))
{
foreach ($_REQUEST['iid'] as $id)
 {
<xsl:if test="col[@type=11]">
$ORDERING=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT <xsl:value-of select="col[@type=11]/@name"/> FROM <xsl:value-of select="@name"/> WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@primary='y']/@name"/>=?',$_REQUEST['id'],$id);
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>-1 WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@type=11]/@name"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>?',$_REQUEST['id'],$ORDERING);</xsl:if>
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('DELETE FROM <xsl:apply-templates select="@name"/> WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@primary='y']/@name"/>=?',$_REQUEST['id'],$id);
<xsl:value-of select="postdeleteevent" disable-output-escaping="yes"/>
 }
$_REQUEST['e']='ED';
$visible=0;
}

<xsl:if test="col/@type=11">
if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('e<xsl:value-of select="position()"/>') == 'UP')
{
$ORDERING=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT <xsl:value-of select="col[@type=11]/@name"/> FROM <xsl:value-of select="@name"/> WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@primary='y']/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
if($ORDERING<xsl:text disable-output-escaping="yes">&gt;</xsl:text>1)
{
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>+1 WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@type=11]/@name"/>=?',$_REQUEST['id'],$ORDERING-1);
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>-1 WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@primary='y']/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
}
$_REQUEST['e']='ED';
}

if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('e<xsl:value-of select="position()"/>') == 'DN')
{
$ORDERING=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT <xsl:value-of select="col[@type=11]/@name"/> FROM <xsl:value-of select="@name"/> WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@primary='y']/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
$MAXORDERING=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT max(<xsl:value-of select="col[@type=11]/@name"/>) FROM <xsl:value-of select="@name"/>');
if($ORDERING<xsl:text disable-output-escaping="yes">&lt;</xsl:text>$MAXORDERING)
{
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>-1 WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@type=11]/@name"/>=?',$_REQUEST['id'],$ORDERING+1);
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>+1 WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@primary='y']/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
}
$_REQUEST['e']='ED';
}
</xsl:if>


if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('e<xsl:value-of select="position()"/>') == 'Изменить')
{
<xsl:apply-templates select="col" mode="preinsert"/>
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:apply-templates select="col[@type!=11 and (not(@primary) or @editable='y')]" mode="update"><xsl:with-param name="off">2</xsl:with-param></xsl:apply-templates> WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@primary='y']/@name"/>=?',<xsl:apply-templates select="col[@type!=11 and (not(@primary) or @editable='y')]" mode="form"/>,$_REQUEST['id'],$_REQUEST['iid']);
<xsl:value-of select="postupdateevent" disable-output-escaping="yes"/>
$_REQUEST['e']='ED';
};


if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('e<xsl:value-of select="position()"/>') == 'Добавить')
{
<xsl:if test="col/@type=11">
$_REQUEST['<xsl:value-of select="col[@type=11]/@name"/>']=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT max(<xsl:value-of select="col[@type=11]/@name"/>) FROM <xsl:apply-templates select="@name"/> WHERE <xsl:apply-templates select="../col[@type=0]/@name"/>=?',$_REQUEST['id']);
$_REQUEST['<xsl:value-of select="col[@type=11]/@name"/>']++;
</xsl:if>
<xsl:choose>
<xsl:when test="col[@primary='y' and @editable='y']">
$_REQUEST['iid']=$_REQUEST['<xsl:value-of select="col[@primary='y' and @editable='y']/@name"/>'];
</xsl:when>
<xsl:otherwise>
$_REQUEST['iid']=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>GetSequence('<xsl:apply-templates select="@name"/>');
</xsl:otherwise>
</xsl:choose>
<xsl:value-of select="preinsertevent" disable-output-escaping="yes"/>
<xsl:apply-templates select="col" mode="preinsert"/>
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('INSERT INTO <xsl:apply-templates select="@name"/> (<xsl:apply-templates select="../col[@type=0]" mode="name_insert"/>,<xsl:apply-templates select="col" mode="name_insert"/>) values (<xsl:apply-templates select="../col[@type=0]|col" mode="vopros"/>)',$_REQUEST['id'],$_REQUEST['iid']<xsl:if test="col[not(@primary)]">,<xsl:apply-templates select="col[not(@primary)]" mode="form"/></xsl:if>);
$_REQUEST['e']='ED';
<xsl:value-of select="postinsertevent" disable-output-escaping="yes"/>
$visible=0;
}

if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('e<xsl:value-of select="position()"/>') == 'ED')
{
list (<xsl:apply-templates select="col[@type!=11]" mode="vars"/>)=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_arrayQ('SELECT <xsl:apply-templates select="col[@type!=11]" mode="name"/> FROM <xsl:value-of select="@name"/> WHERE <xsl:value-of select="../col[@primary='y']/@name"/>=? and <xsl:value-of select="col[@primary='y']/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
<xsl:value-of select="preeditevent" disable-output-escaping="yes"/>
<xsl:apply-templates select="col" mode="preedit"/>
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<h2 class="h2">Редактирование - <xsl:apply-templates select="name"/></h2>
<table bgcolor="#CCCCCC" border="0" cellpadding="5" cellspacing="1" style="width: 500px" class="f">
<form method="POST" action="{../@name}.php#f{position()}" ENCTYPE="multipart/form-data"><xsl:attribute name="onsubmit">return true <xsl:apply-templates select="col" mode="formvalid"/>;</xsl:attribute>
<input type="hidden" name="e" value="ED"/>
<input type="hidden" name="id"><xsl:attribute name="value">{$_REQUEST['id']}</xsl:attribute></input>
<xsl:if test="../@parentscript"><input type="hidden" name="pid"><xsl:attribute name="value">{$_REQUEST['pid']}</xsl:attribute></input></xsl:if>
<input type="hidden" name="iid"><xsl:attribute name="value">{$_REQUEST['iid']}</xsl:attribute></input>
<xsl:if test="@type"><input type="hidden" name="type" value="{@type}"/></xsl:if>
<xsl:if test="../@letter"><input type="hidden" name="l"><xsl:attribute name="value">{$_REQUEST['l']}</xsl:attribute></input></xsl:if>
<input type="hidden" name="p"><xsl:attribute name="value">{$_REQUEST['p']}</xsl:attribute></input>
<xsl:if test="@letter"><input type="hidden" name="l"><xsl:attribute name="value">{$_REQUEST['l']}</xsl:attribute></input></xsl:if>
<tr bgcolor="#F0F0F0" class="ftr"><td colspan="2">
<input type="submit" name="e{position()}" value="Изменить" class="gbt bsave"/>&#160;&#160;<xsl:if test="@type">
<input type="submit" name="e{position()}" onclick="this.form.action='EDITER.php';" value="&#160;&#160;Xml" class="gbt bxml"/>&#160;&#160;</xsl:if>
<input type="submit" name="e{position()}" value="Отменить" class="gbt bcancel"/>
</td></tr>
<xsl:apply-templates select="col[@type!=11 and (not(@primary) or @editable='y')]|panel|pseudocol" mode="edit"/>
<tr bgcolor="#F0F0F0" class="ftr"><td colspan="2">
<input type="submit" name="e{position()}" value="Изменить" class="gbt bsave"/>&#160;&#160;<xsl:if test="@type">
<input type="submit" name="e{position()}" onclick="this.form.action='EDITER.php';" value="&#160;&#160;Xml" class="gbt bxml"/>&#160;&#160;</xsl:if>
<input type="submit" name="e{position()}" value="Отменить" class="gbt bcancel"/>
</td></tr>
</form>
</table><br/>
EOF;
$visible=0;
}

if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('e<xsl:value-of select="position()"/>') == 'Новый')
{
list(<xsl:apply-templates select="col" mode="vars"/>)=array(<xsl:apply-templates select="col" mode="vars_init"/>);
<xsl:value-of select="preaddevent" disable-output-escaping="yes"/>
<xsl:apply-templates select="col" mode="preadd"/>
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<h2 class="h2">Добавление - <xsl:apply-templates select="name"/></h2>
<table bgcolor="#CCCCCC" border="0" cellpadding="5" cellspacing="1" style="width: 500px" class="f">
<form method="POST" action="{../@name}.php#f{position()}" ENCTYPE="multipart/form-data"><xsl:attribute name="onsubmit">return true <xsl:apply-templates select="col" mode="formvalid"/>;</xsl:attribute>
<input type="hidden" name="e" value="ED"/>
<input type="hidden" name="id"><xsl:attribute name="value">{$_REQUEST['id']}</xsl:attribute></input>
<xsl:if test="../@parentscript"><input type="hidden" name="pid"><xsl:attribute name="value">{$_REQUEST['pid']}</xsl:attribute></input></xsl:if>
<input type="hidden" name="p"><xsl:attribute name="value">{$_REQUEST['p']}</xsl:attribute></input>
<xsl:if test="../@letter"><input type="hidden" name="l"><xsl:attribute name="value">{$_REQUEST['l']}</xsl:attribute></input></xsl:if>
<tr bgcolor="#F0F0F0" class="ftr"><td colspan="2">
<input type="submit" name="e{position()}" value="Добавить" class="gbt badd"/>
<input type="submit" name="e{position()}" value="Отменить" class="gbt bcancel"/>
</td></tr>
<xsl:apply-templates select="col[@type!=11 and (not(@primary) or @editable='y')]|panel|pseudocol" mode="edit"/>
<tr bgcolor="#F0F0F0" class="ftr"><td colspan="2">
<input type="submit" name="e{position()}" value="Добавить" class="gbt badd"/>
<input type="submit" name="e{position()}" value="Отменить" class="gbt bcancel"/>
</td></tr>
</form>
</table>
EOF;
$visible=0;
}
</xsl:template>

<xsl:template match="table/joined" xml:space="preserve">
<xsl:variable name="p">&amp;id={$_REQUEST['id']}<xsl:if test="../@letter">&amp;l={$_REQUEST['l']}</xsl:if><xsl:if test="../@parentscript">&amp;pid={$_REQUEST['pid']}</xsl:if></xsl:variable>
<xsl:if test="ifsection"><xsl:value-of select="ifsection" disable-output-escaping="yes"/># Секция появляется только в случае выполнения условия
{</xsl:if>
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<a name="f{position()}"></a><h3 class="h3"><xsl:apply-templates select="name"/></h3>
EOF;

@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<table bgcolor="#CCCCCC" border="0" cellpadding="5" cellspacing="1" class="l">
<form action="{../@name}.php#f{position()}" method="POST">
<tr bgcolor="#F0F0F0"><td colspan="{count(col[@type!=11][@visuality='y'])+2}">
<input type="submit" name="e{position()}" value="Новый" class="gbt badd" /><img src="img/hi.gif" width="4" height="1"/><xsl:apply-templates select="extrakey"/>
<input type="submit" name="e{position()}" onclick="return dl();" value="Удалить" class="gbt bdel" />
<input type="hidden" name="id"><xsl:attribute name="value">{$_REQUEST['id']}</xsl:attribute></input>
<xsl:if test="../@parentscript"><input type="hidden" name="pid"><xsl:attribute name="value">{$_REQUEST['pid']}</xsl:attribute></input></xsl:if>
<input type="hidden" name="p"><xsl:attribute name="value">{$_REQUEST['p']}</xsl:attribute></input>
<xsl:if test="../@letter"><input type="hidden" name="l"><xsl:attribute name="value">{$_REQUEST['l']}</xsl:attribute></input></xsl:if>
</td></tr>
EOF;
$sth=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('SELECT <xsl:apply-templates select="col[@type!=11][@visuality='y' or @selectible='y']" mode="name"/> FROM <xsl:apply-templates select="@name"/> WHERE <xsl:apply-templates select="../col[@primary]/@name"/>=? <xsl:choose><xsl:when test="@ordering"><xsl:text> </xsl:text>order<xsl:text> </xsl:text>by<xsl:text> </xsl:text><xsl:value-of select="@ordering"/></xsl:when><xsl:otherwise><xsl:if test="col/@type=11"><xsl:text> </xsl:text>order<xsl:text> </xsl:text>by<xsl:text> </xsl:text><xsl:value-of select="col[@type=11]/@name"/></xsl:if></xsl:otherwise></xsl:choose>',$_REQUEST['id']);
print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<tr bgcolor="#FFFFFF"><td><input type="checkbox" onclick="return SelectAll(this.form,checked,'[iid]');"/></td><xsl:apply-templates select="col[@type!=11][@visuality='y']" mode="head"/><td></td></tr>
EOF;
while(list(<xsl:apply-templates select="col[@type!=11][@visuality='y' or @selectible='y']" mode="vars"/>)=mysql_fetch_array($sth, MYSQL_NUM))
{<xsl:value-of select="extrainlist" disable-output-escaping="yes"/><xsl:apply-templates select="col[@visuality='y']" mode="previsible"/>
<xsl:if test="col[@isstate='y']">if($V_<xsl:value-of select="col[@isstate='y']/@name"/>){$V_<xsl:value-of select="col[@isstate='y']/@name"/>='#FFFFFF';} else {$V_<xsl:value-of select="col[@isstate='y']/@name"/>='#a0a0a0';}</xsl:if>
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<tr bgcolor="#FFFFFF"><xsl:if test="col[@isstate='y']"><xsl:attribute name="bgcolor">$V_<xsl:value-of select="col[@isstate='y']/@name"/></xsl:attribute></xsl:if>
<td><input type="checkbox" name="iid[]" value="$V_{col[@primary='y']/@name}"/></td>
<xsl:apply-templates select="col[@type!=11][@visuality='y']" mode="varsprint"/><td nowrap="">
<xsl:if test="col/@type=11"><a href="{../@name}.php?e{position()}=UP&amp;iid=$V_{col[@primary='y']/@name}{$p}#f{position()}"><img src="i/up.gif" border="0"/></a>
<a href="{../@name}.php?e{position()}=DN&amp;iid=$V_{col[@primary='y']/@name}{$p}#f{position()}"><img src="i/dn.gif" border="0"/></a></xsl:if>
<a href="{../@name}.php?e{position()}=ED&amp;iid=$V_{col[@primary='y']/@name}{$p}"><img src="i/ed.gif" border="0" title="Изменить"/></a>
<xsl:apply-templates select="child_script"/></td></tr>
EOF;
}
print '</form></table>';<xsl:if test="ifsection">
}</xsl:if>
</xsl:template>

</xsl:stylesheet>