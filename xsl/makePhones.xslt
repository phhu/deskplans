<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="/">
		<root>
			<xsl:apply-templates />
		</root>
 	</xsl:template>

	<xsl:template match="row">

		<user>
					<xsl:attribute name="name"><xsl:value-of select="Authorised_User_Name"/></xsl:attribute>
		<phone>
			<xsl:attribute name="imei"><xsl:value-of select="IMEI"/></xsl:attribute>
		</phone>
		</user>
	</xsl:template>	
	
	<!--
	<xsl:template match="row">
		<phone>
			<xsl:attribute name="imei"><xsl:value-of select="IMEI"/></xsl:attribute>
			<xsl:attribute name="make">apple</xsl:attribute>
			<xsl:attribute name="type">iphone</xsl:attribute>
			<xsl:attribute name="model">5s</xsl:attribute>
			<sim>
				<xsl:attribute name="provider">EE</xsl:attribute>
				<xsl:attribute name="phonenumber"><xsl:value-of select="Pre-Provisioned_MSISDN"/></xsl:attribute>
				<xsl:attribute name="simnumber"><xsl:value-of select="SIM_No_"/></xsl:attribute>
			</sim>
		</phone>
	</xsl:template>
	
-->
</xsl:stylesheet>