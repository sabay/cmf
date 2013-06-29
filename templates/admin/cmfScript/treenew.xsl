<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="../_main.xsl"/>

<xsl:template match="error" mode="edit">
<tr bgcolor="#FFFFFF"><td colspan="2" style="color:red"><xsl:apply-templates/></td></tr>
</xsl:template>

<xsl:template match="col" mode="edit">
<xsl:apply-templates select="/page/data/errors/error[@name=current()/@name]" mode="edit"/>
<tr bgcolor="#FFFFFF"><th width="1%"><b><xsl:apply-templates select="name"/>:<br/><img src="{/page/root}/admin/i/0.gif" width="125" height="1"/></b></th><td width="100%"><xsl:choose>
<xsl:when test="type=1"><input type="text" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="90"></input><br/></xsl:when>
<xsl:when test="type=2">
<textarea name="{@name}" rows="{rows}" cols="{cols}"><xsl:value-of select="/page/data/values/*[name()=current()/@name]"/></textarea>
<br/></xsl:when>
<xsl:when test="type=3"><input type="text" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}"/><br/></xsl:when>
<xsl:when test="type=4"><input type="text" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}"/><br/></xsl:when>
<xsl:when test="type=5"><input type="text" name="{@name}" value="{/page/data/values/*[name()=current()/@name]}" size="{@size}"><xsl:if test="@panelize='y'"><xsl:attribute name="onfocus">_XDOC=this;</xsl:attribute><xsl:attribute name="onkeydown">_etaKey(event)</xsl:attribute></xsl:if></input><br/></xsl:when>
<xsl:when test="type=6">
<xsl:choose>
<xsl:when test="@popup='y'">
<input type="hidden" name="{@name}" value="$V_{@name}"/><input type="text" name="v_{@name}" value="$V_STR_{@name}"/><input type="button" onclick="return DictPopUp('{ref/table}','{@name}');" value="&#187;"/><br/>
</xsl:when>
<xsl:otherwise>
<select name="{@name}"><xsl:if test="ref/none"><option value="0"><xsl:value-of select="ref/none"/></option></xsl:if><xsl:copy-of select="/page/data/values/multioptions/*[name()=current()/@name]/*"/></select><br/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="type=13"><select name="{@name}"><xsl:if test="ref/none"><option value="0"><xsl:value-of select="ref/none"/></option></xsl:if>$V_STR_<xsl:value-of select="@name"/></select><br/></xsl:when>
<xsl:when test="type=7"><input type="hidden" name="old_{@name}" value="{/page/data/values/*[name()=current()/@name]/full}"><xsl:if test="/page/data/values/*[name()=concat('old_',current()/@name)]"><xsl:attribute name="value"><xsl:value-of select="/page/data/values/*[name()=concat('old_',current()/@name)]"/></xsl:attribute></xsl:if></input>
<table><tr><td>
<img src="{/page/root}/images{/page/data/@imgpath}{dir}{/page/data/values/*[name()=current()/@name]/src}" width="{/page/data/values/*[name()=current()/@name]/w}" height="{/page/data/values/*[name()=current()/@name]/h}"/></td>
<td><input type="file" name="{@name}" size="1"/><br/>
<input type="checkbox" name="CLR_{@name}" value="1"/>Сбросить картинку
</td></tr></table></xsl:when>
<xsl:when test="type=8"><input type='checkbox' name='{@name}' value='1' select="@name"><xsl:if test="/page/data/values/*[name()=current()/@name]='1'"><xsl:attribute name="checked"></xsl:attribute></xsl:if></input><br/></xsl:when>
<xsl:when test="type=10"><select name="{@name}"><xsl:copy-of select="/page/data/values/multioptions/*[name()=current()/@name]/*"/></select><br/></xsl:when>
<xsl:when test="type=12"><input type="text" name="{@name}" value="$V_{@name}"/><xsl:if test="@calendar">
        <img id="c_anc_{@name}" src="{/page/root}/admin/i/0.gif" width="1" height="1" />
        <input type="image" src="{/page/root}/admin/i/c/cal.gif" width="34" class="button" onClick="return showCalendar(this,'{@name}');"/>
        <div id="c_div_{@name}" style="position:absolute;"></div>
