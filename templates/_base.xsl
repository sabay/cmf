<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output encoding="utf-8" method="html"/>

<xsl:template match="text()"><xsl:value-of select="."/></xsl:template>
<xsl:template match="nbsp"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></xsl:template>
<xsl:template match="amp"><xsl:text disable-output-escaping="yes">&amp;amp;</xsl:text></xsl:template>
<xsl:template match="symbol"><xsl:text disable-output-escaping="yes">&amp;</xsl:text><xsl:value-of select="@value"/>;</xsl:template>
<xsl:template match="br"><br/></xsl:template>
<xsl:template match="wbr"><wbr/></xsl:template>
<xsl:template match="b"><b><xsl:apply-templates/></b></xsl:template>
<xsl:template match="i"><i><xsl:apply-templates/></i></xsl:template>
<xsl:template match="u"><u><xsl:apply-templates/></u></xsl:template>
<xsl:template match="sub"><sub><xsl:apply-templates/></sub></xsl:template>
<xsl:template match="sup"><sup><xsl:apply-templates/></sup></xsl:template>
<xsl:template match="nobr"><nobr><xsl:apply-templates/></nobr></xsl:template>
<xsl:template match="link|a"><a href="{@href}"><xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if><xsl:apply-templates/></a></xsl:template>
<xsl:template match="link[@target]"><a href="{@href}" target="{@target}"><xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if><xsl:apply-templates/></a></xsl:template>
<xsl:template match="pop_link"><a href="#" onclick="return win_popup('{@href}',{@width},{@height});"><xsl:apply-templates/></a></xsl:template>
<xsl:template match="span"><span><xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if><xsl:if test="@style"><xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute></xsl:if><xsl:apply-templates/></span></xsl:template>
<xsl:template match="small"><small><xsl:apply-templates/></small></xsl:template>
<xsl:template match="p"><div align="justify"><xsl:apply-templates/></div><br/></xsl:template>
<xsl:template match="p[@align]"><div align="{@align}"><xsl:apply-templates/></div><xsl:if test="position()!=last()"><br/></xsl:if></xsl:template>
<xsl:template match="binary"><xsl:copy-of select="."/></xsl:template>
<xsl:template match="binary[@html]"><xsl:value-of select="." disable-output-escaping="yes"/></xsl:template>
<xsl:template match="ancor"><a name="{@name}"></a></xsl:template>
<xsl:template match="hidden"><input type="hidden" name="{@name}" value="{@value}"/></xsl:template>
<xsl:template match="copy">&#169;</xsl:template>

<xsl:template match="ul"><ul class="u"><xsl:apply-templates/></ul></xsl:template>
<xsl:template match="ul[@type]"><ul type="{@type}"><xsl:apply-templates/></ul></xsl:template>
<xsl:template match="ol"><ol><xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if><xsl:if test="@start"><xsl:attribute name="start"><xsl:value-of select="@start"/></xsl:attribute></xsl:if><xsl:apply-templates/></ol></xsl:template>

<xsl:template match="li"><li><xsl:apply-templates/></li></xsl:template>
<xsl:template match="dl"><dl><xsl:apply-templates/></dl></xsl:template>

<xsl:template match="bull"><img src="imgs/btn-more-b.gif" width="12" height="8" border="0" hspace="5" alt=""/></xsl:template>
<xsl:template match="head"><div class="larger bold"><xsl:apply-templates/></div></xsl:template>

<xsl:template match="table">
<table border="0" cellspacing="1" cellpadding="5" style="clear:left;" bgcolor="#FFFFFF">
<xsl:if test="@cellspacing"><xsl:attribute name="cellspacing"><xsl:value-of select="@cellspacing"/></xsl:attribute></xsl:if>
<xsl:if test="@cellpadding"><xsl:attribute name="cellpadding"><xsl:value-of select="@cellpadding"/></xsl:attribute></xsl:if>
<xsl:if test="@border=0"><xsl:attribute name="cellspacing">0</xsl:attribute></xsl:if>
<xsl:if test="@border"><xsl:attribute name="border"><xsl:value-of select="@border"/></xsl:attribute></xsl:if>
<xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
<xsl:if test="@transparent"><xsl:attribute name="bgcolor"><xsl:value-of select="@bgcolor"/></xsl:attribute></xsl:if>
<xsl:if test="@align"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
<xsl:if test="@width"><xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute></xsl:if>
<xsl:if test="not(@align)"><xsl:attribute name="width">100%</xsl:attribute></xsl:if>
<xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="th">
<td>
<xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute></xsl:if>
<xsl:if test="@rowspan"><xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute></xsl:if>
<xsl:if test="@align"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
<xsl:if test="@valign"><xsl:attribute name="valign"><xsl:value-of select="@valign"/></xsl:attribute></xsl:if>
<b><xsl:apply-templates/></b>
</td></xsl:template>

