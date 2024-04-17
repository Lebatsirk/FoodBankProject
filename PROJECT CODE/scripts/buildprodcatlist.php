<?php
// scripts/buildprodcatlist.php

$output  = "<label for='catID'>Please select a Product Category:</label><br /><br/>";
$output .= "<select id='catID' tabindex='20' name='prodcats'>";
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
		$sql = "CALL GetAllProductCategories();";
	
		// Populate SELECT for Product Category choice
		$statement = $pdo -> prepare($sql);
			
		// Bind the parameters, using column names from the DB table after the $
		$statement -> bindParam(":id", $catID);
		$statement -> bindParam(":name", $catName);
		
		$statement -> execute();
		
		foreach ($statement as $row) 
		{
			$output .= "<option value='" . $row["catID"];
			$output .= "'>" . $row["catName"];
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






