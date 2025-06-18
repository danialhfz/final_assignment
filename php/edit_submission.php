<?php
include "db_connect.php";

$submission_id = $_POST['submission_id'];
$submission_text = $_POST['submission_text'];

$sql = "UPDATE tbl_submissions 
        SET submission_text = '$submission_text', submitted_at = NOW() 
        WHERE id = '$submission_id'";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => $conn->error]);
}
?>
