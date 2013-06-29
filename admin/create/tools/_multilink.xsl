<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml"  omit-xml-declaration="yes" encoding="utf-8"/>

<xsl:template match="table[@multilink='y']" mode="events" xml:space="preserve">
<xsl:param name="parenttable"/>
<xsl:param name="pos"/>
<xsl:if test="not(@nodel)">
if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('el<xsl:value-of select="$pos"/>') == 'Удалить')
{
foreach ($_REQUEST['iid'] as $id)
 {<xsl:if test="col[@type=11]">
list($ORDERING)=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT <xsl:value-of select="col[@type=11]/@name"/> FROM <xsl:value-of select="@name"/> WHERE <xsl:value-of select="../col[@link='y'][ref/table!=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=?',$_REQUEST['id'],$id);
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>-1 WHERE <xsl:value-of select="../col[@link='y'][ref/table!=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@type=11]/@name"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>?',$_REQUEST['id'],$ORDERING);</xsl:if>
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('DELETE FROM <xsl:apply-templates select="@name"/> WHERE <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>=?',$_REQUEST['id'],$id);
<xsl:value-of select="postdeleteevent" disable-output-escaping="yes"/>
 }
<xsl:value-of select="postdeletesevent" disable-output-escaping="yes"/>
$_REQUEST['e']='ED';
}
</xsl:if>

<xsl:if test="not(@noedit)">
<xsl:if test="col/@type=11">
if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('eventl<xsl:value-of select="$pos"/>') == 'UP')
{
$ORDERING=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT <xsl:value-of select="col[@type=11]/@name"/> FROM <xsl:value-of select="@name"/> WHERE <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
if($ORDERING<xsl:text disable-output-escaping="yes">&gt;</xsl:text>1)
{
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>+1 WHERE <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@type=11]/@name"/>=?',,$_REQUEST['id'],$ORDERING-1);
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>-1 WHERE <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
}
$_REQUEST['e']='ED';
}

if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('eventl<xsl:value-of select="$pos"/>') == 'DN')
{
$ORDERING=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT <xsl:value-of select="col[@type=11]/@name"/> FROM <xsl:value-of select="@name"/> WHERE <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
$MAXORDERING=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('SELECT max(<xsl:value-of select="col[@type=11]/@name"/>) FROM <xsl:value-of select="@name"/>');
if($ORDERING<xsl:text disable-output-escaping="yes">&lt;</xsl:text>$MAXORDERING)
{
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>-1 WHERE <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@type=11]/@name"/>=?',$_REQUEST['id'],$ORDERING+1);
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=<xsl:value-of select="col[@type=11]/@name"/>+1 WHERE <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
}
$_REQUEST['e']='ED';
}
</xsl:if>


if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('el<xsl:value-of select="$pos"/>') == 'Изменить')
{
<xsl:apply-templates select="col" mode="preinsert"/>
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('UPDATE <xsl:value-of select="@name"/> set <xsl:apply-templates select="col[@type!=11 and not(@link)]|col[@link  and ref/table!=$parenttable/@name]" mode="update"><xsl:with-param name="off">2</xsl:with-param></xsl:apply-templates> WHERE <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>=?',<xsl:apply-templates select="col[@type!=11 and not(@link)]|col[@link  and ref/table!=$parenttable/@name]" mode="form"/>,$_REQUEST['id'],$_REQUEST['iid']);
<xsl:value-of select="postupdateevent" disable-output-escaping="yes"/>
$_REQUEST['e']='ED';
};
</xsl:if>

