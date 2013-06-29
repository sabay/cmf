<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="../new.xsl"/>


<xsl:template match="row">
	<dl>
	   <xsl:if test="type = '3'">
	       <xsl:attribute name="style">background-color: #e4ecf6; font-size: 0.7em;</xsl:attribute>
	   </xsl:if>
	   <input type="checkbox" name="cid[]" value="{@id}">
	       <xsl:if test="@chk = 1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	   </input>
	   <xsl:apply-templates select="name"/>
	</dl>
	<ul><xsl:apply-templates select="row"/></ul>
</xsl:template>

<xsl:template match="rows">
<xsl:apply-templates select="row"/>
</xsl:template>


<xsl:template match="col[@name='scripts']" mode="edit">
<tr id="tr-{@name}">
<td>&#160;</td>
<td><xsl:apply-templates select="/page/data/scripttree/rows"/></td>
</tr>
</xsl:template>


</xsl:stylesheet>