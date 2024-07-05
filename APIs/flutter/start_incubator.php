<?php
header('Access-Control-Allow-Origin: *'); // Allow all origins
header('Access-Control-Allow-Methods: POST, GET, OPTIONS'); // Allow specific HTTP methods
header('Access-Control-Allow-Headers: Content-Type, Authorization'); // Allow specific headers

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

// Get current server timestamp for start_time
$start_time = date('Y-m-d H:i:s'); // Current server time

// Fetch last record values for the given incubatorID
$sql = "SELECT temperature, humidity, light_level FROM incubator_status WHERE incubatorID = ? ORDER BY status_Id DESC LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param('i', $incubatorID);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $temperature = $row['temperature'];
    $humidity = $row['humidity'];
    $light_level = $row['light_level'];
} else {
    $temperature = '';
    $humidity = '';
    $light_level = '';
}

// Insert or update the record in incubator_status table
$sql = "INSERT INTO incubator_status (incubatorID, temperature, humidity, light_level, is_running, start_time) VALUES (?, ?, ?, ?, 1, ?)
        ON DUPLICATE KEY UPDATE temperature=VALUES(temperature), humidity=VALUES(humidity), light_level=VALUES(light_level), is_running=1, start_time=VALUES(start_time)";

$stmt = $conn->prepare($sql);
$stmt->bind_param('issss', $incubatorID, $temperature, $humidity, $light_level, $start_time);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'failure']);
}

$stmt->close();
$conn->close();
?>
