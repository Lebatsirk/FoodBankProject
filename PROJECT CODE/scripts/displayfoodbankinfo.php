<?php
// displayfoodbankinfo.php

$fbID = $_POST["fbID"];

$output = "";

// $output .= "Food Bank ID is ".$fbID;

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
		// $output .= "Connected to the $db database successfully!";
		
		// $sql = ("SELECT fbID, fbName, fbEmail, fbPhone, fbWebsite FROM FoodBank WHERE fbID = :fbID;");
		
		$sql = "CALL GetSpecificFoodBank(".$fbID.");";
		
		// $output .= $sql;
		
		$statement = $pdo -> prepare($sql);
		
		// Bind the parameters, using column names from the DB table after the $
		// $statement -> bindParam(":name", $fbName);
		// $statement -> bindParam(":email", $fbEmail);
		// $statement -> bindParam(":phone", $fbPhone);
		// $statement -> bindParam(":website", $fbWebsite);
		
		//$statement -> execute([$_GET[0]]);
		$statement -> execute();
		
		$foodbankrecord = $statement -> fetch();
		
		if ($foodbankrecord)
		{
			// Return as html formatted string for direct display
			$output .= '<div id="fb_name">'.$foodbankrecord["fbName"].'</div>';
			$output .= '<div id="fb_email">Email:</div><div id="fb_email_content">'.$foodbankrecord["fbEmail"].'</div>';
			$output .= '<div id="fb_phone">Phone:</div><div id="fb_phone_content">'.$foodbankrecord["fbPhone"].'</div>';
			$output .= '<div id="fb_website">Website:</div><div id="fb_website_content">'.$foodbankrecord["fbWebsite"].'</div>';
		}
		else
		{
			$output .= "Food Bank with ID $fbID not found";
		}
		
		echo $output;		
	}
} 
catch (PDOException $error) 
{
	// Display error details
	echo $error->getMessage();
}

// Close the connection
$pdo = null;
?>






