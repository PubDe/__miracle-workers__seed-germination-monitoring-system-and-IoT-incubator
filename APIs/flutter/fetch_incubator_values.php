<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept');

include 'db_connection.php';

if (isset($_POST['incubatorID'])) {
    $incubatorID = $_POST['incubatorID'];

    // Assuming 'status_Id' is part of the primary key and auto-generated
    $query = "SELECT temperature, humidity, light_level, is_running FROM incubator_status WHERE incubatorID = '$incubatorID' ORDER BY status_Id DESC LIMIT 1";
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode([
            'status' => 'success',
            'temperature' => $row['temperature'],
            'humidity' => $row['humidity'],
            'light_level' => $row['light_level'],
            'is_running' => $row['is_running']
        ]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'No data found']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'No incubatorID provided']);
}
?>