<xsl:if test="not(@noadd)">
if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('el<xsl:value-of select="$pos"/>') == 'Добавить')
{
<xsl:if test="col/@type=11">
$_REQUEST['<xsl:value-of select="col[@type=11]/@name"/>']=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_array('select max(<xsl:value-of select="col[@type=11]/@name"/>) FROM <xsl:apply-templates select="@name"/> WHERE <xsl:apply-templates select="$parenttable/col[@type=0]/@name"/>=?',$_REQUEST['id']);
</xsl:if>
foreach ($_REQUEST['<xsl:value-of select="col[@link='y' and ref/table!=$parenttable/@name]/@name"/>'] as $id)
{<xsl:if test="col/@type=11">$_REQUEST['<xsl:value-of select="col[@type=11]/@name"/>']++;</xsl:if>
<xsl:value-of select="preinsertevent" disable-output-escaping="yes"/>
<xsl:apply-templates select="col" mode="preinsert"/>
$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('INSERT INTO <xsl:apply-templates select="@name"/> (<xsl:apply-templates select="col[@link][ref/table=$parenttable/@name]" mode="name_insert"/>,<xsl:apply-templates select="col[@link][ref/table!=$parenttable/@name]" mode="name_insert"/>,<xsl:apply-templates select="col[not(@link)]" mode="name_insert"/>) values (<xsl:apply-templates select="col" mode="vopros"/>)',$_REQUEST['id'],$id,<xsl:apply-templates select="col[not(@link)]" mode="form"/>);
//$_REQUEST['iid']=$_REQUEST['<xsl:value-of select="col[@link='y' and ref/table!=$parenttable/@name]/@name"/>'];
<xsl:value-of select="postinsertevent" disable-output-escaping="yes"/>
}
$_REQUEST['e']='ED';
$visible=0;
}
</xsl:if>

if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('eventl<xsl:value-of select="$pos"/>') == 'ED')
{
list (<xsl:apply-templates select="col[@type!=11]" mode="vars"/>)=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_arrayQ('select <xsl:apply-templates select="col[@type!=11]" mode="name"/> FROM <xsl:value-of select="@name"/> WHERE <xsl:value-of select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? and <xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>=?',$_REQUEST['id'],$_REQUEST['iid']);
<xsl:value-of select="preeditevent" disable-output-escaping="yes"/>
<xsl:apply-templates select="col" mode="preedit"/>
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<tr>
	<td style="padding: 0px 0px 0px 15px;">
	<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td style="background: url(img/main_cat.gif) no-repeat left top;" class="main_title" nowrap="nowrap"><xsl:if test="name/@icon"><xsl:attribute name="style">background: url(img/<xsl:value-of select="name/@icon"/>) no-repeat left top;</xsl:attribute></xsl:if>Редактирование - <xsl:apply-templates select="name"/></td>
		<td width="100%">&#160;</td>
	</tr>
	</table>
	</td>
</tr>
<tr>
<form method="POST" action="{$parenttable/@name}.php#fl{$pos}" ENCTYPE="multipart/form-data"><xsl:attribute name="onsubmit">return true <xsl:apply-templates select="col" mode="formvalid"/>;</xsl:attribute>
<input type="hidden" name="e" value="ED"/>
<input type="hidden" name="id"><xsl:attribute name="value">{$_REQUEST['id']}</xsl:attribute></input>
<xsl:if test="$parenttable/@parentscript"><input type="hidden" name="pid"><xsl:attribute name="value">{$_REQUEST['pid']}</xsl:attribute></input></xsl:if>
<input type="hidden" name="iid"><xsl:attribute name="value">{$_REQUEST['iid']}</xsl:attribute></input>
<xsl:if test="@type"><input type="hidden" name="type" value="{@type}"/></xsl:if>
<xsl:if test="$parenttable/@letter"><input type="hidden" name="l"><xsl:attribute name="value">{$_REQUEST['l']}</xsl:attribute></input></xsl:if>
<input type="hidden" name="p"><xsl:attribute name="value">{$_REQUEST['p']}</xsl:attribute></input>
<xsl:if test="@letter"><input type="hidden" name="l"><xsl:attribute name="value">{$_REQUEST['l']}</xsl:attribute></input></xsl:if>
<td style="padding: 0px 19px 0px 21px;">
<br/>
<table width="100%" cellpadding="0" cellspacing="0">
<xsl:apply-templates select="col[@type!=11 and not(@link and ref/table=$parenttable/@name) and not(@internal)]|panel|pseudocol" mode="edit"/>
<tr>
	<td class="main_tbl_title2" colspan="2">
	<input type="submit" name="el{$pos}" value="Изменить" class="gbt bsave"/>&#160;<xsl:if test="@type">
	<input type="image" name="e" onclick="this.form.action='EDITER.php';" src="i/xml.gif" border="0"/>&#160;&#160;</xsl:if>
	<input type="submit" name="el{$pos}" value="Отменить" class="gbt bcancel"/>
	</td>
</tr>
</table>
</td>
</form>
</tr>
EOF;
$_REQUEST['e']='';
$visible=0;
}

