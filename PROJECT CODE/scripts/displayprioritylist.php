<?php
// displayprioritylist.php

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
		// $fbID = 2; // DEBUG because no ID passed through in test
		
		$sql = "CALL sp_GetPriorityList(".$fbID.");";
		
		// $output .= $sql;
		
		$statement = $pdo -> prepare($sql);
		
		$statement -> execute();
		
		$prioritylist = $statement -> fetchAll();
		
		// Check whether any high priority items were retrieved
		if (sizeOf($prioritylist) == 0) // No high priority items so display medium priority ones
		{
			$sql = "CALL sp_GetMediumPriorityItems(".$fbID.");";
		
			$statement = $pdo -> prepare($sql);
			
			$statement -> execute();
			
			$prioritylist = $statement -> fetchAll();
			
			$output .= '<div id="prioritylistinfo">There are no items with high priority right now, but we would be happy to receive the following:</div>';
			$output .= '<ul id="cat_list">';
			
			foreach ($prioritylist as $row) 
			{
				// Return as html formatted string for direct display
				$output .= '<li>'.$row["catName"].'</li>';
			}
			
			$output .= '</ul>';
			$output .= '</div>';
		}
		else // Display high priority items only
		{
			// $lastUpdatedDate = $prioritylist[0]["mostRecent"];
			$lastUpdatedDate = strtotime($prioritylist[0]["mostRecent"]);
			$lastUpdatedDate = date("jS F Y", $lastUpdatedDate);
		
			$output .= '<div id="priority_list_label">Priority List<br /></div>';
			$output .= '<div id="updatedate">(last updated '.$lastUpdatedDate.')</div>';
			$output .= '<div id="prioritylistinfo">The following products are urgently needed:</div>';
			$output .= '<div id="listcontainer"><ul id="cat_list">';
		
			foreach ($prioritylist as $row) 
			{
				// Return as html formatted string for direct display
				$output .= '<li>'.$row["catName"].'</li>';
			}
			$output .= '</ul></div>';
			$output .= '</div>';
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






