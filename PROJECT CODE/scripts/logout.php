<?php
// logout.php

session_start();
session_unset();
session_destroy();
// $_SESSION = array();

// echo "DEBUG : size of $_SESSION array is " . sizeof($_SESSION) . "<br />";
?>