<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="../new.xsl"/>


<xsl:template match="row" mode="fullist">
<tr id='ttt{id}'>
<td><xsl:if test="restriction_id!=''"><xsl:attribute name="style">color: #ff0000;</xsl:attribute></xsl:if><xsl:apply-templates select="name"/></td>
<td nowrap="nowrap"><input type="checkbox" name="module_id[]" value="{id}"><xsl:attribute name="onchange">$('#ttt<xsl:value-of select="id"/>').addClass('spec');</xsl:attribute><xsl:if test="restriction_id!=''"><xsl:attribute name="checked"></xsl:attribute></xsl:if></input></td>
<td nowrap="nowrap"><input type="checkbox" name="is_editor[{id}]" value="1"><xsl:if test="is_editor='1'"><xsl:attribute name="checked"></xsl:attribute></xsl:if></input></td>
</tr>
</xsl:template>


<xsl:template match="col[@name='scripts']" mode="edit">
<tr id="tr-{@name}">
<td colspan="2">
<table class="type-2">
<thead>
<tr>
<td>Название модуля</td>
<td class="f33 first">Чтение / просмотр</td>
<td class="f33 first">Редактирование / удаление</td>
</tr>
</thead>
<xsl:apply-templates select="/page/data/fullist/row" mode="fullist">
<xsl:sort select="restriction_id" data-type="number" order="descending"/>
</xsl:apply-templates>
</table>
</td></tr>
</xsl:template>

</xsl:stylesheet>