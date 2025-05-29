<?php
include 'db_connect.php';

$work_id = $_POST['work_id'];
$worker_id = $_POST['worker_id'];
$submission_text = $_POST['submission_text'];

$sql = "INSERT INTO tbl_submissions (work_id, worker_id, submission_text)
        VALUES ('$work_id', '$worker_id', '$submission_text')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => $conn->error]);
}
?>
