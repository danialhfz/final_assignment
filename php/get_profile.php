<?php
include "db_connect.php";

$worker_id = $_POST['worker_id'];

$sql = "SELECT * FROM workers WHERE id = '$worker_id'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo json_encode($result->fetch_assoc());
} else {
    echo json_encode(null);
}
?>
