<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

include 'db_connection.php';

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Log POST data for debugging
file_put_contents('fetch_values_debug.txt', print_r($_POST, true));

// Check if incubatorID is provided via POST
if (!isset($_POST['incubatorID'])) {
    echo json_encode(array('error' => 'No incubatorID provided', 'post_data' => $_POST));
    exit();
}

$incubatorID = $conn->real_escape_string($_POST['incubatorID']);

$query = "SELECT temperature, humidity, light_level, start_time FROM incubator_status WHERE incubatorID = '$incubatorID' ORDER BY status_Id DESC LIMIT 1";
$result = $conn->query($query);

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $response = array(
        'temperature' => $row['temperature'],
        'humidity' => $row['humidity'],
        'light_level' => $row['light_level'],
        'start_time' => $row['start_time'], // Include start_time in response
    );
    echo json_encode($response);
} else {
    echo json_encode(array('error' => 'Failed to fetch values', 'query' => $query, 'result' => $result));
}

$conn->close();
?>
