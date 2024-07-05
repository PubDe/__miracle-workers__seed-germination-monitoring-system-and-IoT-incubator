<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$servername = "localhost";
$username = "root";
$password = "admin";
$dbname = "flutter";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$incubatorID = $_POST['incubatorID'];
$temperature = $_POST['temperature'];
$humidity = $_POST['humidity'];
$light_level = $_POST['light_level'];

$sql = "UPDATE incubators SET temperature = ?, humidity = ?, light_level = ? WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssss", $temperature, $humidity, $light_level, $incubatorID);

$response = array();

if ($stmt->execute()) {
    $response['status'] = 'success';
} else {
    $response['status'] = 'error';
}

$stmt->close();
$conn->close();

echo json_encode($response);
?>
