<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="_main.xsl"/>

<xsl:template match="data">
	<script type="text/javascript" src="{/page/root}/js/jquery.js"></script>
	<script type="text/javascript" src="{/page/root}/js/jquery.listen.js"></script>
	<div class="registration cr-lt"><div class="cr-rt"><div class="cr-rb"><div class="cr-lb pad">
		<h1>Регистрация</h1>
		<form class="enter" action="{/page/root}/registration/register/" method="post">
			<input type="hidden" name="act" value="register"/>
			<input type="hidden" name="sir" value="{sir}"/>
			<fieldset>
				<div class="necessary">
					<xsl:apply-templates select="errors/error[@name='email']" />
					<p>
						<label><xsl:attribute name="for"><xsl:value-of select="fn_reg_names/email" /></xsl:attribute>E-mail: <sup>*</sup></label>
						<input class="txt" type="text" value="{values/email}" size="256" name="email"><xsl:if test="error[@type='email']"><xsl:attribute name="class">txt important</xsl:attribute></xsl:if></input>
					</p>
					<xsl:apply-templates select="errors/error[@name='password']" />
					<p>
						<label><xsl:attribute name="for"><xsl:value-of select="fn_reg_names/password" /></xsl:attribute>Пароль: <sup>*</sup></label>
						<input class="txt" type="password" size="256" name="password"></input>
					</p>
					<xsl:apply-templates select="errors/error[@name='password2']" />
					<p>
						<label><xsl:attribute name="for"><xsl:value-of select="fn_reg_names/password2" /></xsl:attribute>Пароль еще раз: <sup>*</sup></label>
						<input class="txt" type="password" size="256" name="password2"></input>
					</p>
				</div>
				<p>
					<input class="sbm large" type="submit" value="Зарегистрироваться" />
				</p>
				<p class="back2login">
					<a href="{/page/root}/login/">Вернуться к форме логина</a>
				</p>
			</fieldset>
		</form>
	</div></div></div></div>
	<div style="display:none;"><img id="ok_i" name="ok_i" src="{/page/root}/i/ok.gif" alt="Ok" class="status" /><img id="notok_i" name="notok_i" src="{/page/root}/i/notok.gif" alt="Error" class="status" /><img id="so_i" name="so_i" src="{/page/root}/i/so.gif" alt="Processing" class="status" /></div>
	<script type="text/javascript" src="{/page/root}/jsx/registration.js.php?tick=1"></script>
</xsl:template>

</xsl:stylesheet>