if($cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Param('el<xsl:value-of select="$pos"/>') == 'Новый')
{
list(<xsl:apply-templates select="col" mode="vars"/>)=array(<xsl:apply-templates select="col" mode="vars_init"/>);
<xsl:value-of select="preaddevent" disable-output-escaping="yes"/>
<xsl:apply-templates select="col" mode="preadd"/>
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<tr>
	<td style="padding: 0px 0px 0px 15px;">
	<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td style="background: url(img/main_cat.gif) no-repeat left top;" class="main_title" nowrap="nowrap"><xsl:if test="name/@icon"><xsl:attribute name="style">background: url(img/<xsl:value-of select="name/@icon"/>) no-repeat left top;</xsl:attribute></xsl:if>Добавление - <xsl:apply-templates select="name"/></td>
		<td width="100%">&#160;</td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td style="padding: 0px 19px 0px 21px;">
	<br/>
<table cellpadding="0" cellspacing="0">
<form method="POST" action="{$parenttable/@name}.php#fl{$pos}" ENCTYPE="multipart/form-data"><xsl:attribute name="onsubmit">return true <xsl:apply-templates select="col" mode="formvalid"/>;</xsl:attribute>
<input type="hidden" name="e" value="ED"/>
<input type="hidden" name="id"><xsl:attribute name="value">{$_REQUEST['id']}</xsl:attribute></input>
<xsl:if test="$parenttable/@parentscript"><input type="hidden" name="pid"><xsl:attribute name="value">{$_REQUEST['pid']}</xsl:attribute></input></xsl:if>
<input type="hidden" name="p"><xsl:attribute name="value">{$_REQUEST['p']}</xsl:attribute></input>
<xsl:if test="$parenttable/@letter"><input type="hidden" name="l"><xsl:attribute name="value">{$_REQUEST['l']}</xsl:attribute></input></xsl:if>
EOF;
<xsl:variable name="ltbn" select="col[@link='y'][ref/table!=$parenttable/@name]/ref/table"/>

<xsl:choose>
	<xsl:when test="extraforminsert!=''"><xsl:value-of select="extraformevent" disable-output-escaping="yes"/></xsl:when>
	<xsl:when test="not(/config/table[@name=$ltbn]/@parentscript)">
	#обычный список
	$VV_<xsl:value-of select="/config/table[@name=$ltbn]/col[@primary='y']/@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Spravotchnik('','select <xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>,<xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/ref/visual"/> FROM <xsl:value-of select="/config/table[@name=$ltbn]/@name"/>  <xsl:text> </xsl:text>order<xsl:text> </xsl:text>by<xsl:text> </xsl:text> <xsl:choose><xsl:when test="/config/table[@name=$ltbn]/@ordering"><xsl:value-of select="/config/table[@name=$ltbn]/@ordering"/></xsl:when><xsl:when test="not(/config/table[@name=$ltbn]/@ordering) and /config/table[@name=$ltbn]/col[@type=11]"><xsl:value-of select="/config/table[@name=$ltbn]/col[@type=11]/@name"/></xsl:when><xsl:otherwise><xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/ref/visual"/></xsl:otherwise></xsl:choose>');
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<tr><td class="tbl_t2"><span class="title2"><xsl:value-of select="/config/table[@name=$ltbn]/name"/></span><br /><img src="i/0.gif" width="125" height="1" /></td><td  width="100%" class="tbl_e2">
<table><tr><td><input type="text" name="q" onkeyup="return chan(this.form,this.form.elements['{col[@link='y'][ref/table!=$parenttable/@name]/@name}[]'],'select {col[@link='y'][ref/table!=$parenttable/@name]/@name},{col[@link='y'][ref/table!=$parenttable/@name]/ref/visual} FROM {/config/table[@name=$ltbn]/@name} WHERE {col[@link='y'][ref/table!=$parenttable/@name]/ref/visual} like ? order by {col[@link='y'][ref/table!=$parenttable/@name]/ref/visual}',this.value+'%25');"/></td></tr>
<tr><td><select name="{col[@link='y'][ref/table!=$parenttable/@name]/@name}[]" multiple="" style="width:100%" size="8">{$VV_<xsl:value-of select="/config/table[@name=$ltbn]/col[@primary='y']/@name"/>}</select></td></tr></table></td></tr>
EOF;

	</xsl:when>
	<xsl:when test="/config/table[@name=$ltbn]/@parentscript">
	#список от child-таблицы
	<xsl:variable name="plbtn" select="/config/table[@name=$ltbn]/@parentscript"/>
	<xsl:choose>
	<xsl:when test="/config/table[@name=$plbtn]/@treechild">
	#список от child-древовидной таблицы
	<xsl:variable name="parentcol" select="/config/table[@name=$ltbn]/col[ref/table=$plbtn]/ref/visual"/>
	<xsl:value-of select="parentcol"/>
	$VV_<xsl:value-of select="/config/table[@name=$plbtn]/col[@primary='y']/@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>TreeSpravotchnik('','SELECT <xsl:value-of select="/config/table[@name=$plbtn]/col[@primary='y']/@name"/>,<xsl:value-of select="$parentcol"/> FROM <xsl:value-of select="$plbtn"/> WHERE parent_id = ?',0);
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<tr><td class="tbl_t2"><span class="title2"><xsl:value-of select="$parenttable/name"/></span></td><td class="tbl_e2" width="100%">
<table><tr><td><xsl:value-of select="/config/table[@name=$plbtn]/name"/>: <select name="{/config/table[@name=$plbtn]/col[@primary='y']/@name}" onchange="return chan(this.form,this.form.elements['{col[@link='y'][ref/table!=$parenttable/@name]/@name}[]'],'select {col[@link='y'][ref/table!=$parenttable/@name]/@name},{col[@link='y'][ref/table!=$parenttable/@name]/ref/visual} FROM {/config/table[@name=$ltbn]/@name} WHERE {/config/table[@name=$plbtn]/col[@primary='y']/@name}=? order by NAME',this.value);">{$VV_<xsl:value-of select="/config/table[@name=$plbtn]/col[@primary='y']/@name"/>}</select>&#160;
Фильтр: <input type="text" name="q" onkeyup="return chan(this.form,this.form.elements['{col[@link='y'][ref/table!=$parenttable/@name]/@name}[]'],'select {col[@link='y'][ref/table!=$parenttable/@name]/@name},NAME FROM {/config/table[@name=$ltbn]/@name} WHERE {/config/table[@name=$plbtn]/col[@primary='y']/@name}=? and NAME like ? order by NAME',{/config/table[@name=$plbtn]/col[@primary='y']/@name}.value+'\|%25'+this.value+'%25');"/></td></tr>
<tr><td><select name="{col[@link='y'][ref/table!=$parenttable/@name]/@name}[]" multiple="" style="width:100%" size="8"></select></td></tr></table></td></tr>
EOF;
	</xsl:when>
	<xsl:otherwise>
	#список от child-обычной таблицы
	<xsl:variable name="parentcol" select="/config/table[@name=$ltbn]/col[ref/table=$plbtn]/ref/visual"/>
	<xsl:value-of select="parentcol"/>
	$VV_<xsl:value-of select="/config/table[@name=$plbtn]/col[@primary='y']/@name"/>=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>Spravotchnik('','select <xsl:value-of select="/config/table[@name=$plbtn]/col[@primary='y']/@name"/>,<xsl:value-of select="$parentcol"/> FROM <xsl:value-of select="$plbtn"/>');
	print qq{<tr><td class="tbl_t2"><span class="title2"><xsl:value-of select="$parenttable/name"/></span></td><td class="tbl_e2" width="100%">
		<table><tr><td><xsl:value-of select="/config/table[@name=$plbtn]/name"/>: <select name="{/config/table[@name=$plbtn]/col[@primary='y']/@name}" onchange="return chan(this.form,this.form.elements['{col[@link='y'][ref/table!=$parenttable/@name]/@name}[]'],'select {col[@link='y'][ref/table!=$parenttable/@name]/@name},{col[@link='y'][ref/table!=$parenttable/@name]/ref/visual} FROM {/config/table[@name=$ltbn]/@name} WHERE {/config/table[@name=$plbtn]/col[@primary='y']/@name}=? order by NAME',this.value);">$VV_<xsl:value-of select="/config/table[@name=$plbtn]/col[@primary='y']/@name"/></select>&#160;
	Фильтр: <input type="text" name="q" onkeyup="return chan(this.form,this.form.elements['{col[@link='y'][ref/table!=$parenttable/@name]/@name}[]'],'select {col[@link='y'][ref/table!=$parenttable/@name]/@name},NAME FROM {/config/table[@name=$ltbn]/@name} WHERE {/config/table[@name=$plbtn]/col[@primary='y']/@name}=? and NAME like ? order by NAME',{/config/table[@name=$plbtn]/col[@primary='y']/@name}.value+'\|%25'+this.value+'%25');"/></td></tr>
	<tr><td><select name="{col[@link='y'][ref/table!=$parenttable/@name]/@name}[]" multiple="" style="width:100%" size="8"></select></td></tr></table></td></tr>};

	</xsl:otherwise>
	</xsl:choose>
	</xsl:when>
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<xsl:apply-templates select="col[@type!=11 and not(@link) and not(@internal)]|panel|pseudocol" mode="edit"/>
	<tr>
		<td class="main_tbl_title2" colspan="2">
		<input type="submit" name="el{$pos}" value="Добавить" class="gbt badd"/>&#160;
		<input type="submit" name="el{$pos}" value="Отменить" class="gbt bcancel"/>
		</td>
	</tr>
</form>
</table>
	</td>
</tr>
EOF;
$visible=0;
}
</xsl:template>


