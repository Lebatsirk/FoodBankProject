<?php
session_start();

// echo session_status() . PHP_SESSION_ACTIVE . PHP_SESSION_NONE; //DEBUG
// echo sizeof($_SESSION); //DEBUG

if((session_status() == PHP_SESSION_ACTIVE) && (sizeof($_SESSION) > 0))
{
	$loginattempted = $_SESSION["loginattempted"];
	$loggedin = $_SESSION["loggedin"];
	$username = $_SESSION["username"];
	$accesstype = $_SESSION["accesstype"];	
	$fbID = $_SESSION["fbID"];
	
	echo json_encode($_SESSION);
}
?>