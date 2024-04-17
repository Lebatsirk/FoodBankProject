// scripts/navloginout.js

// Unit testing assertions
/* function unitTest(testName, testData, compareData)
{
	console.log("Called unitTest for " + testName);
	console.assert((testData.trim() == compareData), testName);
}
 */
$(document).ready(function()
{
	console.log("loaded navloginout.js"); //DEBUG
	
	// Hide user message boxes until required
	$("#navusermessage").hide();
	$("#usermessage").hide();
	
	// Hide log out/in links until needed
	$("#navlogoutlink").hide();
	$("#navloginlink").hide();
	
	// Build basic menu (can be changed after successful login)
	$("#navlinks").html(buildMenuLinks(0)).hide();
	
	// Attempt login
	$("#login").click(function(){
		console.log("log in activated"); //DEBUG
		
		$.post("scripts/login.php",
		{
			username: $("#username").val(),
			pwd: $("#pwd").val() // Should send over SSL/TLS
		},
		function(data,status)
		{
			$sessionData = JSON.parse(data.trim());
			
			if ($sessionData["loggedin"])
			{	
				$("#navusermessage").html("User " + $sessionData.username + " is logged in "
										+ " with access level " + $sessionData.accesstype //DEBUG
										+ " for food bank " + $sessionData.fbID //DEBUG
										).css("color", "#000");
				
				// Show the content
				$("main").show();
			
				// Show prodcatdisplay for FR4/FR5
				// $("#prodcatdisplay").show(); //DEBUG

				// Hide the login form
				$("#loginformdisplay").hide();
				
				console.log("navloginlogout.js ln 53: we have session data and accesstype is " + $sessionData.accesstype); //DEBUG
				
				$builder = buildMenuLinks($sessionData.accesstype); // Appropriate menu links for access type
		
				// Default to menu hidden at first
				$("#navlinks").html($builder).hide();

				// Toggle the log in/out links
				$("#navlogoutlink").show();
				$("#navloginlink").hide();
				
				// Display a message and links in the main section //#d5e8d4
				$("#usermessage").html("Please use button above to select available admin tasks.").css("color", "#000").css("backgroundColor", "#FFF").show();
				
			}
			else
			{
				// Build basic menu
				$("#navlinks").html(buildMenuLinks(0)).hide();
				
				$("#navusermessage").html("Log in unsuccessful.<br />Please try again.").css("color", "red").show();
				
				// Hide both the log in/out links
				$("#navlogoutlink").hide();
				$("#navloginlink").hide();
			}
		});
	});

	// Log out	
	$("#navlogoutlink").click(function()
	{
		$.post("scripts/logout.php",
		function(data,status)
		{
			if (status == "success")
			{ 
				// Inform the user
				$("#navusermessage").html("Log out successful").css("color", "#000").show();
				
				// Toggle the log in/out links				
				$("#navloginlink").show();
				$("#navlogoutlink").hide();
				
				// Clear and hide the links
				$("#navlinks").html("").hide();
			
				// Hide the links in the main content
				$("#usermessage").html("").hide();	

				// Hide the main content
				$("main").hide();
				
				// Display the log in form
				// $("#loginformdisplay").show();
				
				// Make sure the password field is cleared
				$("#pwd").val("");
				
			}
			else
			{
				// Inform the user
				$("#navusermessage").html("Log out unsuccessful.<br />Please try again.");
			}
		});
	});
	
	// Toggle the navigation links
	$("#navhamburger").click(function()
	{
		$("#navlinks").slideToggle("slow");
	});
	
	// Log in link clicked	
	$("#navloginlink").click(function()
	{
		$("#loginformdisplay").show();
		$("#navusermessage").html("").hide();
		
	});
});