<?php
// login.php

//inputs = test_username and test_pwd, button = test_login, results display = loginresult

// Check for cookies
// require "cookie.php";
		
// Get info from html fields
$username = $_POST["username"];
$pwd = $_POST["pwd"];
// $fbID = $_POST["fbID"];
$userID = 0;
$userAccessType = 0;

$output = "";

// Get DB settings
require "config.php";

// require "set_cookies.php";

// Set a cookie for indicate that log in has been attempted
// setcookie("loginattempted", true, 60, "/", false); // Ideally secure should be set to true but cannot do this with self-signed certificate	

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
		//DEBUG echo "Connected to the $db database successfully!<br /><br />";
		
		//$statement = $pdo -> prepare("CALL InsertTemp(:name, :qty)");
		//$statement = $pdo -> prepare("CALL UpdateTempItem(:name, :qty)");
		
		//$sql = "SELECT userID, userAccessType FROM LoginInfo WHERE userName = ".$username." AND userPwd = ".MD5($pwd);
		
		// $sql = "SELECT userID, userName, userAccessType FROM LoginInfo WHERE userName = '";
		// $sql .= $username . "' AND userPwd = '" . MD5($pwd) . "' AND fbID = " . $fbID;
		
		$sql = "SELECT userID, userName, userAccessType, fbID FROM LoginInfo WHERE userName = '";
		$sql .= $username . "' AND userPwd = '" . MD5($pwd) . "'";
		
		// $sql = "CALL sp_Login(:foodbankID, :username, :pwd, :userID, :userAccessType);";
		
		// $hashedpwd = MD5($pwd);
		
		// $sql = "CALL sp_Login(".$fbID.", ".$username.", ".$hashedpwd.", ".$userID.", ".$userAccessType."); SELECT $userID AS userID, $userAccessType AS userAccessType";
		
		// $output .= $sql;
		
		// $statement = $pdo -> prepare("SELECT userID, userAccessType FROM LoginInfoDemo WHERE userName = :username AND userPwd = MD5(:pwd) AND fbID = :fbID");
		$statement = $pdo -> prepare($sql);
		
		// $statement -> bindParam(":foodbankID", $fbID);
		// $statement -> bindParam(":username", $username);
		// $statement -> bindParam(":hashedpwd", $hashedpwd);
		// $statement -> bindParam(":userID", $userID);
		// $statement -> bindParam(":userAccessType", $userAccessType);
		
		$statement -> execute();
		
		
		// echo("After pureeing fruit, the colour is: $userID $userAccessType");
		
		// $tm470AccessType = $userAccessType;
			
		// CREATE PROCEDURE `sp_LoginTest`(IN `foodbankID` INT, IN `username` VARCHAR(150), IN `hashedpwd` VARCHAR(100), OUT `userID` INT, OUT `userAccessType` INT) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER SELECT userID, userAccessType FROM LoginInfo WHERE fbID = foodbankID AND userName = username AND userPwd = MD5(hashedpwd)

		
		// Result set determines if matching record found
		// $loggedInUser = $statement -> fetch();
		$dataArray = $statement -> fetch();
		
		// echo "<br />CHECK A: data array is size " . sizeof($dataArray);
		
		SESSION_START(); //NEW
			
		//NEW
		$_SESSION["loginattempted"] = true;
		if (($dataArray["userAccessType"] != null))
		{
			$_SESSION["loggedin"] = true;
		}
		else
		{
			$_SESSION["loggedin"] = false;			
		}
		$_SESSION["username"] = $dataArray["userName"];
		$_SESSION["accesstype"] = $dataArray["userAccessType"];
		$_SESSION["fbID"] = $dataArray["fbID"];
		
		echo json_encode($_SESSION);
		//END NEW
		
			
		// TO DO next block is original working content	
/* 		if ($dataArray != null) 
		{
			// Set cookies for the logged-in user
			setTM470Cookies($username, MD5($pwd), $dataArray["userAccessType"], $fbID);
			
			// echo "<br />CHECK B: cookies have just been set<br />";
			
			$dataArray = array("loginattempted"=>true,
								"loggedin"=>true,
								"username"=>$dataArray["userName"],
								"accesstype"=>$dataArray["userAccessType"]);

		}
		else		
		{
			$dataArray = array("loginattempted"=>true,
								"loggedin"=>false,
								"username"=>"",
								"accesstype"=>0);
		}
		
		echo json_encode($dataArray); */
		
		// echo $loggedInUser;
		
/* 		if (is_array($loggedInUser))
		{
			$tm470AccessType = $loggedInUser[1];
			
			$output .= "<p>User ".$username." is logged in.</p>"; 
			$output .= "<p>DISPLAY ACTIONS APPROPRIATE TO LEVEL ".$tm470AccessType."</p>";
			
			// Set cookies for logged-in user
			setTM470Cookies($username, MD5($pwd), $tm470AccessType, (time() + COOKIE_EXPIRY)); 
			
			//DEBUG2
			//, (time() + COOKIE_EXPIRY)
		}
		else
		{
			$output .= "<p>Could not log user ".$username." in.</p>";
			$output .= "<p>INFORM USER OF OPTIONS</p>";
			
			$output .= "<p>Sorry, you do not have permission to access this page.";
			
			// Delete cookies because user not allowed to view that page
			setTM470Cookies($username, $pwd, $tm470AccessType, (time()-3600));
		}
		 */
		/*
		
		// Get the ID of the inserted record
		$tempID = $pdo -> lastInsertId();

		//DEBUG$output .= "Added record " . $tempID . " to database.";
		
		// Get the specific item for display
		//$sql = "CALL GetSpecificItem(:record_id)";
		
		// Get a list of all items for display
		//$sql = "CALL GetAllItems()";
		$sql = "SELECT tempID, tempName, quantity FROM TEMP"; // For DEBUG to see if item added when using stored procedure
		
		// Prepare the statement
		$statement = $pdo -> prepare($sql);
		
		// The following line is only for stored procedures with parameters
		//$statement -> bindParam(":record_id", $record_id, PDO::PARAM_INT);
		
		// Execute the statement
		$statement -> execute();
		
		// For single record return
		//$item = $statement -> fetch();
		// Add the returned item to the output (no formatting for now)
		//$output .= $item["tempName"] . $item["quantity"];
		
		// For multiple record return
		$items = $statement -> fetchAll();
		
		// Build start of display list
		$output .= "<ul>";
		
		// Iterate through all items, adding them to the output (no formatting for now)
		foreach ($items as $item)
		{
			// Highlight the added item
			if ($tempID == $item["tempID"]) 
			{
				$output .= "<li><b>" . $item["tempName"] . " : " . $item["quantity"] . "</b></li>"; 
			}
			else
			{
				$output .= "<li>" . $item["tempName"] . " : " . $item["quantity"] . "</li>"; 	
			}
		}
		
		// Build end of display list
		$output .= "</ul>";
		*/
		
		// Return the output for display
		echo $output;
	}
} 
catch (PDOException $error) 
{
	// Display error details
	echo $error -> getMessage();
}

// Close the connection
$pdo = null;
?>