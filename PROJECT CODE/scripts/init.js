$(document).ready(function()
{
	console.log("loaded init.js"); //DEBUG
	
	// Set up a variable to store the food bank ID in
	var $fbID;
	
	const $publicPage = "FR2FR3.html";
	const $adminMenu = "FR8.html";
	var $currentURL = window.location.pathname;
	var $currentPage = $currentURL.substr(($currentURL.indexOf("TM470/"))+6);
	
	console.log("Attempting to retrieve session data init.js ln3"); //DEBUG
	
	// Attempt to retrieve session data 
	$.get("scripts/init.php", 
	function(data,status){
		
		if (data != "")
		{
			// Session data exists so display content
			$sessionData = JSON.parse(data.trim());
			
			console.log("The fbID is " + $sessionData.fbID); //DEBUG
			$fbID = $sessionData.fbID;
			
			// Hide the login form
			$("#loginformdisplay").hide();
			
			console.log("User " + $sessionData.username + " is logged in "
								+ "with access level " + $sessionData.accesstype
								); //DEBUG

			// Call function to build menu links based on access type
			$builder = buildMenuLinks($sessionData.accesstype);
			
			console.log("ARE YOU ALLOWED TO BE HERE? access type: " + $sessionData.accesstype); //DEBUG	
			
			// No main content to display for admin menu if already logged in, so inform user
			if (($currentPage = $currentURL.substr(($currentURL.indexOf("TM470/"))+6)) == $adminMenu)
			{
				$("#usermessage").html("Please use button above to select available admin tasks.").css("color", "#000").css("backgroundColor", "#FFF").show();
			}
			
			// Default to menu hidden at first
			$("#navlinks").html($builder).hide();

			// Show the log out link
			$("#navlogoutlink").show();
			
			// User message not required because there is content to display (not FR8 login page)			
			// $("#usermessage").html("Please use button above to view links for available admin tasks.").css("backgroundColor", "#FFF").show();
		}
		else
		{
			// No session data retrieved (could be invalid log in or public page view)
			console.log("init.js ln 82: no session data retrieved"); //DEBUG
		
			// This situation would not occur in real implementation because 
			// public page and admin part of system would be accessed separately
			// so this workaround is for proof-of-concept only
			// if (indexOf.
			
			if ((window.location.href.indexOf($publicPage)) != -1)
			{
				// Public page (FR2/FR3)
				// Show the main content
				console.log("init.js ln 93: show main content"); //DEBUG
				$("main").show();
			}
			else
			{
				// Show login form
				console.log("init.js ln 99: display login form"); //DEBUG
				$("#loginformdisplay").show();
				
				// Hide the main content
				console.log("init.js ln 103: hide main content"); //DEBUG
				$("main").hide();
			}
			
		}
	});
		
});