<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main.xsl"/>

<xsl:template match="image">
    <tr>
        <td><img src="{src}" width="60" height="60" /><br /><span style="font:9px tahoma"><xsl:value-of select="key" /></span></td>
        <td><input type="file" style="font:9px tahoma" size="1" name="NOT_P_{key}" accept="image/jpeg" /><br />
        <xsl:if test="val = 'yes'">
            <input type="file" style='font:9px tahoma' size="1" name='NOT_P_{key}_b' accept='image/jpeg' /><br />
        </xsl:if>
        </td>
   </tr>
</xsl:template>

<xsl:template match="data">
    <tr><td style="padding: 0px 0px 0px 15px;">
    <script type="text/javascript" src="/admin/fckeditor/fckeditor.js"></script>
<script type="text/javascript">

window.onload = function()
{
	var oFCKeditor = new FCKeditor( 'xml' ) ;
	oFCKeditor.BasePath	= '/admin/fckeditor/';
	oFCKeditor.Height	= 430 ;

	oFCKeditor.ReplaceTextarea() ;
}

		</script>
    <script type="text/javascript" src="{/page/root}/js/adm/editer.js"></script>
    <form name="MAIN_FORM" action="{/page/root}/admin/editor/save/" method="post" ENCTYPE="multipart/form-data" onsubmit="return checkXML(xml);">
    <table border="0" width="100%" cellspacing="0" cellpadding="3" height="100%">
        <input type="hidden" name="id" value="{id}" />
        <input type="hidden" name="pid" value="{pid}" />
        <input type="hidden" name="sid" value="{sid}" />
        <input type="hidden" name="type" value="{type}" />
        <input type="hidden" name="r" value="{r}" />
        <input type="hidden" name="p" value="{p}" />
        <input type="hidden" name="s" value="{s}" />
        <input type="hidden" name="l" value="{l}" />
        <input type="hidden" name="DO_PREVIEW" value="{DO_PREVIEW}" />
        <tr valign="top">
            <td height="100%"><textarea name="xml" onfocus="_XDOC=this;"  onkeydown="_etaKey(event)" rows="35" cols="10" style="width:600px; height:100%;"><xsl:value-of select="xml" diable-output-escaping="yes" /></textarea></td>
        </tr><tr>
        <td colspan="2"><input id="save" type="submit" name="event" value="Сохранить" class="gbt bsave" />&#160;<button onclick="return doClose();" class="gbt bcancel">Закрыть</button>
                &#160;&#160;<span style='font:bold 8pt tahoma;color:red;'><xsl:value-of select="errormessage" /></span></td>
        </tr>
    </table>
    </form>
    <script LANGUAGE="JavaScript" TYPE="text/javascript">
    if(document.forms.MAIN_FORM.DO_PREVIEW.value=="1"){
        document.forms.MAIN_FORM.DO_PREVIEW.value="0"
        var win=window.open("<xsl:value-of select="view_link" />");
        win.focus();
    }
    function doClose(){
    	//if(confirm("All changes will be LOST!"))
    	window.location="<xsl:value-of select="edit_link" />?id=<xsl:value-of select="id" />";
    	return false;
    }
    </script>
</td></tr>
</xsl:template>

</xsl:stylesheet>
