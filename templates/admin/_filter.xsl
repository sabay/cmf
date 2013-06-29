<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="option"><xsl:apply-templates/></xsl:template>

<xsl:template match="filt">
					<tr>
						<td class="l15">
							<p class="lbl"><label for="id-{@name}"><xsl:value-of select="name"/></label></p>
						</td>
						<td class="l85">
	<xsl:choose>
		<xsl:when test="visual = 'select'">
							<select id="id-{@name}" class="f185" name="{@name}">
                                <option value="">-- не выбран --</option>
                                <xsl:copy-of select="../values/multioptions/*[name()=current()/@name]/*" />
							</select>
		</xsl:when>
		<xsl:when test="visual = 'text-short' or visual = 'text-like' or visual = 'list'">
							<span class="input-txt"><input type="text" id="id-{@name}" class="txt f277" name="{@name}" value="{../values/*[name()=current()/@name]}"/></span>
		</xsl:when>
		<xsl:when test="visual = 'text-long'">
							<span class="input-txt"><input type="text" id="id-{@name}" class="txt f566" name="{@name}" value="{../values/*[name()=current()/@name]}"/></span>
		</xsl:when>
		<xsl:when test="visual = 'number'">
							<span class="input-txt"><input type="text" id="id-{@name}" class="txt f185" name="{@name}" value="{../values/*[name()=current()/@name]}"/></span>
		</xsl:when>
        <xsl:when test="visual = 'checkbox'">
                            <input type="checkbox" id="id-{@name}" class="check" name="{@name}" value="1"><xsl:if test="../values/*[name()=current()/@name]='1'"><xsl:attribute name="checked"></xsl:attribute></xsl:if></input>
        </xsl:when>
        <xsl:when test="visual = 'calendar'">
            <span class="input-txt">
                <input type="text" name="{@name}" value="{../values/*[name()=current()/@name]}" id="id-{@name}" class="txt f222"/>
            </span>
            <script type="text/javascript">
	            $(document).ready(function(){
	                $("#id-<xsl:value-of select="@name"/>").datepicker({
		                dateFormat: "yy-mm-dd",
			            showStatus: true,
			            showOn: "button",
			            buttonImage: "/i/adm/calendar.gif",
			            buttonImageOnly: true});
		            $('#dialog_link, ul#icons li').hover(
		                function() { $(this).addClass('ui-state-hover'); },
		                function() { $(this).removeClass('ui-state-hover'); }
		            );
		            $("#id-<xsl:value-of select="@name"/>").datepicker($.datepicker.regional['ru']);
	            });
        </script>
        </xsl:when>
	</xsl:choose>
						</td>
					</tr>
</xsl:template>


<xsl:template match="filter">
    <xsl:variable name="fid"><xsl:apply-templates select="/page/menu[sel=1]" mode='filter'/></xsl:variable>
    <xsl:if test="filt[visual='calendar']">	   
        <link type="text/css" href="/css/adm/smoothness/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
        <script src="/js/adm/jquery-ui.js"></script>
        <script src="/js/adm/ui.datepicker-ru.js"></script>
    </xsl:if>
<form class="specific" action="/site/admin/{/page/data/name}/filter/" method="POST" ENCTYPE="multipart/form-data" id="id-form-filter">
	<input type="submit" name="_submit" style="display:none;"/>
	<table class="type-1">
<thead>
				<tr>
					<td colspan="2"><h2 id="id-filter-title"><xsl:attribute name="class"><xsl:apply-templates select="/page/head/profile/Estates/Estate[Esection='filter'][id=$fid]" mode="filter-title"/></xsl:attribute>
						<a href="#"><xsl:attribute name="onclick">filterCollapse(<xsl:apply-templates select="/page/menu[sel=1]" mode='filter'/>); return false;</xsl:attribute><span>Фильтры</span></a></h2></td>
				</tr>
</thead>

<tbody id="id-filter-body"><xsl:attribute name="style"><xsl:apply-templates select="/page/head/profile/Estates/Estate[Esection='filter'][id=$fid]" mode="filter"/></xsl:attribute>
					<xsl:apply-templates select="filt"/>

					<tr>
						<td class="l15">
							
						</td>
						<td class="l85">
							<div class="neutral">
								<a href="#" onclick="$('#id-form-filter').submit(); return false;">Отфильтровать</a> <span class="inverse-interact after-button"  onclick="location='/site/admin/{/page/data/name}/clearfilter/';">Сбросить фильтр</span>
							</div>
						</td>
					</tr>
</tbody>
</table>
</form><br/>
</xsl:template>

<xsl:template match="filter" mode="popup">
<h1>Фильтры</h1>
<form action="/site/admin/{/page/data/name}/filter/" method="POST" ENCTYPE="multipart/form-data" id="id-form-filter" class="regular">
	<input type="submit" name="_submit" style="display:none;"/>	
	<table class="type-1">
					<xsl:apply-templates select="filt"/>
					<tr>
						<td class="l15">
							
						</td>
						<td class="l85">
							<div class="neutral">
								<a href="#" onclick="$('#id-form-filter').submit();">Отфильтровать</a> <span class="inverse-interact after-button"  onclick="location='/site/admin/{/page/data/name}/clearfilter/';">Сбросить фильтр</span>
							</div>
						</td>
					</tr>
	</table>
	</form>
</xsl:template>


</xsl:stylesheet>