<xsl:template match="tr">
<tr>
<xsl:if test="@bgcolor"><xsl:attribute name="bgcolor"><xsl:value-of select="@bgcolor"/></xsl:attribute></xsl:if>
<xsl:if test="@align"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
<xsl:if test="@valign"><xsl:attribute name="valign"><xsl:value-of select="@valign"/></xsl:attribute></xsl:if>
<xsl:apply-templates select="td|th"/>
</tr>
</xsl:template>

<xsl:template match="td">
<td>
<xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute></xsl:if>
<xsl:if test="@rowspan"><xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute></xsl:if>
<xsl:if test="@align"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
<xsl:if test="@width"><xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute></xsl:if>
<xsl:if test="@valign"><xsl:attribute name="valign"><xsl:value-of select="@valign"/></xsl:attribute></xsl:if>
<xsl:apply-templates/>
</td>
</xsl:template>

<xsl:template match="picture">
<table width="{@width}" border="0" CELLSPACING="0" CELLPADDING="0">
<xsl:if test="@valign!=''"><xsl:attribute name="valign"><xsl:value-of select="@valign"/></xsl:attribute></xsl:if>
<xsl:if test="@align!=''"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
<tr>
<xsl:if test="@align='right'"><td><img src="/i/{/page/update_id}/0.gif" width="10" height="1"/><br/></td></xsl:if>
<td><xsl:if test="@palign"><xsl:attribute name="align"><xsl:value-of select="@palign"/></xsl:attribute></xsl:if>
<xsl:choose>
<xsl:when test="@zoom = 'yes'">
<a href="#">
<xsl:attribute name="onclick">zoom('<xsl:value-of select="@src1"/>');return false;</xsl:attribute>
<img src="/images{@src}" width="{@width}" height="{@height}" border="0"></img></a>
</xsl:when>
<xsl:otherwise>
<img src="/images{@src}" width="{@width}" height="{@height}" border="0"></img>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="@align='left'"><td><img src="/i/{/page/update_id}/0.gif" width="10" height="1"/><br/></td></xsl:if>
</td>
</tr>
<xsl:if test="*|text()"><tr><td class="texttitle_h4"><br/><xsl:apply-templates /></td></tr></xsl:if>
<tr><td><img src="" width="1" height="5"/><br/></td></tr>
</table>
</xsl:template>

<xsl:template match="img">
<table width="{@width}" border="0" CELLSPACING="0" CELLPADDING="0">
<xsl:if test="@valign!=''"><xsl:attribute name="valign"><xsl:value-of select="@valign"/></xsl:attribute></xsl:if>
<xsl:if test="@align!=''"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
<tr>
<xsl:if test="@align='right'"><td><img src="/i/{/page/update_id}/0.gif" width="10" height="1"/><br/></td></xsl:if>
<td><xsl:if test="@palign"><xsl:attribute name="align"><xsl:value-of select="@palign"/></xsl:attribute></xsl:if>
<xsl:choose>
<xsl:when test="@zoom = 'yes'">
<a href="#">
<xsl:attribute name="onclick">zoom('<xsl:value-of select="@src1"/>');return false;</xsl:attribute>
<img src="{@src}" width="{@width}" height="{@height}" border="0"></img></a>
</xsl:when>
<xsl:otherwise>
<img src="{@src}" width="{@width}" height="{@height}" border="0"></img>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="@align='left'"><td><img src="/i/{/page/update_id}/0.gif" width="10" height="1"/><br/></td></xsl:if>
</td>
</tr>
<xsl:if test="*|text()"><tr><td class="texttitle_h4"><br/><xsl:apply-templates /></td></tr></xsl:if>
<tr><td><img src="" width="1" height="5"/><br/></td></tr>
</table>
</xsl:template>


