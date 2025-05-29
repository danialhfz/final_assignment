<?php
include 'db_connect.php';

$worker_id = $_POST['worker_id'];

$sql = "SELECT * FROM tbl_works WHERE assigned_to = '$worker_id'";
$result = $conn->query($sql);

$tasks = [];

while ($row = $result->fetch_assoc()) {
    $tasks[] = $row;
}

echo json_encode($tasks);
?>