</xsl:if>(YYYY-MM-DD)<br/></xsl:when>
<xsl:when test="type=14"><input type="hidden" name="old_{@name}" value="{/page/data/values/*[name()=current()/@name]/full}"/>
<table><tr><td><input type="file" name="{@name}" size="1"/><br/><input type="checkbox" name="CLR_{@name}" value="1"/>РЎР+С_Р_С_РёС'С_ С"Р°Р№Р>.</td>
<td>&#160;</td><td>size=$IM_<xsl:value-of select="@name"/>[1]<br/>/images/$VIRTUAL_IMAGE_PATH$IM_<xsl:value-of select="@name"/>[0]
</td></tr></table></xsl:when>
</xsl:choose></td></tr>
</xsl:template>

<xsl:template match="data[@new]">
<h2 class="h2">Добавление - <xsl:apply-templates select="name"/></h2>
<table bgcolor="#CCCCCC" border="0" cellpadding="5" cellspacing="1" style="width: 500px" class="f">
<form method="POST" id="f" action="{/page/root}/admin/{name}/insert/" ENCTYPE="multipart/form-data">
<input type="hidden" name="parent_id" value="{/page/data/@pid}"/>
<tr bgcolor="#F0F0F0" class="ftr"><td colspan="2">
<input type="submit" name="e" value="Добавить" class="gbt badd" onclick="this.form.action='{/page/root}/admin/{name}/insert/'"/>
<input type="submit" name="e" value="Назад" class="gbt bcancel" onclick="this.form.action='{/page/root}/admin/{name}/'"/>
</td></tr>
<xsl:apply-templates select="meta/col[not(primary) and not(parent) and not(internal) and not(noform)]" mode="edit"/>
<tr bgcolor="#F0F0F0" class="ftr"><td colspan="2">
<input type="submit" name="e" value="Добавить" class="gbt badd" onclick="this.form.action='{/page/root}/admin/{name}/insert/'"/>
<input type="submit" name="e" value="Назад" class="gbt bcancel" onclick="this.form.action='{/page/root}/admin/{name}/'"/>
</td></tr>
</form>
</table><br/>
</xsl:template>

<xsl:template match="data[@edit]">
<h2 class="h2">Редактирование - <xsl:apply-templates select="name"/></h2>
<table bgcolor="#CCCCCC" border="0" cellpadding="5" cellspacing="1" style="width: 500px" class="f">
<form method="POST" id="f" action="{/page/root}/admin/{name}/update/" ENCTYPE="multipart/form-data">
<input type="hidden" name="id" value="{@id}"/>
<tr bgcolor="#F0F0F0" class="ftr"><td colspan="2">
<input type="submit" name="e" value="Изменить" class="gbt badd" onclick="this.form.action='{/page/root}/admin/{name}/update/'"/>
<input type="button" name="event" onclick="document.location='{/page/root}/admin/editor/?type={xml_type}&amp;id={@id}';" value="  Полный текст" class="gbt bxml"/>
<input type="submit" name="e" value="Назад" class="gbt bcancel" onclick="this.form.action='{/page/root}/admin/{name}/'"/>
</td></tr>
<xsl:apply-templates select="meta/col[not(primary) and not(parent) and not(internal) and not(noform)]" mode="edit"/>
<tr bgcolor="#F0F0F0" class="ftr"><td colspan="2">
<input type="submit" name="e" value="Изменить" class="gbt badd" onclick="this.form.action='{/page/root}/admin/{name}/update/'"/>
<input type="submit" name="e" value="Назад" class="gbt bcancel" onclick="this.form.action='{/page/root}/admin/{name}/'"/>
</td></tr>
</form>
</table><br/>
</xsl:template>

</xsl:stylesheet>