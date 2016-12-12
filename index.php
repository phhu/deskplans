<?php 
		include_once "../../incl/SITE_CONSTANTS.php";
		include_once "../../incl/getSession.php";	
		
		function arrayToSelect($option, $selected = '', $optgroup = NULL)
		{
		    $returnStatement = '';
		
		    if ($selected == '') {
		        $returnStatement .= '<option value="" selected="selected">Select one...</option>';
		    }
        foreach ($option as $key => $value) {
            if (strtolower($value) == strtolower($selected)) {
                $returnStatement .= '<option selected="selected" value="' . $value . '">' . $value . '</option>';
            } else {
                $returnStatement .= '<option value="' . $value . '">' . $value . '</option>';
            }
        }
		    return $returnStatement;
		}

		//load desk xml
		$xmlDoc = new DOMDocument();
		$xmlDoc->load("desks.xml");
		$xpath = new DOMXpath($xmlDoc );
		
		//include all in office list
		$officeList = array('(all)');	
		$officeCodes = array();
		//get offices from desk.xml
		foreach (array('//site[@name]','//office[@name]','//company[@name]') as $xpathString){
			$elements = $xpath->query($xpathString);
			$tmpOffices = Array();
			foreach ($elements as $element) { 
				array_push($tmpOffices, $element->getAttribute('name'));
				//set the site code 
				if ($element->getAttribute('sitecode')){
					$officeCodes[$element->getAttribute('sitecode')] = $element->getAttribute('name');
				}
				//array_push($officeList, $element->getAttribute('name'));
			}	
			$tmpOffices = array_unique($tmpOffices);
			natcasesort ($tmpOffices);
			$officeList = array_merge($officeList, $tmpOffices);
		}
		
		
		//get rid of duplicates and sort 
		//$officeList = array_unique($officeList);
		//natcasesort ($officeList);
		
		//get formats - look for .xsl files
		$formats2 = glob("xsl/*.xsl");
		$formatList = array();
		foreach($formats2 as $fmt){
			array_push($formatList, preg_replace('/(.*?)\.xsl$/i','$1',basename($fmt)));
		}
		natcasesort($formatList);
		$roffice = $_REQUEST["office"];
		$format = $_REQUEST["format"];
		$find  = $_REQUEST["find"];
		$useFlash  = $_REQUEST["useFlash"];
		$noform  = $_REQUEST["noform"];
		$browser = $_SERVER['HTTP_USER_AGENT'];

		#for flash /svg browser compatibility
		$browserIsIE8orLess = false;
		preg_match('/MSIE (.*?);/', $_SERVER['HTTP_USER_AGENT'], $matches);
		if (count($matches)>1){
		  if  ($matches[1] <=8){$browserIsIE8orLess = true;}
		}
		$useSVGScript = ($format == 'Diagram' and ($browserIsIE8orLess or $useFlash == 'on'));
		
		#default diagram
		if (!in_array($format, $formatList)){$format='Diagram';}

		#get office to display, allowing abbreviated forms
		if($officeCodes[$roffice]){
			$office = $officeCodes[$roffice];
		} else {
			$offices = preg_grep("/^$roffice$/i", $officeList) + preg_grep("/^$roffice/i", $officeList) + preg_grep("/$roffice/i", $officeList);
			#reset($offices);
			$office = $offices{key($offices)};
		}
		if (!$office) {$office= 'all';}
