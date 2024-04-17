<?php
// displayprodcatinfothresholds.php

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
							"quantity"=>$prodcatrecord["quantity"], 
							"minthreshold"=>$prodcatrecord["minThreshold"], 
							"maxthreshold"=>$prodcatrecord["maxThreshold"]);
		
		// $output .= '<p style="text-decoration: underline;">Current thresholds for <span id="prodcatname">';
		// $output .= $prodcatrecord["catName"] . '</span></p>';
		// $output .= '<p>Current quantity in stock: <span id="current_qty">' . $prodcatrecord["quantity"] . '</span></p>';
				
		// $output .= '<label id="minthresholdlabel" for="totaldisplay">minimum</label>';
		// $output .= '<input id="minthreshold" tabindex="21" type="button" value="' . $prodcatrecord["minThreshold"] . '" />';
		// $output .= '<label id="maxthresholdlabel" for="maxthreshold">maximum</label>';
		// $output .= '<input id="maxthreshold" tabindex="22" type="button" value="' . $prodcatrecord["maxThreshold"] . '" />';
		
		echo json_encode($dataArray);		
		// echo $output;		
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