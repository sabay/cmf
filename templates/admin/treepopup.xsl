<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main_simple.xsl"/>
<xsl:include href="_pager.xsl"/>
<xsl:include href="_filter.xsl"/>
<xsl:include href="_toolbar.xsl"/>

<xsl:template match="*" mode="head">
<xsl:if test="position() = 1"><td>#</td></xsl:if><td><xsl:if test="position() = 1"><xsl:attribute name="class">f33 first</xsl:attribute></xsl:if><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="*" mode="col">
	<xsl:param name="show"/>
<xsl:if test="position() = 1"><td><xsl:if test="$show = 'yes'"><input type="radio" name="move[]" value="{../@id}"/></xsl:if></td></xsl:if>
<td><xsl:if test="position() = 1"><xsl:attribute name="class">first</xsl:attribute></xsl:if><xsl:apply-templates><xsl:with-param name="show"><xsl:value-of select="$show"/></xsl:with-param></xsl:apply-templates></td>
</xsl:template>

<xsl:template match="*[2]" mode="col">
    <xsl:param name="show"/>	
<td class="expanded">
<xsl:choose>
	<xsl:when test="../@level = 0"><xsl:attribute name="class">expanded</xsl:attribute></xsl:when>
	<xsl:when test="../@level != 0 and ../@openleaf=1 and ../row/@openleaf=1"><xsl:attribute name="class">expanded level<xsl:value-of select="../@level"/></xsl:attribute></xsl:when>
	<xsl:when test="../@level != 0 and ../@lastnode=0"><xsl:attribute name="class">collapsed level<xsl:value-of select="../@level"/></xsl:attribute></xsl:when>
	<xsl:when test="../@level != 0 and ../@lastnode=1"><xsl:attribute name="class">expanded level<xsl:value-of select="../@level"/></xsl:attribute></xsl:when>
</xsl:choose>
<a href="javascript:void(0)" class="b{../@rstate}">
<xsl:if test="../@level != 0 and ../@lastnode=0"><xsl:attribute name="onclick">return treeO(<xsl:value-of select="../@id"/>,<xsl:value-of select="../@level"/>,this);</xsl:attribute></xsl:if>
<xsl:apply-templates><xsl:with-param name="show"><xsl:value-of select="$show"/></xsl:with-param></xsl:apply-templates></a></td>
</xsl:template>

<xsl:template match="row">
<xsl:variable name="show_radio">
    <xsl:choose>
        <xsl:when test="ancestor-or-self::row/@id = /page/data/@id">no</xsl:when>     
        <xsl:when test="@id = /page/data/@id">no</xsl:when>     
        <xsl:otherwise>yes</xsl:otherwise>
    </xsl:choose>   
</xsl:variable>

<tr id="tr{@id}"><xsl:attribute name="class"><xsl:choose>	
	<xsl:when test="@rstate!='1' and /page/data/@id = @id">inactive warning</xsl:when>
    <xsl:when test="$show_radio = 'no'">inactive warning</xsl:when>	
	</xsl:choose></xsl:attribute>
	<!--xsl:if test="@rstate!='1'"><xsl:attribute name="class">inactive <xsl:if test="/page/data/@id = @id">warning</xsl:if></xsl:attribute></xsl:if-->
<xsl:if test="@level &gt; 1 and not(@openleaf)"><xsl:attribute name="style">display:none</xsl:attribute></xsl:if>
<xsl:apply-templates select="*[name()!='row']" mode="col"><xsl:with-param name="show"><xsl:value-of select="$show_radio"/></xsl:with-param></xsl:apply-templates>
</tr>
<xsl:apply-templates select="row"/>
</xsl:template>

<xsl:template match="row" mode="AV"><xsl:if test="position()!=1">,</xsl:if>'<xsl:value-of select="@id"/>':'<xsl:choose><xsl:when test="row/@openleaf = 1">1</xsl:when><xsl:when test="@lastnode = 1">1</xsl:when><xsl:when test="@level &gt; 0">0</xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose>'
<xsl:apply-templates select="row" mode="AV2"/>
</xsl:template>
<xsl:template match="row" mode="AV2">,'<xsl:value-of select="@id"/>':'<xsl:choose><xsl:when test="row/@openleaf = 1">1</xsl:when><xsl:when test="@lastnode = 1">1</xsl:when><xsl:when test="@level &gt; 0">0</xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose>'<xsl:apply-templates select="row" mode="AV2"/></xsl:template>

<xsl:template match="row" mode="A">
<xsl:if test="row">A[<xsl:value-of select="@id"/>]=[<xsl:apply-templates select="row" mode="A2"/>];
<xsl:if test="@lastnode = 0"><xsl:apply-templates select="row" mode="A"/></xsl:if>
</xsl:if>
</xsl:template>

<xsl:template match="row" mode="A2"><xsl:value-of select="@id"/><xsl:if test="position()!=last()">,</xsl:if></xsl:template>

<xsl:template match="data">
<h1>Перемещение ветки: <xsl:apply-templates select="title" mode='h1'/></h1>
<xsl:apply-templates select="filter"/>
<xsl:apply-templates select="tabs" mode="list"/>

<script>
var A= new Array();
<xsl:apply-templates select="rows/row" mode="A"/>;
var AV = {<xsl:apply-templates select="rows/row" mode="AV"/>};
</script>

<form action="{/page/root}/admin/{name}/" method="POST" ENCTYPE="multipart/form-data" name="form-list" id="id-form">
	
	   <div class="stepdown pos"><a href="#"><xsl:attribute name="onclick">return letsMove();</xsl:attribute>Переместить</a></div><br/>
	
<table class="type-3">
<thead>
<tr><xsl:apply-templates select="cols/*" mode="head"/></tr>
</thead>
<xsl:apply-templates select="rows/row"/>
</table>

    <div class="stepdown pos"><a href="#"><xsl:attribute name="onclick">return letsMove();</xsl:attribute>Переместить</a></div>

</form>
<script>
	function letsMove(){
	   var fromid = <xsl:value-of select="@id"/>;
	   var toid = $('input:checked').val();
	   opener.moveTree(fromid, toid, window);
	   return false;
	}
</script>	
</xsl:template>

</xsl:stylesheet>