<?php
// scripts/displayprodcatinfo.php

$catID = $_POST["catID"];
$fbID = $_POST["fbID"];

$output = "";

// $output .= "Product Category ID is ".$catID;
// $output .= "Foodbank ID is ".$fbID;

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
		
		$sql = "CALL sp_GetProdCatDetails(".$catID.", ".$fbID.");";
		
		$statement = $pdo -> prepare($sql);
		
		$statement -> execute();
		
		$prodcatrecord = $statement -> fetch();
		
		$dataArray = array("catName"=>$prodcatrecord["catName"], 
							"quantity"=>$prodcatrecord["quantity"]);
		
		echo json_encode($dataArray);	
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