<xsl:template match="picture[@border]">
<table width="{@width}" border="0" align="left" cellpadding="0" cellspacing="0">
<xsl:if test="@align!=''"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
<tr><xsl:if test="@align='right'"><td><img src="/i/{/page/update_id}/0.gif" width="10" height="1"/><br/></td></xsl:if>
<td>
<table width="{@width}" border="0" cellpadding="2" cellspacing="1" bgcolor="#646464">
<tr>
<td bgcolor="#000000"><xsl:if test="@palign"><xsl:attribute name="align"><xsl:value-of select="@palign"/></xsl:attribute></xsl:if>
<xsl:choose>
<xsl:when test="@zoom = 'yes'">
<a href="#">
<xsl:attribute name="onclick">zoom('{@src1}');return false;</xsl:attribute>
<img src="/images{@src}" width="{@width}" height="{@height}" border="0"></img></a>
</xsl:when>
<xsl:otherwise>
<img src="/images{@src}" width="{@width}" height="{@height}" border="0"></img>
</xsl:otherwise>
</xsl:choose>
</td></tr></table>
<xsl:if test="*|text()"><tr><td class="texttitle_h4"><xsl:apply-templates /></td></tr></xsl:if>
</td>
<xsl:if test="@align='left'"><td><img src="/i/{/page/update_id}/0.gif" width="10" height="1"/><br/></td></xsl:if>
</tr>
<tr><td colspan="2"><img src="/i/{/page/update_id}/0.gif" width="1" height="10" /></td></tr>
</table>
</xsl:template>

<xsl:template match="picture[@href]">
<a href="{@href}"><xsl:if test="@target"><xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute></xsl:if>
<img src="/images/{@src}" width="{@width}" height="{@height}" border="0"><xsl:if test="@align"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if></img></a>
</xsl:template>


<xsl:template match="footnote">
  <xsl:variable name="id">
	<xsl:number level="any" count="footnote"/>
  </xsl:variable>
  <img src="/i/{/page/update_id}/0.gif" width="1" height="1" id="ti_{$id}"/>
  <xsl:text disable-output-escaping="yes">&lt;</xsl:text>a href='#' class='footnote'
	onclick='return showBk(<xsl:value-of select="$id"/>, <xsl:text disable-output-escaping="yes">"</xsl:text><xsl:apply-templates select="title"/><xsl:text disable-output-escaping="yes">"</xsl:text>)'<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
	<u><xsl:apply-templates select="text"/></u>
	<sup>
	  <xsl:apply-templates select="@id"/>
	</sup>
  <xsl:text disable-output-escaping="yes">&lt;</xsl:text>/a<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>


