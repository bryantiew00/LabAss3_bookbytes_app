<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
	echo("if not Post");
    die();
}

include_once("dbconnect.php");

$cartid = $_POST['cartid'];

$sqldeletecart = "DELETE FROM `tbl_carts` WHERE `cart_id` = '$cartid'";

if ($conn->query($sqldeletecart) === TRUE) {
	//echo("enter if true");
	$response = array('status' => 'success', 'data' => null);
	//echo("passed response success");
    sendJsonResponse($response);
	//echo("sent response");
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>