<xsl:template match="table[@multilink='y']" xml:space="preserve">
<xsl:param name="parenttable"/><!-- xsl:value-of select="$parenttable/@name"/ -->
<xsl:param name="pos"/>
<xsl:value-of select="define" disable-output-escaping="yes"/>
<xsl:variable name="p">&amp;id={$_REQUEST['id']}<xsl:if test="$parenttable/@letter">&amp;l={$_REQUEST['l']}</xsl:if><xsl:if test="$parenttable/@parentscript">&amp;pid={$_REQUEST['pid']}</xsl:if></xsl:variable>
<xsl:if test="ifsection"><xsl:value-of select="ifsection" disable-output-escaping="yes"/># Секция появляется только в случае выполнения условия
{</xsl:if>
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<tr>
	<td>&#160;</td>
</tr>
<tr>
	<td style="padding: 0px 0px 0px 15px;">
	<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td style="background: url(img/main_cat.gif) no-repeat left top;" class="main_title" nowrap="nowrap"><xsl:if test="name/@icon"><xsl:attribute name="style">background: url(img/<xsl:value-of select="name/@icon"/>) no-repeat left top;</xsl:attribute></xsl:if><a name="fl{$pos}"></a><xsl:apply-templates select="name"/></td>
		<td width="100%">&#160;</td>
		<!-- td align="right" nowrap="nowrap" class="bottom">Быстрый доступ к разделам:</td><td><select style="width: 175px;"></select></td-->
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td style="padding: 0px 19px 0px 21px;">
	<br/>
	<table cellpadding="0" cellspacing="0">
	<form action="{$parenttable/@name}.php#fl{$pos}" method="POST">
	<tr>
		<td colspan="{count(col[@type!=11][@visuality='y'])+3}" class="main_tbl_title">
		<input type="submit" name="el{$pos}" value="Новый" class="gbt bnew"/><img src="i/0.gif" width="4" height="1"/><xsl:apply-templates select="extrakey"/>
		<input type="submit" onclick="return dl();" name="el{$pos}" value="Удалить" class="gbt bdel"/>
		<input type="hidden" name="id"><xsl:attribute name="value">{$_REQUEST['id']}</xsl:attribute></input>
		<xsl:if test="$parenttable/@parentscript"><input type="hidden" name="pid"><xsl:attribute name="value">{$_REQUEST['pid']}</xsl:attribute></input></xsl:if>
		<input type="hidden" name="p"><xsl:attribute name="value">{$_REQUEST['p']}</xsl:attribute></input>
		<xsl:if test="$parenttable/@letter"><input type="hidden" name="l"><xsl:attribute name="value">{$_REQUEST['l']}</xsl:attribute></input></xsl:if>
		</td>
	</tr>
EOF;
<xsl:if test="col/@type=11">$ttime=time();</xsl:if>

$sth=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>execute('select <xsl:apply-templates select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>,<xsl:apply-templates select="col[@type!=11][@visuality='y' or @selectible='y']" mode="name"/> FROM <xsl:apply-templates select="@name"/> WHERE <xsl:apply-templates select="col[@link='y'][ref/table=$parenttable/@name]/@name"/>=? <xsl:choose><xsl:when test="@ordering"><xsl:text> </xsl:text>order<xsl:text> </xsl:text>by<xsl:text> </xsl:text><xsl:value-of select="@ordering"/></xsl:when><xsl:otherwise><xsl:if test="col/@type=11"><xsl:text> </xsl:text>order<xsl:text> </xsl:text>by<xsl:text> </xsl:text><xsl:value-of select="col[@type=11]/@name"/></xsl:if></xsl:otherwise></xsl:choose>',$_REQUEST['id']);
?<xsl:text disable-output-escaping="yes">&gt;</xsl:text><tr><td class="main_tbl_left_chk"><input type="checkbox" onclick="return SelectAll(this.form,checked,'iid[]');"/></td><xsl:apply-templates select="col[@type!=11][@visuality='y' or (@link='y' and ref/table!=$parenttable/@name)]" mode="head"/><td  class="main_tbl_right">&#160;</td></tr><xsl:text disable-output-escaping="yes">&lt;</xsl:text>?
while(list(<xsl:apply-templates select="col[@type!=11][@visuality='y' or @selectible='y' or (@link='y' and ref/table!=$parenttable/@name)]" mode="vars"/>)=mysql_fetch_array($sth, MYSQL_NUM))
{<xsl:value-of select="previsible" disable-output-escaping="yes"/><xsl:value-of select="extrainlist" disable-output-escaping="yes"/><xsl:apply-templates select="col[@visuality='y']|col[@link='y' and ref/table!=$parenttable/@name]" mode="multi-previsible"/>
<xsl:if test="col[@isstate='y']">$V_<xsl:value-of select="col[@isstate='y']/@name"/>+=0;</xsl:if>
@print <xsl:text disable-output-escaping="yes">&lt;&lt;&lt;</xsl:text>EOF
<tr class="mt1"><xsl:if test="col[@isstate='y']"><xsl:attribute name="class">mt{$V_<xsl:value-of select="col[@isstate='y']/@name"/>}</xsl:attribute></xsl:if>
<td><input type="checkbox" name="iid[]"><xsl:attribute name="value">{$V_<xsl:value-of select="col[@link='y'][ref/table!=$parenttable/@name]/@name"/>}</xsl:attribute></input></td>
<xsl:apply-templates select="col[@type!=11][@visuality='y']|col[@link='y' and ref/table!=$parenttable/@name]" mode="multi-varsprint"/><td>
<xsl:if test="col/@type=11"><a href="{$parenttable/@name}.php?eventl{$pos}=UP&amp;iid=$V_{col[@link='y'][ref/table!=$parenttable/@name]/@name}{$p}&amp;$ttime#f{$pos}"><img src="i/up.gif" border="0"/></a>
<a href="{$parenttable/@name}.php?eventl{$pos}=DN&amp;iid=$V_{col[@link='y'][ref/table!=$parenttable/@name]/@name}{$p}&amp;$ttime#f{position()}"><img src="i/dn.gif" border="0"/></a></xsl:if>
<a href="{$parenttable/@name}.php?eventl{$pos}=ED&amp;iid=$V_{col[@link='y'][ref/table!=$parenttable/@name]/@name}{$p}"><img src="i/ed.gif" border="0" title="Изменить"/></a>
<xsl:apply-templates select="child_script"/></td></tr>
EOF;
}
print '</form></table></td></tr>';
<xsl:if test="ifsection">
}</xsl:if>
</xsl:template>

