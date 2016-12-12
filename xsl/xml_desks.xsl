<?xml version="1.0" encoding="UTF-8" ?> 

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8" />
	
	<xsl:variable name="ldapinfo" select="document('http://itsupport/data/allusers.xml')" />
	<xsl:variable name="compinfo" select="document('http://itsupport/data/spiceworks_devices.xml')"/>
		
	<xsl:template match="/" >
		<!--<test>
			<xsl:value-of select="$compinfo" />
		</test>	
		<test2>
			<xsl:value-of select="$ldapinfo//row" />
		</test2>-->	
		<xsl:apply-templates />			
	</xsl:template>	
	
	<xsl:template match="user">
		<xsl:variable name="username" select="@name" />
		<user>
			<xsl:attribute name="name"><xsl:value-of select="$username" /></xsl:attribute>
			<xsl:attribute name="cn"><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/cn" /></xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/title" /></xsl:attribute>
			<xsl:attribute name="telephonenumber"><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/telephonenumber" /></xsl:attribute>
			<xsl:attribute name="email"><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/mail" /></xsl:attribute>
		</user>
	</xsl:template>
	
	<xsl:template match="computer">
		<xsl:variable name="compname" select="@name" />
		<xsl:variable name="compos" select="$compinfo//row[uc_host_name=$compname]/operating_system" />
		<xsl:variable name="composshort">
			<xsl:choose>
				<xsl:when test="$compos='Windows 8.1 Pro'">Win8.1</xsl:when> 			
				<xsl:when test="$compos='Windows XP Pro'">XP pro</xsl:when> 
				<xsl:when test="$compos='Windows 7 Pro'">Win7</xsl:when> 
				<xsl:when test="$compos='Vista Business'">Vista</xsl:when> 
				<xsl:when test="$compos='Windows 2003/XP 64'">XP64/03</xsl:when> 
				<xsl:otherwise><xsl:apply-templates select="$compinfo//row[uc_host_name=$compname]/operating_system" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<computer>
			<xsl:attribute name="name"><xsl:value-of select="$compname" /></xsl:attribute>
			<xsl:attribute name="ip_address">
				<xsl:choose>
					<xsl:when test="@ipaddress"><xsl:value-of select="@ipaddress" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$compinfo//row[uc_host_name=$compname]/ip_address" /></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="rough_memory"><xsl:value-of select="$compinfo//row[uc_host_name=$compname]/rough_memory" />G</xsl:attribute>
			<xsl:attribute name="composshort"><xsl:value-of select="$composshort" /></xsl:attribute>
			<xsl:attribute name="manufacturer"><xsl:value-of select="$compinfo//row[uc_host_name=$compname]/manufacturer" /></xsl:attribute>
			<xsl:attribute name="model"><xsl:value-of select="$compinfo//row[uc_host_name=$compname]/model" /></xsl:attribute>
		</computer>		
	
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>