<xsl:template name="section">
	<xsl:param name="current"/>
	<xsl:param name="pages"/>
	<xsl:param name="cur" select="1"/>
	<xsl:if test="$cur &lt;= $pages">
		<xsl:choose>
			<xsl:when test="$cur != $current">
				<xsl:variable name="url"><xsl:call-template name="section_url"><xsl:with-param name="cur" select="$cur"/></xsl:call-template></xsl:variable>
					<li>
						<div class="pas cr-lt"><div class="cr-rt"><div class="cr-rb"><div class="cr-lb">
							<a onclick="{/page/data/link_on_click}" href="{$url}&amp;page={$cur}&amp;pcount={pcount}&amp;count={count}"><xsl:value-of select="$cur"/></a>
						</div></div></div></div>
					</li>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<div class="act cr-lt"><div class="cr-rt"><div class="cr-rb"><div class="cr-lb">
						<strong><xsl:value-of select="$cur"/></strong>
					</div></div></div></div>
				</li>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="section">
			<xsl:with-param name="cur" select="$cur+1"/>
			<xsl:with-param name="current" select="$current"/>
			<xsl:with-param name="pages" select="$pages"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template match="section">
	<xsl:param name="txt">Страницы</xsl:param>
	<xsl:param name="colspan"/>
	<xsl:param name="style"/>
	<xsl:variable name="pages"><xsl:choose>
		<xsl:when test="number(pcount) &lt;= 8">
			<xsl:value-of select="number(pcount)"/>
		</xsl:when>
		<xsl:when test="(number(page) + 4) &lt; number(pcount) and (number(page) + 4) &lt;=8">
			<xsl:value-of select="8"/>
		</xsl:when>
		<xsl:when test="(number(page) + 4) &lt; number(pcount)">
			<xsl:value-of select="number(page) + 4"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="number(pcount)"/>
		</xsl:otherwise>
	</xsl:choose></xsl:variable>
	<xsl:variable name="start_number"><xsl:choose>
		<xsl:when test="number(pcount) &lt;= 8">
			<xsl:value-of select="1"/>
		</xsl:when>
		<xsl:when test="(number(page) - 4) &lt; 1">
			<xsl:value-of select="1"/>
		</xsl:when>
		<xsl:when test="(number(pcount) - (number(page) - 4)) &lt; 8">
			<xsl:value-of select="number(pcount) - 8"/>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="number(page) - 4"/></xsl:otherwise>
	</xsl:choose></xsl:variable>
	<xsl:if test="count &gt; 20">
		<div class="page-menu">
			<xsl:if test="pcount &gt; 1">
				<xsl:if test="page &gt; 1">
					<xsl:variable name="url"><xsl:call-template name="section_url"><xsl:with-param name="cur" select="page-1"/></xsl:call-template></xsl:variable>
					<p><a onclick="{link_on_click}" href="{$url}&amp;page={number(page)-1}&amp;pcount={pcount}&amp;count={count}&amp;psize={psize}">Предыдущая страница</a></p>
				</xsl:if>
				<ul>
					<xsl:if test="number(pcount) &gt; 11 and $start_number &gt; 1">
						<li>
							<div class="pas cr-lt"><div class="cr-rt"><div class="cr-rb"><div class="cr-lb">
								<a onclick="{/page/data/link_on_click}"><xsl:attribute name="href">
									<xsl:variable name="prev_number">
										<xsl:value-of select="$start_number - 1"/>
									</xsl:variable>
									<xsl:variable name="url">
										<xsl:call-template name="section_url">
											<xsl:with-param name="cur" select="$prev_number"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$url"/>&amp;page=<xsl:value-of select="$prev_number"/>&amp;pcount=<xsl:value-of select="pcount"/>&amp;count=<xsl:value-of select="count"/><xsl:if test="psize &gt; 0">&amp;psize=<xsl:value-of select="psize"/></xsl:if>
								</xsl:attribute>...</a>
							</div></div></div></div>
						</li>
					</xsl:if>
					<xsl:call-template name="section">
						<xsl:with-param name="current" select="page"/>
						<xsl:with-param name="pages" select="$pages"/>
						<xsl:with-param name="cur" select="$start_number"/>
					</xsl:call-template>
					<xsl:if test="number(pcount) &gt; 11 and $pages &lt; number(pcount)">
						<li>
							<div class="pas cr-lt"><div class="cr-rt"><div class="cr-rb"><div class="cr-lb">
								<a onclick="{/page/data/link_on_click}"><xsl:attribute name="href">
									<xsl:variable name="next_number">
										<xsl:value-of select="$pages + 1"/>
									</xsl:variable>
									<xsl:variable name="url">
										<xsl:call-template name="section_url">
											<xsl:with-param name="cur" select="$next_number"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$url"/>&amp;page=<xsl:value-of select="$next_number"/>&amp;pcount=<xsl:value-of select="pcount"/>&amp;count=<xsl:value-of select="count"/><xsl:if test="psize &gt; 0">&amp;psize=<xsl:value-of select="psize"/></xsl:if>
								</xsl:attribute>...</a>
							</div></div></div></div>
						</li>
					</xsl:if>
				</ul>
				<xsl:if test="page &lt; pcount">
					<xsl:variable name="url">
						<xsl:call-template name="section_url">
							<xsl:with-param name="cur" select="page+1"/>
						</xsl:call-template>
					</xsl:variable>
					<p><a onclick="{/page/data/link_on_click}" href="{$url}&amp;page={page+1}&amp;pcount={pcount}&amp;count={count}&amp;psize={psize}">Следующая страница</a></p>
				</xsl:if>
				<p class="rt">Показаны <xsl:value-of select="psize*page - psize + 1" />-<xsl:choose>
						<xsl:when test="psize*page &lt; count"><xsl:value-of select="psize*page" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="count" /></xsl:otherwise>
					</xsl:choose> из <xsl:value-of select="count" /></p>
			</xsl:if>
			<script type="text/javascript" src="/js/jquery.cookie.js" />
			<p class="rt">Количество записей на странице: <select id="pp">
				<xsl:attribute name="onchange">$.cookie('<xsl:value-of select="script" />_pp', this.value); if (typeof apply_filter != 'undefined') { newHref = apply_filter(true); if (newHref != window.location.href) window.location.href = '?' + newHref; else window.location.reload();} else document.location = '<xsl:call-template name="section_url"><xsl:with-param name="cur" select="1"/></xsl:call-template>'</xsl:attribute>
				<option value="20"><xsl:if test="psize = '20'"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>20</option>
				<xsl:if test="count &gt; 50">
					<option value="50"><xsl:if test="psize = '50'"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>50</option>
				</xsl:if>
				<xsl:if test="count &gt; 100">
					<option value="100"><xsl:if test="psize = '100'"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>100</option>
				</xsl:if>
				<xsl:if test="count &gt; 1000">
					<option value="1000"><xsl:if test="psize = '1000'"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>1000</option>
				</xsl:if>
				<option value="all"><xsl:if test="psize = 'all'"><xsl:attribute name="selected">true</xsl:attribute></xsl:if>Все</option>
			</select></p>  
		</div>
	</xsl:if>
