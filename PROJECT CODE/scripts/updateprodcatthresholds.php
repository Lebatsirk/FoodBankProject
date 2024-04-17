<?php
// scripts/updateprodcatthresholds.php

$foodbankID = $_POST["fbID"];
$prodcatID = $_POST["catID"];
$newMinThreshold = $_POST["newMinThreshold"];
$newMaxThreshold = $_POST["newMaxThreshold"];

$output = "";

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
		$sql = "CALL sp_UpdateInsertProdCatThresholds(:foodbankID, :prodcatID, :newMinThreshold, :newMaxThreshold);";
	
		// echo "CALL sp_UpdateInsertProdCatThresholds(:".$foodbankID.", :".$prodcatID.", :".$newMinThreshold.", :".$newMaxThreshold.");";
		
		// Populate SELECT for Food Bank choice
		$statement = $pdo -> prepare($sql);
			
		// Bind the parameters, using column names from the DB table after the $
		$statement -> bindParam(":foodbankID", $foodbankID);
		$statement -> bindParam(":prodcatID", $prodcatID);
		$statement -> bindParam(":newMinThreshold", $newMinThreshold);
		$statement -> bindParam(":newMaxThreshold", $newMaxThreshold);
		
		$statement -> execute();
		
		// Result set determines if matching record found
		$result = $statement -> fetch();
		
		$output .= $result;
		// if (is_array($loggedInUser))

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