<?xml version="1.0" encoding="ISO-8859-1"?> 

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>
	
	<xsl:param name="office">Edinburgh</xsl:param>

	<xsl:variable name="domain" select="//office[@name=$office]/@domain" />
		

	<xsl:variable name="ldapinfo" select="document('http://localhost/data/allusers.xml')" />
	<xsl:variable name="compinfo" select="document('http://localhost/data/spiceworks_devices.xml')"/>
<!-- 	svg as default and named to handle import of prefixed svg from the office "deskml" files -->
  <xsl:template match="/" >
  	<html>
  		<head>
  			<title><xsl:value-of select="$office"/>Desk list</title>	
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
					$('#table').dataTable( {	"bPaginate": false,	"bLengthChange": false,	"bFilter": true,"bSort": true,	"bInfo": true,"bAutoWidth": true			} );
				} );
			</script>
  		</head>
  		<body>	
				<table border="1" cellpadding="3" cellspacing="0" class="display" id="table">
					<thead>
					<tr>
						<th>First name</th>
						<th>Extension</th>
						<th>3CX extension</th>
						<th>Name</th>
						<th>Phone</th>
						<th>Mobile</th>
						<th>Email</th>
						<th>Company</th>
						<th>Office</th>
						<th>Department</th>
						<th>Title</th>
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
<!-- -->
  <xsl:template match="desk[user]"> 
  	<xsl:variable name="username" 		select="user/@name" />
  	<xsl:variable name="compname" 		select="computer/@name" /> 
    <xsl:variable name="phone" 			select="$ldapinfo//row[samaccountname=$username]/telephonenumber"	/>
	<xsl:variable name="ext" 			select="substring-before(substring-after($phone,'(ext'),')')"	/>
	<xsl:if test="$ldapinfo//row[samaccountname=$username]/cn and ($office='(all)' or ancestor::office/@name=$office or ancestor::company/@name=$office)">
		<tr>
			<td><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/givenname" /></td>
			<td><xsl:value-of select="$ext" /></td>
			<td><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/homephone" /></td>
			<td><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/cn" /></td>
			<td><xsl:value-of select="$phone" /></td>
			<td><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/mobile"/></td>		
			<td><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/mail"/></td>
			<td><xsl:value-of select="./ancestor::company/@name"/></td>
			<td><xsl:value-of select="./ancestor::office/@name"/></td>
			<td><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/department"/></td>
			<td><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/title"/></td>
		</tr> 
	</xsl:if>
	</xsl:template>		

	<xsl:template match="wall">  
 
	</xsl:template>	


</xsl:stylesheet>