</xsl:template>


<xsl:template name="section_url">
  <xsl:param name="cur" select="1"/>
</xsl:template>

<xsl:template match="otvet">
<p>
<xsl:choose>
	<xsl:when test="/page/vopros/@is_mult=1"><input type="checkbox" name="otv" value="{@id}" id="opinion_{@id}"/></xsl:when>
	<xsl:otherwise><input type="radio" name="otv" value="{@id}" id="opinion_{@id}" /></xsl:otherwise>
</xsl:choose>&#160;<label for="opinion_{@id}"><xsl:apply-templates/></label>
<xsl:if test="@is_comm=1"><br/><input type="text" name="T_{@id}" size="10" style="width:100%"/></xsl:if>
</p>
</xsl:template>

<xsl:template match="/page/vopros">
<table class="head" cellspacing="0" cellpadding="0">
<tr>
	<td id="first"><img src="/i/{/page/update_id}/bluebox.gif" style="width:16px; height:15px;" /></td>
	<td id="last">ГОЛОСОВАНИЕ</td>
</tr>
</table>


<table id="voting">
<form action="/vote.plx" method="POST"><input type="hidden" name="vid" value="{@id}"/>
<tr>
	<td>
	<span class="quest"><xsl:apply-templates select="name"/></span>
	<xsl:apply-templates select="otvet"/>
	<br/>
	<div align="center"><input type="image" src="/i/{/page/update_id}/vote.gif" alt="Голосовать"/><br/>
	<a href="/result/all/">Результаты опросов</a></div>
	</td>
</tr>
</form>
</table>
</xsl:template>


<xsl:template match="option" mode="radio">
<td><input type="radio" name="s_attr_{../@id}" id="s_attr_{../@id}_{@value}" value="{@value}" onclick="if(this.checked)this.form.kamers.value=this.value;"/>&#160;<label for="s_attr_{../@id}_{@value}"><xsl:apply-templates/></label></td>
</xsl:template>

<xsl:template match="s_attr">
<xsl:for-each select="option[position() mod 2=1]">
<tr><xsl:apply-templates select=".|following-sibling::option[1]" mode="radio"/></tr>
</xsl:for-each>
</xsl:template>

<xsl:template match="menu" mode="topmenu">
<td><a href="/doc/{@id}/" class="LinkWhite"><xsl:choose>
<xsl:when test="url!=''"><xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute></xsl:when>
<xsl:when test="path!=''"><xsl:attribute name="href">/doc<xsl:value-of select="path"/>/</xsl:attribute></xsl:when>
</xsl:choose><xsl:apply-templates select="name"/></a></td>
<xsl:if test="position()!=last()"><td width="21"><spacer /></td></xsl:if>
</xsl:template>

