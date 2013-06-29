<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="toolbarND">
<table class="tools">
		<tbody><tr>
					<td class="f84 first">
						<ul class="system">
<xsl:if test="not(/page/data/@popup) or /page/data/@popup != 'mpopup'">
							<li><a href="#"><xsl:attribute name="onclick">$('#id-form').attr({'action':'/site/admin/<xsl:value-of select="/page/data/name"/>/new/'}); $('#id-form').submit(); return false;</xsl:attribute>
								<img src="/i/adm/tool-new.gif" alt=""/></a></li>
</xsl:if>

	<xsl:if test="/page/data/@input = 'y' and /page/data/@popup = ''">
							<li><a href="#"><xsl:attribute name="onclick">$('#id-form').submit();</xsl:attribute><img src="/i/adm/tool-save.gif" alt=""/></a></li>
	</xsl:if>

						</ul>
					</td>
					<!--td class="f173">
						<ul class="modal" style="visibility: hidden">
							<li><a class="turnon" href="#">Включить</a></li>
							<li><a class="turnoff" href="#">Выключить</a></li>
						</ul>
					</td-->
					<td class="l100">
						<!--ul class="action" style="visibility: hidden">
							<li><a class="move" href="#">Перенести</a></li>
							<li><a class="set-range" href="#">Назначить диапазон</a></li>
						</ul-->
					</td>
				</tr>
		</tbody>
</table>
</xsl:template>

</xsl:stylesheet>