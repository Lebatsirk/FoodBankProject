// scripts/tm470_FR11FR12.js

// Build the food bank list first so elements exist for detection 
// by subsequent scripts [FR2]
$.get("scripts/buildfoodparcellist.php", function(data, status)
{
	$("#parceldisplay").html(data);

	unitTest(
		"TEST1 (failure if no match to demo foodbanks)",
		data,
		"<label for='fbID'>Please select a Food Bank:</label><br /><br/><select id='fbID' tabindex='20' name='foodbanks'><option value='1'>Food Bank 1</option><option value='2'>Food Bank 2</option><option value='3'>Food Bank 3</option></select>", 
		);
});

// Unit testing assertions
function unitTest(testName, testData, compareData)
{
	console.log("Called unitTest for " + testName);
	console.assert((testData.trim() == compareData), testName);
}

$(document).ready(function()
{
	console.log("Ready tm470_FR11FR12!");
	
	// Hide the elements related to displaying details for a selected food parcel until needed
	$("#foodparceldetails").hide();
	$("#foodparcelgrid").hide();
	
	// Detect selection of food parcel size and retrieve information relevant
	// to selection value (parcelID) [FR11/FR12]
	$("#parceldisplay").change(function()
	{
		// Reset the user message box
		$("#usermessage").html("").css("color", "#000").hide();
		
		// Reset the table rows
		$("#prodcattable tbody").empty();
 		
		$.post("scripts/displayparcelinfo.php", 
		{
			parcelID: $("#parcelID").val(),
			fbID: $sessionData.fbID
		},
		function(data,status){
			
			$foodparcelArray = JSON.parse(data.trim());
			
			for ($record = 0; $record < $foodparcelArray.length; $record++) 
			{
				$prodcatRecord = $foodparcelArray[$record];
				
				if (parseInt($prodcatRecord["notEnough"]) == 1)
				{	
					$("#prodcattable tbody").append("<tr><td id='leftcol' class='notenough'>"
						+ $prodcatRecord["catName"] 
						+ "</td><td id='midcol' class='notenough'>" + $prodcatRecord["amount"] 
						+ "</td><td id='rightcol' class='notenough'>" + $prodcatRecord["quantity"] + " in stock"
						+ "</td></tr>");
				}
				else
				{
					$("#prodcattable tbody").append("<tr><td id='leftcol'>" 
						+ $prodcatRecord["catName"] 
						+ "</td><td id='midcol'>" + $prodcatRecord["amount"] 
						+ "</td><td id='rightcol'>"
						+ "<input type='checkbox' class='parceltickbox' value='" + $prodcatRecord["catID"] + "'>"
						+ "</td></tr>");
				}					
			}
			
			// Show the food parcel instructions and grid
			$("#foodparceldetails").show();
			$("#foodparcelgrid").show();
			
		});
		
	});
		
	$("#submitfoodparcel").click(function()
	{
		console.log("submit button pressed - time to validate"); //DEBUG
		
		// Client-side validation
		$validData = validateCheckboxes();
		
		if ($validData)
		{
			console.log("posting to foodparcelassembled.php with values " + $sessionData.fbID + " and " + $("#parcelID").val()); //DEBUG
			
			$.post("scripts/foodparcelassembled.php", 
			{
				fbID: $sessionData.fbID,
				parcelID: $("#parcelID").val()
			},
			function(data,status){
				
				console.log(data + status); //DEBUG
				
				// Status shows as success even when an exception is raised.  
				// Needs further research so I can determine how to 
				// show black text or red text so for now will default to black.
				
				if ($("#usermessage").html() == "")
				{
					$("#usermessage").html(data).css("color", "#000").show(); // status shows as success even when an exception is raised
				}
				
			});	
		}
		else
		{
			// $("#usermessage").html("DEBUG").css("color", "red").show();	
		}
	});	
	
	function validateCheckboxes()
	{
		console.log("validating checkboxes"); //DEBUG
		
		$numProductCategories = document.getElementById("prodcattable").rows.length - 1;
		$numCheckedBoxes = 0;
		
		console.log("there should be " + $numProductCategories + " boxes"); //DEBUG
		
		// Loop through the checkboxes, counting how many are ticked
		$("input[type=checkbox]").each(function () 
		{
			console.log("checking checkbox " + $("input[type=checkbox]").val()); //DEBUG
			
			if (this.checked) 
			{
				$numCheckedBoxes = $numCheckedBoxes + 1;
			}
			else
			{
				console.log("non-ticked checkbox found"); //DEBUG
				// As soon as one box is found that is not ticked, inform user and return true for $issuesFound
				$("#usermessage").html("Please tick all boxes to confirm that items have been assembled in food parcel.").css("color", "red").show();
				
				return false;
			}
		});
		
		console.log("does $numCheckedBoxes (" + $numCheckedBoxes + " = $numProductCategories " + $numProductCategories + "? " 
											+ parseInt($numCheckedBoxes) == parseInt($numProductCategories)); //DEBUG
		
		// No issues found so return false;
		if (parseInt($numCheckedBoxes) == parseInt($numProductCategories)) 
		{
			return true;		
		}
		else
		{
			// All available checkboxes have been ticked but some items have insufficient quantities
			$("#usermessage").html("Insufficient quantity available of one or more product categories for selected food parcel size.").css("color", "red").show();
			// $("#usermessage").html("Please tick all boxes to confirm that items have been assembled in food parcel.").css("color", "red").show();
			return false;
		}
	}

});