<xsl:template match="table/link">
<xsl:apply-templates select="/config/table[@multilink='y'][@name=current()/@name]"><xsl:with-param name="parenttable" select=".."/><xsl:with-param name="pos" select="position()"/></xsl:apply-templates>
</xsl:template>

<xsl:template match="table/link" mode="events">
<xsl:apply-templates select="/config/table[@multilink='y'][@name=current()/@name]" mode="events"><xsl:with-param name="parenttable" select=".."/><xsl:with-param name="pos" select="position()"/></xsl:apply-templates>
</xsl:template>


<xsl:template match="col" mode="multi-varsprint"><td><xsl:choose><xsl:when test="@input='y'"><input class="f_in_sm" tabindex="$TABposition{@name}" onchange="ch(this)" type="text" name="{@name}_$V_{../col[@primary='y' and not(@parent)]/@name}"><xsl:attribute name="value">$V_<xsl:apply-templates select="@name"/></xsl:attribute></input></xsl:when><xsl:otherwise>$V_<xsl:apply-templates select="@name"/><xsl:if test="@link='y' and (@type=6 or @type=13)">_STR</xsl:if></xsl:otherwise></xsl:choose></td></xsl:template>

<xsl:template match="col" mode="multi-previsible">
<xsl:choose>
<xsl:when test="@type=6">
<xsl:choose>
	<xsl:when test="@link='y'">