<xsl:template match="topmenu">
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#990000">
<tr><td width="20" nowrap="nowrap"><spacer /></td><td height="28">
<table border="0" cellspacing="0" cellpadding="0"><tr>
<xsl:apply-templates select="menu" mode="topmenu"/>
</tr></table>
</td><td width="20" nowrap="nowrap"><spacer /></td></tr>
</table>
</xsl:template>



<xsl:template match="cat[@nodef='1']" mode="lsubmenu">
<tr>
<td width="11" height="30"></td>
<td><a href="/cato/{@id}/"><xsl:choose>
<xsl:when test="url!=''"><xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute></xsl:when>
<xsl:when test="path!=''"><xsl:attribute name="href">/cato<xsl:value-of select="path"/>/</xsl:attribute></xsl:when>
</xsl:choose><xsl:apply-templates select="name"/></a></td>
</tr>
</xsl:template>

<xsl:template match="cat" mode="lsubmenu">
<tr>
<td width="11" height="30"></td>
<td><a href="/cat/{@id}/"><xsl:choose>
<xsl:when test="url!=''"><xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute></xsl:when>
<xsl:when test="path!=''"><xsl:attribute name="href">/cat<xsl:value-of select="path"/>/</xsl:attribute></xsl:when>
</xsl:choose><xsl:apply-templates select="name"/></a></td>
</tr>
</xsl:template>

<xsl:template match="cat[@sel='1']" mode="lsubmenu">
<tr>
<td width="11" height="30"></td>
<td><b><xsl:apply-templates select="name"/></b></td>
</tr>
</xsl:template>

<xsl:template match="cat[@nodef='1']" mode="leftmenu">
<tr>
<td width="11" height="20"><img src="/i/{/page/update_id}/ico_arrow2.gif" width="9" height="5"/></td>
<td><a href="/cato/{@id}/"><xsl:choose>
<xsl:when test="url!=''"><xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute></xsl:when>
<xsl:when test="path!=''"><xsl:attribute name="href">/cato<xsl:value-of select="path"/>/</xsl:attribute></xsl:when>
</xsl:choose><xsl:apply-templates select="name"/></a></td>
</tr>
</xsl:template>

<xsl:template match="cat" mode="leftmenu">
<tr>
<td width="11" height="20"><img src="/i/{/page/update_id}/ico_arrow2.gif" width="9" height="5"/></td>
<td><a href="/cat/{@id}/"><xsl:choose>
<xsl:when test="url!=''"><xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute></xsl:when>
<xsl:when test="path!=''"><xsl:attribute name="href">/cat<xsl:value-of select="path"/>/</xsl:attribute></xsl:when>
</xsl:choose><xsl:apply-templates select="name"/></a></td>
</tr>
</xsl:template>

<xsl:template match="cat[@sel='1']" mode="leftmenu">
<tr>
<td width="11" height="20"><img src="/i/{/page/update_id}/ico_arrow2.gif" width="9" height="5"/></td>
<td><b><xsl:apply-templates select="name"/></b></td>
</tr>
<xsl:apply-templates select="cat" mode="lsubmenu"/>
</xsl:template>

<xsl:template match="cat" mode="root">
<tr><td colspan="2" bgcolor="#dddddd"><b><xsl:apply-templates select="name"/></b></td></tr>
<xsl:apply-templates select="cat" mode="leftmenu"/>
</xsl:template>

<xsl:template match="leftmenu">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="cat" style="padding-left:5px;">
<xsl:apply-templates select="/page/cat" mode="root"/>
</table>
</xsl:template>

<xsl:template match="*" mode="spaced_int">
	<xsl:if test=". &gt;= 1000 or . &lt;= -1000">
		<xsl:attribute name="class">nbr</xsl:attribute>
	</xsl:if>
	<xsl:value-of select="format-number(., '### ###', 'spaced')"/>
</xsl:template>

<xsl:template match="*" mode="spaced_float">
	<xsl:if test=". &gt;= 1000 or . &lt;= -1000">
		<xsl:attribute name="class">nbr</xsl:attribute>
	</xsl:if>
	<xsl:value-of select="format-number(., '### ##0,00', 'spaced')"/>
</xsl:template>

</xsl:stylesheet>
