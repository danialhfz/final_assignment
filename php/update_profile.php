<?php
include "db_connect.php";

$worker_id = $_POST['worker_id'];
$full_name = $_POST['full_name'];
$phone = $_POST['phone'];
$address = $_POST['address'];

$sql = "UPDATE workers 
        SET full_name = '$full_name', phone = '$phone', address = '$address' 
        WHERE id = '$worker_id'";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => $conn->error]);
}
?>
