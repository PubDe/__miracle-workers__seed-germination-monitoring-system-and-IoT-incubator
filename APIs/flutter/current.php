<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "admin";
$dbname = "sgm_database";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM seed_count ORDER BY image_id DESC LIMIT 1";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
  // Output data of the last record
  $row = $result->fetch_assoc();
  echo json_encode($row);
} else {
  echo json_encode(array("error" => "No data found"));
}
$conn->close();
?>
