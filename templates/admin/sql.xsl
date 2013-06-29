<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main.xsl"/>

<xsl:template match="data">
<h2 class='h2'>SQL - console</h2>
<form action="{/page/root}/admin/sql/" method="POST">
<textarea name="query" rows="5" cols="90" style="width:100%"><xsl:value-of select="query"/></textarea>
<input type="submit" name="e" value="select"/>
<input type="submit" name="e" value="execute"/>
</form>
<br/><hr/><br/>
<xsl:copy-of select="table" disable-output-escaping="yes"/>
</xsl:template>

</xsl:stylesheet>
