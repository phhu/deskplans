<?xml version="1.0" encoding="UTF-8"?> 

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:swivt="http://semantic-mediawiki.org/swivt/1.0#"
	xmlns:wiki="http://fpsgwiki/wiki/Special:URIResolver/"
	xmlns:property="http://fpsgwiki/wiki/Special:URIResolver/Property-3A"
	exclude-result-prefixes="rdf rdfs owl swivt wiki property"
	>
	
	<xsl:output method="html" />

	<xsl:param name="office">Edinburgh</xsl:param>

	<xsl:variable name="domain" select="//office[@name=$office]/@domain" />
	<xsl:variable name="logo" select="//company[@name=$office]/@logo" />
	<xsl:variable name="compinfo" select="document('http://itsupport/data/spiceworks_devices.xml')"/>	
	<xsl:variable name="ldapinfo" select="document('http://itsupport/data/allusers.xml')" />


	<xsl:template match="/">
	
			<script type='text/javascript' src='https://www.google.com/jsapi'>;</script>
			<script type='text/javascript'><![CDATA[
			  google.load('visualization', '1', {packages:['orgchart']});
			  google.setOnLoadCallback(drawChart);
			  function drawChart() {
				var data = new google.visualization.DataTable();
				data.addColumn('string', 'Name');
				data.addColumn('string', 'Manager');
				data.addColumn('string', 'ToolTip');
				data.addColumn('string', 'sort');
				data.addColumn('string', 'sort2');
				data.addRows([		]]>
					<xsl:apply-templates select="//office" />
				<![CDATA[		]);
				data.sort([{column: 3}, {column: 4},{column: 0}]);
				var chart = new google.visualization.OrgChart(document.getElementById('chart_div'));
				chart.draw(data, {allowHtml:true, size:'small',allowCollapse:true});
			  }
			  ]]>
			</script>


			<img style="float:right" alt="logo">
							<xsl:attribute name="src"><xsl:value-of select="$logo" /></xsl:attribute>
			</img>
			<center><h2 style="font-family:arial" ><xsl:value-of select="$office" /> Org Chart</h2></center>
			<div id='chart_div'></div>

	</xsl:template>	

	<xsl:template match="//office" >
		<xsl:if test="$office=@name or $office='(all)' or ancestor::company/@name=$office or descendant::company/@name=$office  or ancestor::site/@name=$office">
			<xsl:apply-templates >
				<xsl:sort select="//user/@name"/>
			</xsl:apply-templates >
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="desk[user]">
			<xsl:variable name="apos">'</xsl:variable>
		  	<xsl:variable name="username" 		select="user/@name" />
			<xsl:variable name="compname" 		select="computer/@name" /> 
			<xsl:variable name="phone" 			select="$ldapinfo//row[samaccountname=$username]/telephonenumber"	/>
			<xsl:variable name="ext" 			select="substring-before(substring-after($phone,'(ext'),')')"	/>
			<xsl:variable name="cn" 			select="translate($ldapinfo//row[samaccountname=$username]/cn,$apos,'_')"	/>
			<xsl:variable name="dn" 			select="translate($ldapinfo//row[samaccountname=$username]/dn,$apos,'_')"	/>
			<xsl:variable name="manager" 		select="translate($ldapinfo//row[samaccountname=$username]/manager,$apos,'_')"	/>
			<xsl:if test="$ldapinfo//row[samaccountname=$username]/cn and ($office='(all)' or ancestor::office/@name=$office or ancestor::company/@name=$office)  or ancestor::site/@name=$office">
		[{v:'<xsl:value-of select="$dn" />', f:'<p>
													<div style="font-size:12pt;"><xsl:value-of select="$cn" /></div>
													<div style="font-size:8pt;"><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/title" /></div>
													<div style="font-size:8pt;"><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/department" /></div>
													<div style="font-size:8pt;"><xsl:value-of select="$ldapinfo//row[samaccountname=$username]/company" /></div>
													<div style="font-size:8pt;"><xsl:value-of select="./ancestor::office/@name" /></div>
												</p>'}, '<xsl:value-of select="$manager" />', '','<xsl:value-of select="$ldapinfo//row[samaccountname=$username]/department" />','<xsl:value-of select="$ldapinfo//row[samaccountname=$username]/title" />'],
		</xsl:if>
	</xsl:template>	
	

	<xsl:template match="wall">  
 
	</xsl:template>	

	
	<!--
	
				  [{v:'Tec Group', f:'<img src="http://www.tecgroup.net/assets/img/logo.jpg" />'}, 'Compello', ''],

	
	-->

</xsl:stylesheet>