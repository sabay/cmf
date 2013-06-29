<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main.xsl"/>
<xsl:include href="_filter.xsl"/>

<xsl:template match="*" mode="head">
<td><xsl:if test="position() = 1"><xsl:attribute name="class">f33 first</xsl:attribute></xsl:if><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="*" mode="col">
<td><xsl:if test="position() = 1"><xsl:attribute name="class">first</xsl:attribute></xsl:if><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="*[2]" mode="col">
<td class="expanded">
<xsl:choose>
    <xsl:when test="../@level = 0"><xsl:attribute name="class">expanded</xsl:attribute></xsl:when>
    <xsl:when test="../@level != 0 and ../@openleaf=1 and ../row/@openleaf=1"><xsl:attribute name="class">expanded level<xsl:value-of select="../@level"/></xsl:attribute></xsl:when>
    <xsl:when test="../@level != 0 and ../@lastnode=0"><xsl:attribute name="class">collapsed level<xsl:value-of select="../@level"/></xsl:attribute></xsl:when>
    <xsl:when test="../@level != 0 and ../@lastnode=1"><xsl:attribute name="class">expanded level<xsl:value-of select="../@level"/></xsl:attribute></xsl:when>
</xsl:choose>
<a href="{/page/root}/admin/{/page/data/name}/edit/?id={../@id}" class="b{../@rstate}">
<xsl:if test="../@level != 0 and ../@lastnode=0"><xsl:attribute name="onclick">return treeO(<xsl:value-of select="../@id"/>,<xsl:value-of select="../@level"/>,this);</xsl:attribute></xsl:if>
<xsl:apply-templates/></a></td>
</xsl:template>

<xsl:template name="row_style" />

<xsl:template match="row">
    <tr id="tr{@id}"><xsl:if test="@rstate!='1'"><xsl:attribute name="class">inactive</xsl:attribute></xsl:if>
        <xsl:attribute name="style">
            <xsl:call-template name="row_style" />
            <xsl:if test="@level &gt; 1 and not(@openleaf)">display:none;</xsl:if>
        </xsl:attribute>
        <xsl:apply-templates select="*[name()!='row']" mode="col"></xsl:apply-templates>
        <td nowrap="" >
            <a href="{/page/root}/admin/{/page/data/name}/new/?pid={@id}"><img src="{/page/root}/i/adm/i/add.gif" border="0" title="Добавить" hspace="5"/></a>
            <a href="{/page/root}/admin/{/page/data/name}/up/?id={@id}"><img src="{/page/root}/i/adm/i/up.gif" border="0" title="Вверх" hspace="5"/></a>
            <a href="{/page/root}/admin/{/page/data/name}/dn/?id={@id}"><img src="{/page/root}/i/adm/i/dn.gif" border="0" title="Вниз" hspace="5"/></a>
            <a href="#" target="_blank" onclick="return DictPopUp('{/page/root}/admin/{/page/data/name}/showMove/?id={@id}');"><img src="{/page/root}/i/adm/i/move2.gif" border="0" title="Перенести" hspace="5"/></a>
            <a href="{/page/root}/admin/{/page/data/name}/edit/?id={@id}"><img src="{/page/root}/i/adm/i/ed.gif" border="0" title="Изменить" hspace="5"/></a>
            <a href="{/page/root}/admin/{/page/data/name}/vs/?id={@id}"><img src="{/page/root}/i/adm/i/v{1-@rstate}.gif" border="0"/></a> 
            <a href="{/page/root}/admin/{/page/data/name}/del/?id={@id}" onclick="return dl();"><img src="{/page/root}/i/adm/i/del.gif" border="0" title="Удалить" hspace="5"/></a>
        </td>
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
<h1><xsl:apply-templates select="/page/menu[sel=1]" mode='h1'/></h1>
<xsl:apply-templates select="filter"/>
<xsl:apply-templates select="tabs" mode="list"/>

<script>
var A= new Array();
<xsl:apply-templates select="rows/row" mode="A"/>;
var AV = {<xsl:apply-templates select="rows/row" mode="AV"/>};

function moveTree(fromid, toid, win){
  win.close();
  $('#_fromid').val(fromid);
  $('#_toid').val(toid);  
    $('#id-form').attr({'action':'<xsl:value-of select="/page/root"/>/admin/<xsl:value-of select="name"/>/moveTree/'});
    $('#id-form').submit();
  return false;

}

</script>

<form action="{/page/root}/admin/{name}/" method="POST" ENCTYPE="multipart/form-data" name="form-list" id="id-form">
    <input type="hidden" name="fromid" value="" id="_fromid"/>
    <input type="hidden" name="toid" value="" id="_toid"/>  
<table class="type-3">
<thead>
<tr><xsl:apply-templates select="cols/*" mode="head"/><td class="f100"></td></tr>
</thead>
<xsl:apply-templates select="rows/row"/>
</table>
</form>
</xsl:template>

</xsl:stylesheet>