?>
		<?php if (!$noform){ ?>
<!DOCTYPE html>
<html>
	<head>
		<?php
		if ($useSVGScript){
		echo '<meta name="svg.render.forceflash" content="true" />
		<script src="svgweb/src/svg.js" data-path="svgweb/src"></script>';}
		?>
		<title><?php echo $office;?> <?php echo $format;?></title>
		<link rel="shortcut icon" href="img/favicon.ico">
		<script type="text/javascript" src="/js/jquery-1.10.1.min.js"></script>	
		<script>
		function updatePlan(){
			$.getJSON('/queries?q=_time_current_punch&outputformat=json', updateUserStatusColours);
			$.getJSON('/queries?outputformat=JSON&q=_Phone_status', updateUserPhoneStatus);
		}
		
		function updateUserStatusColours(userStatusInfo){
			if (userStatusInfo != undefined){
				//$('.statusBox').attr('visibility','hidden');

				$.each($( ".deskrect" ), function(userrect){							
					var u = $(this).attr('user');
					var status = userStatusInfo.filter(function (userInfo){
						return userInfo.user_name == u;
					});
					var statusColours = {'IN': 'green', 'OUT':'red'};
					$(this).attr('fill-opacity','0.03');	
					$(this).attr('fill','black');
					if (status[0] != undefined){
						$(this).attr('fill',statusColours[status[0].status]);
						$(this).attr('fill-opacity','0.14');		
						//$('.statusBox#' + status[0].status + '[user="'  + u + '"]').attr('visibility','visible');
					}
				
				});
			}
		}
		
		function updateUserPhoneStatus(userStatusInfo){
			console.log(userStatusInfo);
			if (userStatusInfo != undefined){
				$('.statusBox').attr('visibility','hidden');

				$.each($( ".deskrect" ), function(userrect){
															
					var homephone = $(this).attr('homephone');
					var status = userStatusInfo.filter(function (userInfo){
						return userInfo.ext == homephone;
					});
					var statusColours = {
						'Out of office': 'red', 
						'Away':'orange',
						'Available' :'green'
					};
					var statusText = {
						'Out of office': 'Out', 
						'Away':'Away',
						'Available' :'Avail'
					};
					//$(this).attr('fill-opacity','0.03');	
					//$(this).attr('fill','black');
					if (status[0] != undefined){
						//$(this).attr('fill',statusColours[status[0].profilename]);
						//$(this).attr('fill-opacity','0.14');		
						var statusBox = $('.statusBox[homephone="'  + homephone + '"]');
						statusBox.attr('visibility','visible');
						statusBox.children('text').html(statusText[status[0].profilename]);
						statusBox.children('rect').attr('fill',statusColours[status[0].profilename]);
					}
				
				});
			}
		}
		
		$(updatePlan);
		
		</script>
		
	</head>
	
	
	<body>
		<?php 
		//var_dump($officeCodes);
		//echo site_constants::get('unilogs_url'). 'SC';// echo "<p>Office:" .  $offices{key($offices)} . "<br/>offices:" . var_dump($offices) . "</p>"; 
		?>

		<form name="officeform" method="get" >
			Desk plan for <select name="office" onchange="this.form.submit()" size="1">
				<?php echo arrayToSelect($officeList, $office) ?>
			</select>
			shown as <select name="format" onchange="this.form.submit()">
				<?php echo arrayToSelect($formatList, $format) ?>
			</select>
			<input type="submit" value="Show" />
			Find: <input type="text" name="find" value="<?php echo $find; ?>"/>
			Use Flash: <input type="checkbox" name="useFlash" <?php echo ($useFlash == 'on') ? 'checked="checked"' : ''; ?>/>
			No form:  <input type="checkbox" name="noform" <?php echo ($noform == 'on') ? 'checked="checked"' : ''; ?>/>
			</form>
		<center>
			<?php echo ''; ?>
			<?php } ?>

			<?php

			$xslDoc = new DOMDocument();
			$xslDoc->load('xsl/' . $format . '.xsl');
			
			$proc = new XSLTProcessor();
			$proc->importStylesheet($xslDoc);
			$proc->setParameter('', 'office', $office);
			$proc->setParameter('', 'find', strtolower($find));
			   
			//$proc->transformToURI($xmlDoc, 'file:///e:/zend/apache2/htdocs/svg/out.svg');
			$output= $proc->transformToXML($xmlDoc);
			
			if ($useSVGScript){echo '<script type="image/svg+xml"  xmlns="http://www.w3.org/2000/svg">';}
			echo $output;
			if ($useSVGScript){echo '</script>';}

			?>
			
		<?php if (!$noform){ ?>
		</center>
			
  </body>	
</html>
			<?php } ?>
<?php
		$unilogURL =  site_constants::get('unilog_url') . '?_logname=deskplan_access&type=load&q=' . urlencode($q) . "&user=" . urlencode($user) . "&office=" . urlencode($office) . "&format=" . urlencode($format). "&ip=" . urlencode($_SERVER['REMOTE_ADDR']) ;
		//file_get_contents($unilogURL );
		//echo $unilogURL;
?>