$V_<xsl:apply-templates select="@name"/>_STR=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_arrayQ('select <xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/> WHERE <xsl:apply-templates select="ref/field"/>=?',$V_<xsl:apply-templates select="@name"/>);
	</xsl:when>
	<xsl:otherwise>
($V_<xsl:apply-templates select="@name"/>)=$cmf-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_arrayQ('select <xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/> WHERE <xsl:apply-templates select="ref/field"/>=?',$V_<xsl:apply-templates select="@name"/>);
	</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="@type=7">
my @IM_<xsl:value-of select="position()"/>=split('#',$V_<xsl:apply-templates select="@name"/>);
if($IM_<xsl:value-of select="position()"/>[1] <xsl:text disable-output-escaping="yes">&gt;</xsl:text> 150){$IM_<xsl:value-of select="position()"/>[2]=$IM_<xsl:value-of select="position()"/>[2]*150/$IM_<xsl:value-of select="position()"/>[1]; $IM_<xsl:value-of select="position()"/>[1]=150;}
$V_<xsl:apply-templates select="@name"/>=qq{<xsl:text disable-output-escaping="yes">&lt;</xsl:text>img src="/images$VIRTUAL_IMAGE_PATH$IM_<xsl:value-of select="position()"/>[0]" width="$IM_<xsl:value-of select="position()"/>[1]" height="$IM_<xsl:value-of select="position()"/>[2]"<xsl:text disable-output-escaping="yes">&gt;</xsl:text>};
</xsl:when>
<xsl:when test="@type=13">
<xsl:choose>
	<xsl:when test="@link='y'">
