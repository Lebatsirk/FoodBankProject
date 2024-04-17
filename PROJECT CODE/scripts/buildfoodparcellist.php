<?php
// scripts/buildfoodparcellist.php

$output  = "<label for='parcelID'>Please select a Food Parcel size:</label><br /><br/>";
$output .= "<select id='parcelID' tabindex='20' name='foodparcels'>";
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
		$sql = "SELECT parcelID, parcelType FROM vw_GetParcelTypes";
		
		// Populate SELECT for Food Bank choice
		$statement = $pdo -> prepare($sql);
			
		$statement -> execute();
		
		foreach ($statement as $row) 
		{
			$output .= "<option value='" . $row["parcelID"];
			$output .= "'>" . $row["parcelType"];
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

echo ($output);
?>