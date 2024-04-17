// scripts/tm470_FR4FR5.js

// Build the product category list first so elements exist for 
// detection by subsequent scripts [FR4/FR5]
$.get("scripts/buildprodcatlist.php", function(data, status)
{
	console.log("buildprodcatlist.php being called and put into #prodcatdisplay");
	
	$("#prodcatdisplay").html(data).show();
	
	// unitTest(
		// "TEST1 (failure if no match to demo foodbanks)",
		// data,
		// "<label for='fbID'>Please select a Food Bank:</label><br /><br/><select id='fbID' tabindex='20' name='foodbanks'><option value='1'>Food Bank 1</option><option value='2'>Food Bank 2</option><option value='3'>Food Bank 3</option></select>", 
		// );
});

// Unit testing assertions
function unitTest(testName, testData, compareData)
{
	console.log("Called unitTest for " + testName);
	console.assert((testData.trim() == compareData), testName);
}

$(document).ready(function()
{
	console.log("Ready tm470_FR4FR5!");

	// Hide fields until their display is required to increase
	// usability by not presenting users with irrelevant information
	// or options they shouldn't be interacting with at that time 
	// [FR4/FR5/FR6]
	$("#usermessage").hide();
	$("#prodcatdetails").hide();
	$("#newqtydisplay").hide();
	$("#quantitydisplay").hide();
	$("#buttondisplay").hide();
	
	// Detect selection of product category [FR4], retrieve information 
	// relevant to selection value (catID) and populate html fields
	// with that data [FR5]
 	$("#prodcatdisplay").change(function(){
		console.log("change detected");
		console.log("fbID is " + $sessionData.fbID); //("#fbID").val());
		console.log("catID is " + $("#catID").val());
		
		// Clear the user message
		$("#usermessage").html("").hide();
		$.post("scripts/displayprodcatinfo.php", 
		{
			fbID: $sessionData.fbID,
			catID: $("#catID").val()
		},
		function(data,status){
			// $("#prodcatdetails").html(data);
			
			$dataArray = JSON.parse(data);
			
			// Put the data from the array into variables
			$catName = $dataArray["catName"];
			$currentQuantity = $dataArray["quantity"];
			$newQuantity = $currentQuantity;
			
			// If there is no quantity, set it to zero
			if ($currentQuantity == null)
			{				
				$currentQuantity = 0;
				$newQuantity = 0;
			}
			
			// Put the variables into their HTML placeholders and show them
			$("#prodcatname").text($catName);			
			$("#current_qty").text($currentQuantity);
			$("#prodcatdetails").show();
			
			// Show all the buttons/inputs
			$("#quantitydisplay").show();
			$("#buttondisplay").show();
			
			updateTotalDisplay($currentQuantity);
		});
	});
	
	// Clear the usermessage display when information no longer relevant [FR5/FR6]
 	function clearUserMessage()
	{
		$("#usermessage").html("").hide();
	}
	
	// Update the 'totaldisplay' field with @param [FR5]
	function updateTotalDisplay(valueToDisplay)
	{
		$("#totaldisplay").val(valueToDisplay);
	}
	
	// Update the 'totaldisplay' field to visually indicate changes to variable $newQuantity [FR5]
 	function updateNewQuantity(amountToChangeBy)
	{
		console.log("updateNewQuantity(" + amountToChangeBy + ")");
		
		console.log("$newQuantity is " + $newQuantity);
		
		// For correct display and modification of total
		/* if (($newQuantity == "") || ($newQuantity == NaN) || ($newQuantity == null))
		{
			$newQuantity = 0;
		} */
		
		if (parseInt(amountToChangeBy) > 0)
		{
			// Clear the user message
			clearUserMessage();

			$newQuantity = parseInt($newQuantity) + parseInt(amountToChangeBy);

			// Update the total display 
			updateTotalDisplay($newQuantity);
			
			// Update the new quantity display (and keep track of the new 
			// quantity for updating the database
			$("#new_qty").html($newQuantity);
		}
		else
		{
			$proposedNewValue = parseInt($("#totaldisplay").val()) + parseInt(amountToChangeBy);
			
			if ($proposedNewValue < 0)
			{
				$("#usermessage").html("You can't decrease beyond zero").show();
			}
			else
			{
				$newQuantity = parseInt($newQuantity) + parseInt(amountToChangeBy);
				
				// Update the total display 
				updateTotalDisplay($newQuantity);
			}	
		}		
	}
	 
	// QUANTITY BUTTONS [FR5]
	// Register activation of each of the quantity buttons
	$("#minusten").click(function(){
		console.log("button -10 detected");
		updateNewQuantity(-10)
	});
	$("#minusone").click(function(){
		console.log("button -1 detected");
		updateNewQuantity(-1)
	});
	$("#plusone").click(function(){
		console.log("button +1 detected");
		updateNewQuantity(+1)
	});
	$("#plusten").click(function(){
		console.log("button +10 detected");
		updateNewQuantity(+10)
	});
 
	// CANCEL BUTTON CLICKED [FR5]
 	$("#cancel").click(function(){
		console.log("cancel button activated");
		
		// Reset the select input
		$("#catID").val("");
		// Reset the total display 
		updateTotalDisplay("");
		// Hide the buttons	
		$("#quantitydisplay").hide();
		$("#buttondisplay").hide();
		$("#prodcatdetails").hide();
	});

	// APPLY CHANGES BUTTON CLICKED [FR5]
 	$("#applychanges").click(function()
	{		
		$.post("scripts/updateprodcatquantity.php", 
		{
			fbID: $sessionData.fbID,
			catID: $("#catID").val(),
			newQuantity: $newQuantity
		},
		function(data,status){
			if (status)
			{
				$("#usermessage").html("Product category updated successfully").show();
				
				// Reset the select input
				$("#catID").val("");
				// Reset the total display 
				updateTotalDisplay("");
				// Hide the buttons	
				$("#quantitydisplay").hide();
				$("#buttondisplay").hide();
				$("#prodcatdetails").hide();
			}
			
		});
	});

});