my ($V_<xsl:apply-templates select="@name"/>_STR)=<xsl:value-of select="/config/basename"/>::GetTreePath($dbh,q{SELECT parent_id,<xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/> WHERE <xsl:apply-templates select="ref/field"/>=?},$V_<xsl:apply-templates select="@name"/>);
	</xsl:when>
	<xsl:otherwise>
($V_<xsl:apply-templates select="@name"/>)=$CMF-<xsl:text disable-output-escaping="yes">&gt;</xsl:text>selectrow_arrayQ(q{select <xsl:apply-templates select="ref/visual"/> FROM <xsl:apply-templates select="ref/table"/> WHERE <xsl:apply-templates select="ref/field"/>=?},$V_<xsl:apply-templates select="@name"/>);
	</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="@type=8">
if(!$V_<xsl:apply-templates select="@name"/>) {$V_<xsl:apply-templates select="@name"/>=q{Нет};} else {$V_<xsl:apply-templates select="@name"/>=q{Да};}
</xsl:when>
<xsl:when test="@type=10">
$V_<xsl:value-of select="@name"/>=$ENUM_<xsl:value-of select="@name"/>[$V_<xsl:value-of select="@name"/><xsl:if test="enum/@start &gt; 0">-<xsl:value-of select="enum/@start"/></xsl:if>];
</xsl:when>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>
