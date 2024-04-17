<?php
// scripts/updateprodcatquantity.php

$foodbankID = $_POST["fbID"];
$prodcatID = $_POST["catID"];
$newQuantity = $_POST["newQuantity"];

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
		// $sql = "CALL sp_UpdateProdCat(:foodbankID, :prodcatID, :newQuantity);";
		$sql = "CALL sp_UpdateInsertProdCatQty(:foodbankID, :prodcatID, :newQuantity);";
	
		// Populate SELECT for Food Bank choice
		$statement = $pdo -> prepare($sql);
			
		// Bind the parameters, using column names from the DB table after the $
		$statement -> bindParam(":foodbankID", $foodbankID);
		$statement -> bindParam(":prodcatID", $prodcatID);
		$statement -> bindParam(":newQuantity", $newQuantity);
		
		$statement -> execute();
		
		// Result set determines if matching record found
		$result = $statement -> fetch();
		
		$output .= $result;
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