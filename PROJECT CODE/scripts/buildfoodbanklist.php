<?php
// scripts/buildfoodbanklist.php

$output  = "<label for='fbID'>Please select a Food Bank:</label><br /><br/>";
$output .= "<select id='fbID' tabindex='20' name='foodbanks'>";
$output .= "<option value=''>Please select...</option>";
			
// Get DB settings
require "config.php";

// Set up DB connection string
$dbconn = "mysql:host=$host;dbname=$db;charset=UTF8";

// Attempt to connect to DB

try 
{
	// Create new object of PDO class using credentials from config.php
	$pdo = new PDO($dbconn, $user, $password);

	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	
	// Check if successfully connected
	if ($pdo) 
	{
		// echo "Connected to the $db database successfully!";
		
		// Prepare the SQL statement
		// $sql = "SELECT fbID, fbName FROM FoodBank";
		$sql = "CALL GetAllFoodBanks ();";
	
		// Populate SELECT for Food Bank choice
		$statement = $pdo -> prepare($sql);
			
		// Bind the parameters, using column names from the DB table after the $
		$statement -> bindParam(":id", $fbID);
		$statement -> bindParam(":name", $fbName);
		
		$statement -> execute();
		
		foreach ($statement as $row) 
		{
			$output .= "<option value='" . $row["fbID"];
			$output .= "'>" . $row["fbName"];
			$output .= "</option>";
		}
		$output .= "</select>";
	}
} 
catch (PDOException $error) 
{
	// Display error details
	echo $error->getMessage();
}

// Close the connection
$pdo = null;

// $output = "DEBUG";
echo ($output);
?>