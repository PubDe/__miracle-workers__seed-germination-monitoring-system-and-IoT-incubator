<?php
header('Access-Control-Allow-Origin: *'); // Allow all origins
header('Access-Control-Allow-Methods: POST, GET, OPTIONS'); // Allow specific HTTP methods
header('Access-Control-Allow-Headers: Content-Type, Authorization'); // Allow specific headers

$servername = "localhost";
$username = "root"; // Default WAMP username
$password = "admin"; // Default WAMP password
$dbname = "sgm_database";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $incubatorID = $_POST['incubatorID'];
    $password = $_POST['password'];

    $sql = "SELECT * FROM incubator WHERE incubatorID = ? AND password = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("is", $incubatorID, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode(array("status" => "success", "message" => "Login successful"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Invalid incubator ID or password"));
    }

    $stmt->close();
} else {
    echo json_encode(array("status" => "error", "message" => "Invalid request"));
}

$conn->close();
?>
