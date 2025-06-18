<?php
include "db_connect.php";

$worker_id = $_POST['worker_id'];

$sql = "SELECT s.id, s.work_id, s.submission_text, s.submitted_at, w.title 
        FROM tbl_submissions s 
        JOIN tbl_works w ON s.work_id = w.id 
        WHERE s.worker_id = '$worker_id'
        ORDER BY s.submitted_at DESC";

$result = $conn->query($sql);
$submissions = [];

while ($row = $result->fetch_assoc()) {
    $submissions[] = $row;
}

echo json_encode($submissions);
?>
