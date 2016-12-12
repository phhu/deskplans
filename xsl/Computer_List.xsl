<?xml version="1.0" encoding="ISO-8859-1"?> 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:param name="office">Glasgow</xsl:param>

	<xsl:variable name="domain" select="//office[@name=$office]/@domain" />
	<!-- <xsl:variable name="compinfo" select="document('http://itsupport/queries?adduser=viagra22;q=netscan_db;outputformat=xml')"/>	-->
	<xsl:variable name="compinfo" select="document('http://itsupport/data/spiceworks_devices.xml')"/>
	<xsl:variable name="ldapinfo" select="document('http://itsupport/data/allusers.xml')" />
	<xsl:variable name="phones" 	select="document('http://itsupport/svg/phones.xml')" />	
	<!-- choose the appropriate user / domain info -->

	
	<!-- svg as default and named to handle import of prefixed svg from the office "deskml" files -->
  <xsl:template match="/" >
  	<html>
  		<head>
  			<title><xsl:value-of select="$office"/>Computer list</title>	
			<script src="sorttable.js"></script>
			<script type="text/javascript" src="../js/jquery-1.10.1.min.js"></script>
			<script type="text/javascript" src="../js/jquery.dataTables.min.js"></script>
			<style type="text/css" title="currentStyle">	@import "../css/datatable.css";</style> 
			<style type="text/css" title="currentStyle">	
					.dataTables_filter {
						width: 50%;
						float: left;
						text-align: left;
					}
			</style> 			
			
			
	
			<script language="javascript"> 
				$(document).ready(function() {
					$('#table').dataTable( {	"bPaginate": false,	"bLengthChange": false,	"bFilter": true,"bSort": true,	"bInfo": true,"bAutoWidth": false			} );
				} );
			</script>
  		</head>
  		<body>	
			    <table id="table" class="display" border="1" cellpadding="3" cellspacing="0" >
				<thead>
				<tr>
					<th>Company</th>
					<th>Office</th>
					<th>Computer</th>
					<th>MAC address</th>
					<th>IP address</th>
					<th>os</th>
					<th>username</th>
					<th>user</th>
				</tr>
				</thead>
				<tbody>
					<xsl:apply-templates />
				</tbody>
		</table>
		</body>
	</html>
  </xsl:template>	

  <xsl:template match="//office" >

		<xsl:apply-templates />

  </xsl:template>

	<xsl:template match="computer"> 
		  	<xsl:variable name="compname" select="@name" /> 
			<xsl:variable name="username" select="ancestor::desk/user/@name" /> 
		<xsl:if test="$office='(all)'  or ancestor::site/@name=$office or ancestor::office/@name=$office or ancestor::company/@name=$office">
		<tr>
			<td><xsl:value-of select="ancestor::company/@name"/></td>
			<td><xsl:value-of select="ancestor::office/@name"/></td>
			<td><xsl:value-of select="@name"/></td>
		    <td><xsl:value-of select="$compinfo//row[uc_host_name=$compname]/mac_address"/></td>
			<td><xsl:value-of select="$compinfo//row[uc_host_name=$compname]/ip_address"/></td>
			<td><xsl:value-of select="$compinfo//row[uc_host_name=$compname]/operating_system"/></td>
			<td><xsl:value-of select="$username"/></td>
			<td><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/cn" /></td>
		</tr>
		</xsl:if>
	</xsl:template>		
	<xsl:template match="wall">  
 
	</xsl:template>	
</xsl:stylesheet>