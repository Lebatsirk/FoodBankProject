<?php
// scripts/foodparcelassembled.php

$fbID = $_POST["fbID"];
$parcelID = $_POST["parcelID"];

/*
Considerations for this process:

Transaction isolation level 
- default is lowest (read uncommitted) but worth considering serializable to prevent access to the data while it is being changed.  If someone was to update a quantity while someone else was viewing the quantities for assembling a food parcel they might not have up-to-date accurate information.

Use: SET TRANSACTION ISOLATION LEVEL

Locks
- different types available
- public users might need to be viewing information that wouldn't influence the practical activities performed by food bank admin but admin tasks could interfere with each other
- this could be even more important with two food banks sharing a table so row-level locks are probably most appropriate

The basic syntax is:
START TRANSACTION;
	SQL TO RUN;

and then either
COMMIT; or ROLLBACK; 
depending on the result

The shared hosting being used for the proof-of-concept uses the InnoDB engine which is apparently what is needed for transactions so that is good

Exceptions can be handled within a transaction as follows:
- start the transaction with START TRANSACTION
- declare an exit handler with DECLARE EXIT HANDLER FOR SQLEXCEPTION
- start a sub-transaction with START TRANSACTION
- specify to ROLLBACK; if there is an exception
- you can also add the command RESIGNAL; which tells the engine to catch (and process) the exception and be ready in case there is another
- an END; command finishes that section before then trying the actual insert/update/etc
*/

// actually I don't need to post any quantities or categories - just the fbID and parcelID so I can find out the correct quantity per catID linked between FoodbankCategory fbID/catID and ParcelCategory parcelID/catID


// verify checkboxes are all checked as client-side thing before even loading this page

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
		// $sql = "CALL sp_UpdateAllProdCatQuantities($fbID, $parcelID)"; //DEBUG
		$sql = "CALL sp_UpdateAllProdCatQuantities(:foodbankID, :parcelID)";
		
		$statement = $pdo -> prepare($sql);
			
		// Bind the parameters, using column names from the DB table after the $
		$statement -> bindParam(":foodbankID", $fbID);
		$statement -> bindParam(":parcelID", $parcelID);
		
		$statement -> execute();
		
		// Result set determines if matching record found
		// $result = $statement -> fetch();
		
		$output .= "Product category quantities for food parcel updated successfully.";
		
		// $output .= $result;
	}
} 
catch (PDOException $error) 
{
	// Display error details
	if ($error->getCode() == "23000")
	{
		$output .= "<span class='errormessage'>Insufficient quantity available of one or more product categories for selected food parcel size</span>";
	} 	
	else
	{
		$output .= $error->getMessage();
	}
}

// Close the connection
$pdo = null;

// $output = "DEBUG";
echo ($output);
?>