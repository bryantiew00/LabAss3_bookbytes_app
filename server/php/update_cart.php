<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$cartid = $_POST['cartid'];
$newqty = $_POST['newqty'];

// Check if books are available before updating the cart
if (checkBookAvailability($cartid, $newqty, $conn)) {
    // Books are available, proceed with updating the cart
    $sql = "UPDATE `tbl_carts` SET `cart_qty` = $newqty WHERE  `cart_id` = '$cartid'";

    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => $sql);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => $conn->error);
        sendJsonResponse($response);
    }
} else {
    // Books are not available, send a response indicating failure
    $response = array('status' => 'failed', 'data' => 'Books not available');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

function checkBookAvailability($cartid, $newqty, $conn)
{
    // Retrieve book information from tbl_carts
    $selectCartSql = "SELECT book_id FROM tbl_carts WHERE cart_id = '$cartid'";
    $cartResult = $conn->query($selectCartSql);
    $cartRow = $cartResult->fetch_assoc();
    $bookId = $cartRow['book_id'];

    // Check if books are available in tbl_books
    $selectBookSql = "SELECT book_qty FROM tbl_books WHERE book_id = '$bookId'";
    $bookResult = $conn->query($selectBookSql);
    $bookRow = $bookResult->fetch_assoc();
    $availableQuantity = $bookRow['book_qty'];

    return $availableQuantity >= $newqty;
}
?>
