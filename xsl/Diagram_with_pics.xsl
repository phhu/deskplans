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
	<xsl:variable name="compinfo" select="document('http://itsupport/data/spiceworks_devices.xml')"/>
	<xsl:variable name="ldapinfo" select="document('http://itsupport/data/allusers.xml')" />
	<!--<xsl:variable name="timepunches" 	select="document('http://itsupport/queries?outputformat=XML&amp;q=_time_current_punch&amp;adduser=viagra22')"/>	-->
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
			<text text-anchor="middle" y="18" style="font-family: 'Arial'; font-size: 8pt">
				<xsl:attribute name="x"><xsl:value-of select="@width * 0.5 * $xscale "/></xsl:attribute> 
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
		<xsl:if test="$office='(all)' or ancestor::office/@name=$office or ancestor::company/@name=$office  or ancestor::site/@name=$office">
			<xsl:variable name="username" select="user/@name" />
			<svg>
				<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
				<rect height="{$yscale}" width="{$xscale}" stroke="black" stroke-width="3" fill-opacity="0.1" stroke-opacity="0.9" fill="black" class="deskrect" user="{$username}" />
				<xsl:apply-templates />
				<rect height="{$yscale}" width="{$xscale}" stroke-width="0" fill-opacity="0" class="deskclickrect" user="{$username}" />
			</svg>
		</xsl:if>
	</xsl:template>	

	<xsl:template match="user">
		<xsl:variable name="username" select="@name" />
	
		<xsl:if test="contains(translate(concat(
			$username, 
			$ldapinfo//row[samaccountname=$username]/cn,
			$ldapinfo//row[samaccountname=$username]/telephonenumber,
			$ldapinfo//row[samaccountname=$username]/mail
			),$uppercase, $lowercase) ,translate($find,$uppercase, $lowercase)) and $find !=''">
			<rect y="0" height="55" width="{$xscale}" stroke="red" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="yellow"/>
		</xsl:if>
		<g class="statusBox" id="IN" user="{$username}" visibility="hidden">
		<text x="{$xscale * 0.92}" y="12"  style="font-family: 'Arial'; font-size: 8pt">IN</text> 
		<rect x="{$xscale * 0.884}" y="1"  height="15" width="20" stroke="red" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="green"/>
		</g>
		<g class="statusBox" id="OUT" user="{$username}" visibility="hidden">
			<text x="{$xscale * 0.875}" y="12"  style="font-family: 'Arial'; font-size: 7pt">OUT</text> 
			<rect x="{$xscale * 0.865}" y="1" height="15" width="22" stroke="red" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="red"/>
		</g>		
		
		<!-- punch status-->
		<!--<xsl:variable name="userpunchstatus" select="$timepunches//row[user_name=$username]/status" />
 
		<xsl:if test="$userpunchstatus='IN'">
			<text x="{$xscale * 0.92}" y="12"  style="font-family: 'Arial'; font-size: 8pt">IN</text> 
			<rect x="{$xscale * 0.884}" y="1"  height="15" width="20" stroke="red" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="green"/>
			<rect height="{$yscale}" width="{$xscale}" stroke="red" stroke-width="3" fill-opacity="0.18" stroke-opacity="0.9" fill="green"/>
		</xsl:if>
		<xsl:if test="$userpunchstatus='OUT'">
			<text x="{$xscale * 0.875}" y="12"  style="font-family: 'Arial'; font-size: 7pt">OUT</text> 
			<rect x="{$xscale * 0.865}" y="1" height="15" width="22" stroke="red" stroke-width="0" fill-opacity="0.5" stroke-opacity="0.9" fill="red"/>
			<rect height="{$yscale}" width="{$xscale}" stroke="red" stroke-width="3" fill-opacity="0.12" stroke-opacity="0.9" fill="red"/> 
		</xsl:if>			 
		-->
		<xsl:if test="$username!='(empty)' and $username!=''">

			<text text-anchor="middle" x="{0.5 * $xscale}" y="14" style="font-family: 'Arial'; font-size: 10pt;font-weight:bold"><xsl:apply-templates select="$ldapinfo//row[samaccountname=$username]/cn" /></text>
			<text text-anchor="middle" x="{0.5 * $xscale}" y="28" style="font-family: 'Arial'; font-size: 8pt"><xsl:apply-templates select="$ldapinfo//row[samaccountname=$username]/title" /></text>
			<text text-anchor="middle" x="{0.5 * $xscale}" y="42" style="font-family: 'Arial'; font-size: 8pt"><xsl:apply-templates select="$ldapinfo//row[samaccountname=$username]/telephonenumber" /></text>
			<!--<text x="3" y="50" style="font-family: 'Arial'; font-size: 8pt"><xsl:apply-templates select="$ldapinfo//row[samaccountname=$username]/mail" /></text>-->				
		
			<image x="{0.25 * $xscale}" y="{0.42 * $yscale}" height="{0.56 * $yscale}" width="{0.5 * $xscale}"  >
				 <xsl:attribute name="xlink:href">/images/users/<xsl:value-of select="$username"/>.jpg</xsl:attribute>
			</image>
		
		</xsl:if>
		
		
	</xsl:template>
	

	<!-- <text x="53" y="94" font-size="10"><xsl:apply-templates select="$compinfo//row[uc_host_name=$compname]/os" /></text> -->
	<xsl:template match="printer" xmlns="http://www.w3.org/2000/svg">  
		<svg>
			<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute>
			<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
			<rect height="{$yscale}" width="{$xscale}" stroke="black" stroke-width="3" fill-opacity="0.1" stroke-opacity="0.9" fill="purple"/>
			<text text-anchor="middle" x="{0.5 * $xscale}" style="font-family: 'Arial'; font-size: 8pt">
				<a>
				  <xsl:attribute name="xlink:href">http://itsupport/wiki/<xsl:value-of select="@name"/></xsl:attribute>
				  <tspan x="{0.5 * $xscale}" y="100">
					<xsl:value-of select="@name"/>
				  </tspan>
				</a>
			</text>
			<image x="{0.25 * $xscale}" y="3" height="80" width="{0.5 * $xscale}" xlink:href="http://itsupport/photos/icons/xerox7120.jpg" />
		  <!--<image x="100" y="0" height="80" width="80" xlink:href="http://itsupport/photos/icons/canon2380.gif" />-->
		</svg>
	</xsl:template>	


  <xsl:template match="wall" xmlns="http://www.w3.org/2000/svg">  
    <svg>
		<xsl:attribute name="x"><xsl:value-of select="@x * $xscale"/></xsl:attribute> 
		<xsl:attribute name="y"><xsl:value-of select="@y * $yscale"/></xsl:attribute>
		  <rect stroke="black" stroke-width="5" fill-opacity="0.5" stroke-opacity="0.9" fill="black">
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