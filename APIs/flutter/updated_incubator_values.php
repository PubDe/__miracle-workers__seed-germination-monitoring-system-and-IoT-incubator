<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

include 'db_connection.php';

// Log POST data for debugging
file_put_contents('update_incubator_values_debug.txt', print_r($_POST, true));

// Check if required fields are provided
if (!isset($_POST['incubatorID'], $_POST['temperature'], $_POST['humidity'], $_POST['light_level'])) {
    echo json_encode(['status' => 'error', 'message' => 'Missing required fields', 'post_data' => $_POST]);
    exit();
}

$incubatorID = $conn->real_escape_string($_POST['incubatorID']);
$temperature = $conn->real_escape_string($_POST['temperature']);
$humidity = $conn->real_escape_string($_POST['humidity']);
$lightLevel = $conn->real_escape_string($_POST['light_level']);

$query = "INSERT INTO incubator_status (incubatorID, temperature, humidity, light_level, is_running, start_time, end_time) 
          VALUES ('$incubatorID', '$temperature', '$humidity', '$lightLevel', 0, NULL, NULL)";

if ($conn->query($query) === TRUE) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => $conn->error, 'query' => $query]);
}

$conn->close();
?>
