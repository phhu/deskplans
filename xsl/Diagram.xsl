<?xml version="1.0" encoding="ISO-8859-1"?> 

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns="http://www.w3.org/2000/svg"
	>
	<xsl:output method="xml" omit-xml-declaration="yes" />
	
	<xsl:variable name="xscale">175</xsl:variable>
	<xsl:variable name="yscale">110</xsl:variable>
	
	<xsl:param name="office">Edinburgh</xsl:param>
	<xsl:param name="find">phughson</xsl:param>

	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	
	<!--<xsl:variable name="domain" select="//office[@name=$office]/@domain" />-->
	<xsl:variable name="compinfo" 	select="document('http://localhost/data/spiceworks_devices.xml')"/>
	<!--<xsl:variable name="phonestatus" 	select="document('http://itsupport/queries?database=glaspbx_all;outputformat=XML;q=_Phone_status;adduser=viagra22')"/>-->
	<!--<xsl:variable name="timepunches" 	select="document('http://itsupport/queries?outputformat=XML&amp;q=_time_current_punch&amp;adduser=viagra22')"/> -->
	<!-- http://itsupport/queries?outputformat=XML&q=_time_current_punch&adduser=viagra22 http://itsupport/data/time_current_punch.xml-->
	<xsl:variable name="ldapinfo" 	select="document('http://localhost/data/allusers.xml')" />
	<xsl:variable name="phones" 	select="document('http://localhost/svg/phones.xml')" />	
	<xsl:variable name="msoffice" 	select="document('http://localhost/data/_spiceworks_MS_office.xml')" />
	<xsl:variable name="teamviewer" 	select="document('http://localhost/data/_spiceworks_teamviewer.xml')" />
	<!-- svg as default and named to handle import of prefixed svg from the office "deskml" files -->
	<xsl:template match="/" >
		<xsl:apply-templates />			
	</xsl:template>	
 

	<xsl:template match="//site"  xmlns="http://www.w3.org/2000/svg" >
		<xsl:if test="$office=@name or descendant::company/@name=$office  or descendant::office/@name=$office">
			<xsl:choose>
				<xsl:when test="$office=@name" >
					<svg>
						<xsl:attribute name="width"><xsl:value-of select="@width * $xscale + 50"/></xsl:attribute> 
						<xsl:attribute name="height"><xsl:value-of select="@height * $yscale + 40"/></xsl:attribute>	
						<a target="_blank">
							<xsl:attribute name="xlink:href">http://itsupport/wiki/<xsl:value-of select="@name"/></xsl:attribute><text x="10" y="20" style="font-family: 'Arial'; font-size: 14pt" ><xsl:value-of select="@name"/></text>
						</a>
						<rect stroke="black" stroke-width="3" fill-opacity="0" stroke-opacity="1" >
								<xsl:attribute name="width"><xsl:value-of select="@width * $xscale + 50"/></xsl:attribute> 
								<xsl:attribute name="height"><xsl:value-of select="@height * $yscale + 40"/></xsl:attribute>
						</rect>

						<xsl:apply-templates />

					</svg>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="office" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="//office"  xmlns="http://www.w3.org/2000/svg" >
		<xsl:if test="$office=@name or $office='(all)' or ancestor::company/@name=$office or descendant::company/@name=$office or ancestor::site/@name=$office">
			<svg>
				<xsl:attribute name="width"><xsl:value-of select="@width * $xscale + 50"/></xsl:attribute> 
				<xsl:attribute name="height"><xsl:value-of select="@height * $yscale + 40"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="ancestor::site/@name=$office">
						<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
						<xsl:attribute name="y"><xsl:value-of select="@y * $yscale "/></xsl:attribute>		
					</xsl:when>
					<xsl:otherwise>
						<a target="_blank">
							<xsl:attribute name="xlink:href">http://itsupport/wiki/<xsl:value-of select="@name"/></xsl:attribute><text x="10" y="20" style="font-family: 'Arial'; font-size: 14pt" ><xsl:value-of select="@name"/></text>
						</a>
						<rect stroke="black" stroke-width="3" fill-opacity="0" stroke-opacity="1" >
								<xsl:attribute name="width"><xsl:value-of select="@width * $xscale + 50"/></xsl:attribute> 
								<xsl:attribute name="height"><xsl:value-of select="@height * $yscale + 40"/></xsl:attribute>
						</rect>
					</xsl:otherwise>
				</xsl:choose>
				<svg x="15" y="35">
					<xsl:attribute name="width"><xsl:value-of select="@width * $xscale + 50"/></xsl:attribute> 
					<xsl:attribute name="height"><xsl:value-of select="@height * $yscale + 40"/></xsl:attribute>
					<xsl:apply-templates />
					<xsl:copy-of select="svg:*"/>
				</svg>
			</svg>
		</xsl:if>
	</xsl:template>

	<xsl:template match="pod"  xmlns="http://www.w3.org/2000/svg">   
		<svg>
			<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
			<xsl:attribute name="y"><xsl:value-of select="@y * $yscale - 20"/></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="@width * $xscale"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="@height * $yscale"/></xsl:attribute>
			<text y="18" style="font-family: 'Arial'; font-size: 8pt">
				<xsl:attribute name="x"><xsl:value-of select="@width * 50 - 40"/></xsl:attribute> 
				<xsl:value-of select="@title"/>
			</text>
		</svg>  	
		<svg>
			<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
			<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="@width * $xscale"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="@height * $yscale"/></xsl:attribute> 
			<xsl:apply-templates />
		</svg>
	</xsl:template>

	<xsl:template match="desk" xmlns="http://www.w3.org/2000/svg">  
		<xsl:if test="$office='(all)' or ancestor::office/@name=$office or ancestor::company/@name=$office or ancestor::site/@name=$office">
			<xsl:variable name="username" select="user/@name" />
			<xsl:variable name="homephone" select="$ldapinfo//row[samaccountname=$username]/homephone" />
			<svg>
				<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
				<rect height="{$yscale}" width="{$xscale}" stroke="red" stroke-width="3" fill-opacity="0.03" stroke-opacity="0.9" fill="blue" class="deskrect" user="{$username}"  homephone="{$homephone}"/>
				<xsl:apply-templates />
				<xsl:if test="@name!=''">
					<rect x="155" y="95" height="15" width="20" stroke="blue" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="blue" /> 
					<text x="157" y="106"  style="font-family: 'Arial'; font-size: 8pt" ><xsl:value-of select="@name" /></text>
				</xsl:if>	
				<!-- username and class set here to allow onclick events to be attached -->

			</svg>
		</xsl:if>
	</xsl:template>	


	
	
	<xsl:template match="user">
		<xsl:variable name="username" select="@name" />
		<xsl:variable name="homephone" select="$ldapinfo//row[samaccountname=$username]/homephone" />
		<xsl:if test="contains(translate(concat(
			$username, 
			$ldapinfo//row[samaccountname=$username]/cn,
			$ldapinfo//row[samaccountname=$username]/telephonenumber,
			$ldapinfo//row[samaccountname=$username]/mail
			),$uppercase, $lowercase) ,translate($find,$uppercase, $lowercase)) and $find !=''">
			<rect y="0" height="55" width="{$xscale}" stroke="red" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="yellow"/>
		</xsl:if>
		
		<!-- punch status-->
		<!--<xsl:variable name="userpunchstatus" select="$timepunches//row[user_name=$username]/status" />
		visibility="hidden"
		-->

		<g class="statusBox"  homephone="{$homephone}" user="{$username}" visibility="hidden">
			<text x="{$xscale * 0.84}" y="12"  style="font-family: 'Arial'; font-size: 8pt"></text> 
			<rect x="{$xscale * 0.82}" y="1"  height="15" width="30" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="green"/>
			<!--<rect height="{$yscale}" width="{$xscale}" stroke="red" stroke-width="3" fill-opacity="0.18" stroke-opacity="0.9" fill="green"/>-->
		</g>

 
		<text x="3" y="40" style="font-family: 'Arial'; font-size: 8pt"><xsl:value-of select="$username"/></text>
		<xsl:if test="$username!='(empty)' and $username!=''">
			<!--<a target="_blank"> 
				<xsl:attribute name="xlink:href">http://itsupport/queries?adduser=viagra22;orderby0=count;ascdesc0=desc;orderby1=Date_last_logon;ascdesc1=desc;q=netscan_logons;loggedonuser=<xsl:value-of select="$username"/></xsl:attribute>
				<text x="{0.87 * $xscale}" y="12" style="font-family: 'Arial'; font-size: 8pt">(L)</text>
			</a>-->
			<a target="_blank"> 
				<xsl:attribute name="xlink:href">mailto://<xsl:value-of select="$ldapinfo//row[samaccountname=$username]/mail" /></xsl:attribute>
				<text x="{0.80 * $xscale}" y="40" style="font-family: 'Arial'; font-size: 8pt">(E)</text>
			</a>
			<a target="_blank"> 
				<xsl:attribute name="xlink:href">http://tickets/scp/tickets.php?a=open&amp;focus=subject&amp;source=Other&amp;deptId=1&amp;email=<xsl:value-of select="$ldapinfo//row[samaccountname=$username]/mail" />&amp;name=<xsl:value-of select="$ldapinfo//row[samaccountname=$username]/cn" />&amp;phone=<xsl:value-of select="$ldapinfo//row[samaccountname=$username]/telephonenumber" /></xsl:attribute>
				<text x="{0.90 * $xscale}" y="40" style="font-family: 'Arial'; font-size: 8pt">(T)</text>
			</a>	
			<text x="3" y="14" style="font-family: 'Arial'; font-size: 10pt;font-weight:bold"><xsl:apply-templates select="$ldapinfo//row[samaccountname=$username]/cn" /></text>
			<text x="3" y="26" style="font-family: 'Arial'; font-size: 8pt"><xsl:apply-templates select="$ldapinfo//row[samaccountname=$username]/title" /></text>
			
			<a target="_blank"> 
				<xsl:attribute name="xlink:href">http://itsupport/cgi-bin/callphone.pl?number=<xsl:value-of select="$ldapinfo//row[samaccountname=$username]/telephonenumber" /></xsl:attribute>			
				<text x="3" y="52" style="font-family: 'Arial'; font-size: 8pt"><xsl:apply-templates select="$ldapinfo//row[samaccountname=$username]/telephonenumber" /></text>
			</a>
			<xsl:if test="$ldapinfo//row[samaccountname=$username]/homephone!='(empty)' and $ldapinfo//row[samaccountname=$username]/homephone!=''">
				<a target="_blank"> 
					<xsl:attribute name="xlink:href">http://itsupport/cgi-bin/callphone.pl?number=<xsl:value-of select="$ldapinfo//row[samaccountname=$username]/homephone" /></xsl:attribute>			
					<text x="139" y="52" style="font-family: 'Arial'; font-size: 8pt">(<xsl:apply-templates select="$ldapinfo//row[samaccountname=$username]/homephone" />)</text>
				</a>
			</xsl:if>
			<!--<text x="3" y="50" style="font-family: 'Arial'; font-size: 8pt"><xsl:apply-templates select="$ldapinfo//row[samaccountname=$username]/mail" /></text>-->				
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="computer">
		<xsl:variable name="compname" select="@name" />
		<xsl:variable name="compos" select="$compinfo//row[uc_host_name=$compname]/operating_system" />
		<!--<xsl:variable name="msofficeversion" select="$msoffice//row[Device_name=$compname]/software_name" />-->
		<xsl:variable name="teamviewerversion" select="$teamviewer//row[Device_name=$compname]/software_name" />
		
		<xsl:variable name="composshort">
			<xsl:choose>
				<xsl:when test="$compos='Windows XP Pro'">XP pro</xsl:when> 
				<xsl:when test="$compos='Windows 7 Pro'">Win7</xsl:when> 
				<xsl:when test="$compos='Windows 8.1 Pro'">Win8.1</xsl:when>
				<xsl:when test="$compos='Windows 8 Pro'">Win8</xsl:when> 
				<xsl:when test="$compos='Vista Business'">Vista</xsl:when> 
				<xsl:when test="$compos='Windows 2003/XP 64'">XP64/03</xsl:when> 
				<xsl:otherwise><xsl:apply-templates select="$compinfo//row[uc_host_name=$compname]/operating_system" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- highlight XP computers -->
		<xsl:if test="contains(translate(concat(
			$compname, 
			$compinfo//row[uc_host_name=$compname]/model,
			$compinfo//row[uc_host_name=$compname]/ip_address,
			$compinfo//row[uc_host_name=$compname]/manufacturer,
			$compinfo//row[uc_host_name=$compname]/operating_system,
			$composshort
		),$uppercase, $lowercase) ,translate($find,$uppercase, $lowercase)) and $find !=''">
			<rect y="60" x="2" height="48" width="{$xscale}" stroke="red" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="yellow"/>
		</xsl:if>
		<xsl:if test="$compos='Windows XP Pro'">
			<rect y="68" height="42" width="{$xscale}" stroke="red" stroke-width="0" fill-opacity="0.1" stroke-opacity="0.9" fill="red" /> 
		</xsl:if>
		<xsl:if test="$compos='Windows 8.1 Pro'">
			<rect y="68" height="42" width="{$xscale}" stroke="red" stroke-width="0" fill-opacity="0.1" stroke-opacity="0.9" fill="purple" /> 
		</xsl:if>
		<!--<xsl:if test="$msofficeversion='Microsoft Office 2007 Professional Plus'">
			<rect x="135" y="0" height="15" width="20" stroke="blue" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="yellow" ></rect> 
			<text x="140" y="13"  style="font-family: 'Arial'; font-size: 8pt" >07</text>
		</xsl:if>			
		<xsl:if test="$msofficeversion='Microsoft Office 2013 Professional Plus'">
			<rect x="155" y="0" height="15" width="20" stroke="blue" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="green" /> 
			<text x="160" y="13"  style="font-family: 'Arial'; font-size: 8pt" >13</text>
		</xsl:if>		
		-->
		<!-- computer name -->
		<a target="_blank">
			<!--<xsl:attribute name="xlink:href">http://itsupport/queries?adduser=viagra22;q=netscan_db;computername=<xsl:value-of select="$compname"/></xsl:attribute>-->
			<text x="3" y="80" style="font-family: 'Arial'; font-size: 9pt"><xsl:value-of select="$compname"/></text>
		</a>
		
		<!-- computer details -->
		<xsl:if test="$compname!='(none)' and $compname!=''"> 
			<a>
				<xsl:attribute name="xlink:href">http://spiceworks/search?submit=Search+%E2%80%A6;query=<xsl:value-of select="$compname"/></xsl:attribute>
				<text x="{0.63 * $xscale}" y="80" font-size="9" style="font-family: 'Arial'; font-size: 8pt">S</text>
			</a>	

			<xsl:if test="$teamviewerversion='TeamViewer'">
				<rect x="119" y="72" height="9" width="13" stroke="blue" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="olive" /> 
			</xsl:if>		
			<xsl:if test="$teamviewerversion='TeamViewer 9 Host'">
				<rect x="119" y="72" height="9" width="13" stroke="blue" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="green" /> 
			</xsl:if>	
			<a>
				<xsl:attribute name="xlink:href">http://itsupport/cgi-bin/radmin.pl?type=tv;host=<xsl:value-of select="$compname"/></xsl:attribute>
				<text x="{0.68 * $xscale}" y="80" font-size="9" style="font-family: 'Arial'; font-size: 8pt">TV</text>
			</a>			

			<a>
				<xsl:attribute name="xlink:href">http://itsupport/cgi-bin/radmin.pl?type=radmin;host=<xsl:value-of select="$compname"/></xsl:attribute>
				<text x="{0.78 * $xscale}" y="80" font-size="9" style="font-family: 'Arial'; font-size: 8pt">RA</text>
			</a>				
			<a>
				<xsl:attribute name="xlink:href">http://itsupport/cgi-bin/radmin.pl?type=rdp;host=<xsl:value-of select="$compname"/></xsl:attribute>
				<text x="{0.88 * $xscale}" y="80" font-size="9" style="font-family: 'Arial'; font-size: 8pt">RDP</text>
			</a>
			<text x="3" y="90" font-size="9"><xsl:apply-templates select="$compinfo//row[uc_host_name=$compname]/ip_address" /></text>
			<xsl:if test="@ipaddress">
				<text x="3" y="93" font-size="12"><xsl:apply-templates select="@ipaddress" /></text>   <!-- if static IP specified on computer display it -->
				<a>
					<xsl:attribute name="xlink:href">http://itsupport/cgi-bin/radmin.pl?type=vnc;host=<xsl:value-of select="@ipaddress"/></xsl:attribute>
					<text x="80" y="93" font-size="9">VNC</text>   <!-- if static IP specified on computer display it -->
				</a>
			</xsl:if>
			<text x="{0.72 * $xscale}" y="90" style="font-family: 'Arial'; font-size: 8pt"><xsl:apply-templates select="$compinfo//row[uc_host_name=$compname]/rough_memory" />G</text>
			
			<text x="3" y="100" font-size="7" style="font-family: 'Arial'; font-size: 7pt"><xsl:value-of select="$composshort" /></text>
			<text x="53" y="100" style="font-family: 'Arial'; font-size: 7pt"><xsl:apply-templates select="$compinfo//row[uc_host_name=$compname]/manufacturer" /></text>
			<text x="3" y="108" style="font-family: 'Arial'; font-size: 7pt"><xsl:apply-templates select="$compinfo//row[uc_host_name=$compname]/model" /></text>				
		</xsl:if>
	</xsl:template>

	<xsl:template match="phone" xmlns="http://www.w3.org/2000/svg">  
		<svg>
			<xsl:variable name="phoneimei" select="./@imei" />
			<text x="2" y="65" style="font-family: 'Arial'; font-size: 8pt">

				
				<xsl:value-of select="$phones//phone[@imei=./@imei]/@type" />
				<tspan  xml:space="preserve"> </tspan>
				<xsl:value-of select="$phones//phone[@imei=./@imei]/@model" />
				<tspan  xml:space="preserve"> </tspan>
				
				<xsl:value-of select="$phones//phone[@imei=$phoneimei]/sim/@phonenumber" />
			</text>
			<image x="{$xscale*0.9}" y="50" height="18" width="15" xlink:href="http://itsupport/images/iphone5s.png" />
			
		  <!--<image x="100" y="0" height="80" width="80" xlink:href="http://itsupport/photos/icons/canon2380.gif" />-->
		</svg>
	</xsl:template>
	
	<!-- <text x="53" y="94" font-size="10"><xsl:apply-templates select="$compinfo//row[uc_host_name=$compname]/os" /></text> -->
	<xsl:template match="printer" xmlns="http://www.w3.org/2000/svg">  
		<svg>
			<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute>
			<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
			<rect height="{$yscale}" width="{$xscale}" stroke="yellow" stroke-width="3" fill-opacity="0.1" stroke-opacity="0.9" fill="blue"/>
			<text style="font-family: 'Arial'; font-size: 8pt">
				<a>
				  <xsl:attribute name="xlink:href">http://itsupport/wiki/<xsl:value-of select="@name"/></xsl:attribute>
				  <tspan x="30" y="100">
					<xsl:value-of select="@name"/>
				  </tspan>
				</a>
			</text>
			<image x="0" y="0" height="80" width="80" xlink:href="http://itsupport/photos/icons/xerox7120.jpg" />
			
		  <!--<image x="100" y="0" height="80" width="80" xlink:href="http://itsupport/photos/icons/canon2380.gif" />-->
		</svg>
	</xsl:template>	


  <xsl:template match="wall" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		  <rect stroke="blue" stroke-width="3" fill-opacity="0.1" stroke-opacity="0.9" fill="blue">
			<xsl:attribute name="width"><xsl:value-of select="@width * $xscale"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="@height * $yscale"/></xsl:attribute>
		  </rect>
    </svg>
  </xsl:template>	

  <xsl:template match="label" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		<text x="2" y="14">
			<xsl:attribute name="font-size"><xsl:value-of select="@font-size"/></xsl:attribute> 
			<xsl:value-of select="@caption"/>
		</text>
    </svg>
  </xsl:template>

  <xsl:template match="fireexit" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		<text x="2" y="10" font-size="14">
			Fire exit
		</text>
		<image x="0" y="0" width="80" height="40" xlink:href="http://itsupport/photos/icons/fire_exit.jpg" />
    </svg>
  </xsl:template>

  <xsl:template match="fireextinguisher" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		<text x="2" y="10" font-size="14">
			Fire extinguisher
		</text>
		<image x="30" y="10" width="35" height="35" xlink:href="http://itsupport/photos/icons/fire_extinguisher.jpg" />
    </svg>
  </xsl:template>

  <xsl:template match="stair" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		<text x="2" y="10" font-size="14">
			Stair
		</text>
		<image x="0" y="0" width="120" height="120" xlink:href="http://itsupport/photos/icons/stairs4.png" />
    </svg>
  </xsl:template>
 
   <xsl:template match="lift" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		<!--<text x="2" y="10" font-size="14">
			Lift
		</text>-->
		<image x="0" y="0" width="120" height="120" xlink:href="http://itsupport/photos/icons/lift.png" />
    </svg>
  </xsl:template>

   <xsl:template match="image" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		<image x="0" y="0">
			<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
			<xsl:attribute name="xlink:href"><xsl:value-of select="@url"/></xsl:attribute>
		</image>
    </svg>
  </xsl:template>
  
	<defs>
		<marker id="myMarker" viewBox="0 0 10 10" refX="1" refY="5" markerUnits="strokeWidth" orient="auto" markerWidth="4" markerHeight="3">
			<polyline points="0,0 10,5 0,10 1,5" fill="darkblue" />
		</marker>
	</defs>

  <xsl:template match="photo" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		
		<rect stroke="green" stroke-width="3" fill-opacity="0.1" stroke-opacity="0.9" fill="blue">
			<xsl:attribute name="width">
				<xsl:choose>
					<xsl:when test="@width"><xsl:value-of select="@width * $xscale"/></xsl:when>
					<xsl:otherwise>75</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:choose>
					<xsl:when test="@height"><xsl:value-of select="@height * $xscale"/></xsl:when>
					<xsl:otherwise>16</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</rect>
		<!--<image x="0" y="20" width="300" height="300" xlink:href="@url" />-->
		<!--<line x1="1" y1="1" x2="6" y2="6" stroke="green"  stroke-width="2" marker-end="url(#myMarker)" /> -->
		<a>
			<xsl:attribute name="xlink:href"><xsl:value-of select="@url"/></xsl:attribute>
			<text x="2" y="10" font-size="10"><xsl:value-of select="@caption"/></text>
		</a>	
		
	</svg>
  </xsl:template>
  
  <xsl:template match="port" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		<xsl:attribute name="width"><xsl:value-of select="2 * $xscale"/></xsl:attribute>
		<xsl:attribute name="height"><xsl:value-of select="0.5 * $yscale"/></xsl:attribute>
		
		<polygon points="10,0 15,5 12.5,2.5 15,0 10,5 12.5,2.5 10,0" stroke="blue" fill="darkblue" stroke-width="1" fill-rule="nonzero" />

		<text x="4" y="12" style="font-family: 'Arial'; font-size: 7pt"><xsl:value-of select="@caption"/></text>
		
	</svg>
  </xsl:template>	
  
</xsl:stylesheet>