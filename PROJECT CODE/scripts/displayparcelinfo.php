<?php
// displayparcelinfo.php

$fbID = $_POST["fbID"];
$parcelID = $_POST["parcelID"];

// WORK ON SQL FOR RETRIEVAL OF PARCEL QUANTITIES FOR SPECIFIC FOOD BANK NEXT!

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
		
		// $sql = "CALL sp_GetProdCatsForParcelSize(:parcel_id, foodbank_id);";
		
		$sql = "CALL sp_GetProdCatsForParcelSize(" . $parcelID . ", " . $fbID . ");"; //:parcel_id, foodbank_id);";
		
		$statement = $pdo -> prepare($sql);
		
		// Bind the parameters, using column names from the DB table after the $
		// $statement -> bindParam(":parcel_id", $parcelID);
		// $statement -> bindParam(":foodbank_id", $fbID);
		
		$statement -> execute();
		
		$parcelrecords = $statement -> fetchAll();
		
		// $output .= $parcelrecords;
		
		// $output .= '<!-- Headings -->';
		// $output .= '<div id="heading_prodcatname">Product Category</div>';
		// $output .= '<div id="heading_amount">Amount</div>';
		// $output .= '<!-- Content -->';

		// $foodparcelArray = array("singlerecord"=>$parcelrecords,
						// "username"=>$username,
						// "accesstype"=>$tm470AccessType);
		
		
		echo json_encode($parcelrecords);
	
	
		// foreach ($parcelrecords as $row) 
		// {
			// Return as html formatted string for direct display
			// $output .= '<li>'.$row["catName"].'</li>';
			/* if ($row["notEnough"])
			{
				$output .= "<b>";
				$output .= $row["catName"].$row["amount"];
				$output .= "</b>";
			}
			else
			{
				$output .= $row["catName"].$row["amount"];
			}
			$output .= "<br />"; */
			
			
			
			/* if ($row["notEnough"])
			{
				$output .= '<div id="checkbox_col"><input type="checkbox" id="checkboxes" class="parceltickbox" value="'.$row["catID"].'"></div>';
				$output .= '<div id="prodcatname_col" class="notenough"><label for="checkboxes">'.$row["catName"].'</label></div>';
				$output .= '<div id="amount_col">'.$row["amount"].'</div>';
			}
			else
			{
				$output .= '<div id="checkbox_col"><input type="checkbox" id="checkboxes" class="parceltickbox" value="'.$row["catID"].'"></div>';
				$output .= '<div id="prodcatname_col"><label for="checkboxes">'.$row["catName"].'</label></div>';
				$output .= '<div id="amount_col">'.$row["amount"].'</div>';
			} */		
					
		}
	 
		// Check whether any high priority items were retrieved
		/* if (sizeOf($prioritylist) == 0) // No high priority items so display medium priority ones
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
		 */
/* 		if ($foodbankrecord)
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
		 */
		// echo $output;		
	// }
} 
catch (PDOException $error) 
{
	// Display error details
	echo $error->getMessage();
}

// Close the connection
$pdo = null;
?>






