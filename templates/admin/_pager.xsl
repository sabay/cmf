<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template name="section">
        <xsl:param name="current"/>
        <xsl:param name="pages"/>
        <xsl:param name="count"/>
        <xsl:param name="cur" select="1"/>
        <xsl:if test="$cur &lt;= $pages">
                <xsl:choose>
                        <xsl:when test="$cur != $current">
                                <xsl:variable name="url"><xsl:call-template name="section_url"><xsl:with-param name="cur" select="$cur"/></xsl:call-template><xsl:call-template name="url-collector"><xsl:with-param name="add-p" select="0"/><xsl:with-param name="add-count" select="0"/><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:variable>
                                <li><a href="{$url}&amp;p={$cur}&amp;count={$count}"><xsl:value-of select="$cur"/></a></li>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:variable name="url"><xsl:call-template name="section_url"><xsl:with-param name="cur" select="$cur"/></xsl:call-template><xsl:call-template name="url-collector"><xsl:with-param name="add-p" select="0"/><xsl:with-param name="add-count" select="0"/><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:variable>
                                <li class="active"><a href="{$url}&amp;p={$cur}&amp;count={$count}"><xsl:value-of select="$cur"/></a></li>
                        </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="section">
                        <xsl:with-param name="cur" select="$cur+1"/>
                        <xsl:with-param name="current" select="$current"/>
                        <xsl:with-param name="pages" select="$pages"/>
                        <xsl:with-param name="count" select="$count"/>
                </xsl:call-template>
        </xsl:if>
</xsl:template>

<xsl:template match="pager">
<xsl:param name="page-size" select="0"/>
<xsl:variable name="pages"><xsl:choose>
    <xsl:when test="number(@pcount) &lt;= 11">
            <xsl:value-of select="number(@pcount)"/>
    </xsl:when>
    <xsl:when test="(number(@page) + 5) &lt; number(@pcount) and (number(@page) + 5) &lt;= 11">
            <xsl:value-of select="11"/>
    </xsl:when>
    <xsl:when test="(number(@page) + 5) &lt; number(@pcount)">
            <xsl:value-of select="number(@page) + 5"/>
    </xsl:when>
    <xsl:otherwise>
            <xsl:value-of select="number(@pcount)"/>
    </xsl:otherwise>
</xsl:choose></xsl:variable>
<xsl:variable name="start_number"><xsl:choose>
    <xsl:when test="number(@pcount) &lt;= 11">
            <xsl:value-of select="1"/>
    </xsl:when>
    <xsl:when test="(number(@page) - 5) &lt; 1">
            <xsl:value-of select="1"/>
    </xsl:when>
    <xsl:when test="(number(@pcount) - (number(@page) - 5)) &lt; 10">
            <xsl:value-of select="number(@pcount) - 10"/>
    </xsl:when>
    <xsl:otherwise>
            <xsl:value-of select="number(@page) - 5"/>
    </xsl:otherwise>
</xsl:choose></xsl:variable>
<xsl:if test="@pcount &gt; 1">
        <xsl:choose>
                <xsl:when test="@pcount &gt; 1">
                        <div class="pager">
                        <xsl:if test="@page &gt; 1">
                                <xsl:variable name="url"><xsl:call-template name="section_url"><xsl:with-param name="cur" select="@page-1"/></xsl:call-template><xsl:call-template name="url-collector"><xsl:with-param name="add-p" select="0"/><xsl:with-param name="add-count" select="0"/><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:variable>
					<div class="page-back">
	                                <a href="{$url}&amp;p={number(@page)-1}&amp;count={@count}">Ранее</a>
					</div>
                        </xsl:if>
