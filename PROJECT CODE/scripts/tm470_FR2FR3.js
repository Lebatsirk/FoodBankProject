// scripts/tm470_FR2FR3.js

// Build the food bank list first so elements exist for detection 
// by subsequent scripts [FR2]
$.get("scripts/buildfoodbanklist.php", function(data, status)
{
	$("#foodbankdisplay").html(data);

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
	console.log("Ready tm470_FR2FR3!");

	// Include menu menu
	// $("#navlinks").html(buildMenuLinks(0)).hide();
	
	// Detect selection of food bank and retrieve information relevant
	// to selection value (fbID) [FR2/FR3]
	$("#foodbankdisplay").change(function(){
		$.post("scripts/displayfoodbankinfo.php", 
		{
			fbID: $("#fbID").val()
		},
		function(data,status){
			$("#foodbankdetails").html(data);
		});
		$.post("scripts/displayprioritylist.php", 
		{
			fbID: $("#fbID").val()
		},
		function(data,status){
			$("#prioritylistdetails").html(data);
		});
		
	});
	
});