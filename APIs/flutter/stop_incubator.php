<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

$host = 'localhost';
$dbname = 'sgm_database';
$username = 'root';
$password = 'admin';

// Connect to database
$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get incubatorID from request
$incubatorID = isset($_POST['incubatorID']) ? $_POST['incubatorID'] : '';

// Update the last record in incubator_status table to stop the incubator
$sql = "UPDATE incubator_status SET is_running = 0, end_time = NOW() 
        WHERE incubatorID = ? 
        ORDER BY status_Id DESC LIMIT 1";

$stmt = $conn->prepare($sql);
$stmt->bind_param('i', $incubatorID);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'failure']);
}

$stmt->close();
$conn->close();
?>