<ul>
                        <xsl:if test="number(@pcount) &gt; 11 and $start_number &gt; 1">
                                <li><a><xsl:attribute name="href">
                                      <xsl:variable name="prev_number"><xsl:value-of select="$start_number - 1"/></xsl:variable>
                                      <xsl:variable name="url"><xsl:call-template name="section_url"><xsl:with-param name="cur" select="$prev_number"/></xsl:call-template><xsl:call-template name="url-collector"><xsl:with-param name="add-p" select="0"/><xsl:with-param name="add-count" select="0"/><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:variable>
                                      <xsl:value-of select="$url"/>&amp;p=<xsl:value-of select="$prev_number"/>&amp;pcount=<xsl:value-of select="@pcount"/>&amp;count=<xsl:value-of select="@count"/><xsl:if test="@psize &gt; 0">&amp;psize=<xsl:value-of select="@psize"/></xsl:if>
                                    </xsl:attribute>...</a></li>
                        </xsl:if>

                        <xsl:call-template name="section">
                                <xsl:with-param name="current" select="@page"/>
                                <xsl:with-param name="pages" select="$pages"/>
                                <xsl:with-param name="count" select="@count"/>
                                <xsl:with-param name="cur" select="$start_number"/>
                        </xsl:call-template>

                        <xsl:if test="number(@pcount) &gt; 11 and $pages &lt; number(@pcount)">
                                <li><a><xsl:attribute name="href">
                                      <xsl:variable name="next_number"><xsl:value-of select="$pages + 1"/></xsl:variable>
                                      <xsl:variable name="url"><xsl:call-template name="section_url"><xsl:with-param name="cur" select="$next_number"/></xsl:call-template><xsl:call-template name="url-collector"><xsl:with-param name="add-p" select="0"/><xsl:with-param name="add-count" select="0"/><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:variable>
                                      <xsl:value-of select="$url"/>&amp;p=<xsl:value-of select="$next_number"/>&amp;pcount=<xsl:value-of select="@pcount"/>&amp;count=<xsl:value-of select="@count"/><xsl:if test="@psize &gt; 0">&amp;psize=<xsl:value-of select="@psize"/></xsl:if>
                                    </xsl:attribute>...</a></li>
                        </xsl:if>
</ul>
                        <xsl:if test="@page &lt; @pcount">
                                <xsl:variable name="url"><xsl:call-template name="section_url"><xsl:with-param name="cur" select="@page+1"/></xsl:call-template><xsl:call-template name="url-collector"><xsl:with-param name="add-p" select="0"/><xsl:with-param name="add-count" select="0"/><xsl:with-param name="add-s" select="0"/><xsl:with-param name="add-pagesize" select="0"/></xsl:call-template></xsl:variable>
					<div class="page-forward">
	                                <a href="{$url}&amp;p={@page+1}&amp;count={@count}">Вперед</a>
					</div>
                        </xsl:if>

                        </div>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
</xsl:if>

<!--<xsl:if test="$page-size = 1 and /page/data/@popup != 'mpopup'">-->
<xsl:if test="$page-size = 1">
	<xsl:variable name="temp_count">10</xsl:variable>
				<div class="view-props">
					<div class="items-on-page">
						<label for="id-123">Количество записей на странице:</label>
						<select class="f41" id="id-123" name="pagesize"><xsl:attribute name="onchange">$('#id-form').attr({'action':'/site/admin/<xsl:value-of select="/page/data/name"/>/pagesize/'});this.form.submit();</xsl:attribute>
<xsl:call-template name="pagesize_k">
	<xsl:with-param name="temp_count_k" select="$temp_count"/>
</xsl:call-template>
						</select>
					</div>
	<xsl:if test="@pcount &gt; 1">
					<div class="go-to-page">
						<label for="id-124">Перейти на страницу:</label>
						<span class="input-txt"><input id="id-124" type="text" name="_p" class="txt f33"/></span>
						<input type="hidden" name="count" value="{@count}"/>
						<a href="#"><xsl:attribute name="onclick">$("input[name='p']").val($('#id-124').val());$('#id-form').submit();return false;</xsl:attribute>Ok</a>
					</div>
	</xsl:if>
				</div>
</xsl:if>
</xsl:template>

<xsl:template name="pagesize_k">
	<xsl:param name="temp_count_k" select="10"/>
	<option value="{$temp_count_k}"><xsl:if test="$temp_count_k = /page/data/@pagesize"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="$temp_count_k"/></option>
	<xsl:choose>
	   <xsl:when test="$temp_count_k &lt; 100">
		<xsl:call-template name="pagesize_k">
			<xsl:with-param name="temp_count_k" select="$temp_count_k + 10"/>
		</xsl:call-template>
	   </xsl:when>
	   <xsl:otherwise>
	   	<xsl:variable name="temp_count_x">5000</xsl:variable>
            <option value="{$temp_count_x}"><xsl:if test="$temp_count_x = /page/data/@pagesize"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="$temp_count_x"/></option>
        <xsl:variable name="temp_count_y">10000</xsl:variable>			
            <option value="{$temp_count_y}"><xsl:if test="$temp_count_y = /page/data/@pagesize"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="$temp_count_y"/></option>		   	
	   </xsl:otherwise>	
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>