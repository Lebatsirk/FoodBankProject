// scripts/tm470_FR4FR6.js


// Build the product category list first so elements exist for 
// detection by subsequent scripts [FR4/FR6]
 $.get("scripts/buildprodcatlist.php", function(data, status)
{
	$("#prodcatdisplaythresholds").html(data).show();
	
	// unitTest(
		// "TEST1 (failure if no match to demo foodbanks)",
		// data,
		// "<label for='fbID'>Please select a Food Bank:</label><br /><br/><select id='fbID' tabindex='20' name='foodbanks'><option value='1'>Food Bank 1</option><option value='2'>Food Bank 2</option><option value='3'>Food Bank 3</option></select>", 
		// );
});	
	
// Unit testing $newQuantity
function unitTest(testName, testData, compareData)
{
	console.log("Called unitTest for " + testName);
	console.assert((testData.trim() == compareData), testName);
}
	
// Create function for checking if a user (logged in or otherwise) is authorised to view the current page
/* function checkAuthorisation(accesstype)
{
	console.log(window.location.href + accesstype);
	
	console.log("Checking auth for user with accesstype " + accesstype);
	
	$newURL = $currentURL.replace($currentPage, $adminMenu);
	
	switch (parseInt(accesstype))
	{
		case 1:
			$allowedPages = [$publicPage, $adminMenu, "FR4FR5.html", "FR11FR12.html"]; // For accesstype = 1
			if ($allowedPages.includes($currentPage) == false)
			{
				// window.location.href = $adminMenu;
			}
			break;
		case 2:
			$allowedPages = [$publicPage, $adminMenu, "FR4FR5.html", "FR4FR6.html", "FR11FR12.html"]; // For accesstype = 2
			if ($allowedPages.includes($currentPage) == false)
			{
				// window.location.href = $adminMenu;
			}
			break;
		default:
			// Only allowed to view public page
			$allowedPages = [$publicPage]; // For accesstype = 0
			/* if ($allowedPages.includes($currentPage) == false)
			{
				// window.location.href = $publicPage;
			} */
	// }
	
	// return $allowedPages.includes($currentPage);	
// }

$(document).ready(function()
{
	console.log("Ready tm470_FR4FR6!");
	
	// Check that the user's access type is correct to view this page
	// in case they have accessed it directly
	
	// Hide fields until their display is required to increase
	// usability by not presenting users with irrelevant information
	// or options they shouldn't be interacting with at that time 
	// [FR4/FR6]
 	$("#usermessage").hide();
	$("#newqtydisplay").hide();
	$("#thresholddisplay").hide();
	$("#buttondisplay").hide();
	$("#prodcatdetailsthresholds").hide();
	
	// Detect selection of product category [FR4], retrieve information 
	// relevant to selection value (catID) and populate html fields
	// with that data [FR6]
 	$("#prodcatdisplaythresholds").change(function(){
		console.log("change detected");
		console.log("fbID is " + $("#fbID").val());
		console.log("catID is " + $("#catID").val());
		
		// This page is for managers only so check access
		if (parseInt($sessionData.accesstype) != 2)
		{
			$("#usermessage").html("Sorry, you are not authorised to perform this task.<br />Please select another option from the menu.").css("color", "red").show();
			$("#catID").val("");
		}
		else
		{
			// Clear the user message
			$("#usermessage").html("").hide();
			$.post("scripts/displayprodcatinfothresholds.php", 
			{
				fbID: $sessionData.fbID,
				catID: $("#catID").val()
			},
			function(data,status){
				$dataArray = JSON.parse(data);
				
				$catName = $dataArray["catName"];
				$minThreshold = $dataArray["minthreshold"];
				$maxThreshold = $dataArray["maxthreshold"];
				
				if ($minThreshold == null)
				{				
					$minThreshold = 0;
				}
				
				if ($maxThreshold == null)
				{				
					$maxThreshold = 0;
				}
				
				$("#prodcatname").val($catName);
				$("#minthreshold").val($minThreshold);
				$("#maxthreshold").val($maxThreshold);
				
				// Show all the buttons/inputs
				$("#thresholddisplay").show();
				$("#buttondisplay").show();
			});
		}
	});
	
	// Clear the usermessage display when information no longer relevant [FR5/FR6]
 	function clearUserMessage()
	{
		$("#usermessage").html("").hide();
	}

	// CANCEL BUTTON CLICKED [FR6]
 	$("#cancelthreshold").click(function(){
		console.log("cancel button activated");
		
		// Reset the select input
		$("#catID").val("");
		// Hide the buttons	
		$("#buttondisplay").hide();
		$("#thresholddisplay").hide();
	});
	
	// APPLY CHANGES BUTTON CLICKED [FR6]
	$("#applythresholdchanges").click(function()
	{
		// Client-side validation
		$issuesFound = validateThresholds();
		
		if ($issuesFound === false)
		{
			$.post("scripts/updateprodcatthresholds.php", 
			{
				fbID: $sessionData.fbID,
				catID: $("#catID").val(),
				newMinThreshold: $("#minthreshold").val(),
				newMaxThreshold: $("#maxthreshold").val()
			},
			function(data,status){
				if (status)
				{
					$("#usermessage").html("Product category updated successfully").css("color", "#000").show();
					
					// Reset the select input
					$("#catID").val("");
					// Hide the buttons	
					$("#thresholddisplay").hide();
					$("#buttondisplay").hide();
					$("#prodcatdetails").hide();
				}		
			});	
		}
	});
	
	function validateThresholds()
	{
		// console.log("validating thresholds");
		
		min = parseInt($("#minthreshold").val());
		max = parseInt($("#maxthreshold").val());
		
		// console.log("min is " + min + " and max is " + max);
		
		if (max <= min)
		{
			$("#usermessage").html("MaxThreshold must be greater than MinThreshold").css("color", "red").show();
			return true;
		}	
		if ((max < 1) || (min < 1))
		{
			$("#usermessage").html("Threshold values must be 1 or higher").css("color", "red").show();
			return true;
		}
		
		// No issues found
		return false;
		
	}
	
});