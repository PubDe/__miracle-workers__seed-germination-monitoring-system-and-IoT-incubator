i want backend of start button of configure(configure.dart) when  i pressed start button  make new record in sgm_database
 incubator_status table.our button press time is start_time also configure interface already have values for
  humidity,temperature and light level that values. also pass to the table.is_running status=1 while run.so while pressed stop button that end_time values should null when pressed 
  stop button it fill as end_time of previous record.mention that after press start button that button turn into stop button 
  (red squre) and also pressed stop button it goes again like start button.
. .  i wanted extra dart file and php files for that because other interface and 
 backend succesfully build and connected with databases correctly. so i want new dart and php files with connected with 
 already created files







configure.dart - import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfigureViewScreen extends StatefulWidget {
  final String incubatorID;
  final Function(String, String, String) updateValues;

  const ConfigureViewScreen({
    super.key,
    required this.incubatorID,
    required this.updateValues,
  });

  @override
  _ConfigureViewScreenState createState() => _ConfigureViewScreenState();
}

class _ConfigureViewScreenState extends State<ConfigureViewScreen> {
  String temperature = '';
  String humidity = '';
  String lightLevel = '';
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentValues();
  }

  Future<void> _fetchCurrentValues() async {
    final response = await http.post(
      Uri.parse('http://localhost/flutter/fetch_incubator_values.php'),
      body: {'incubatorID': widget.incubatorID},
    );
    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      setState(() {
        temperature = data['temperature'];
        humidity = data['humidity'];
        lightLevel = data['light_level'];
        isRunning = data['is_running'] == 1;
      });
    }
  }

  Future<void> _toggleIncubator() async {
    final endpoint = isRunning ? 'stop_incubator.php' : 'start_incubator.php';
    final response = await http.post(
      Uri.parse('http://localhost/flutter/$endpoint'),
      body: {'incubatorID': widget.incubatorID},
    );
    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      setState(() {
        isRunning = !isRunning;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Configure Incubator'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Configure Incubator',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildConfigTextField(
                controller: TextEditingController(text: temperature),
                label: 'Temperature',
                icon: Icons.thermostat,
              ),
              const SizedBox(height: 20),
              _buildConfigTextField(
                controller: TextEditingController(text: humidity),
                label: 'Humidity',
                icon: Icons.water_drop,
              ),
              const SizedBox(height: 20),
              _buildConfigTextField(
                controller: TextEditingController(text: lightLevel),
                label: 'Light Level',
                icon: Icons.wb_sunny,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _toggleIncubator,
                icon: Icon(isRunning ? Icons.stop : Icons.play_arrow,
                    color: Colors.white),
                label: Text(isRunning ? 'Stop' : 'Start'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRunning ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditValuesScreen(
                        incubatorID: widget.incubatorID,
                        updateValues: widget.updateValues,
                      ),
                    ),
                  );
                },
                child: const Text('Edit Values'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 30),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class EditValuesScreen extends StatefulWidget {
  final String incubatorID;
  final Function(String, String, String) updateValues;

  const EditValuesScreen({
    super.key,
    required this.incubatorID,
    required this.updateValues,
  });

  @override
  _EditValuesScreenState createState() => _EditValuesScreenState();
}

class _EditValuesScreenState extends State<EditValuesScreen> {
  late TextEditingController _temperatureController;
  late TextEditingController _humidityController;
  late TextEditingController _lightLevelController;

  @override
  void initState() {
    super.initState();
    _temperatureController = TextEditingController();
    _humidityController = TextEditingController();
    _lightLevelController = TextEditingController();
    _fetchCurrentValues();
  }

  Future<void> _fetchCurrentValues() async {
    final response = await http.post(
      Uri.parse('http://localhost/flutter/fetch_values.php'),
      body: {'incubatorID': widget.incubatorID},
    );
    final data = json.decode(response.body);

    setState(() {
      _temperatureController.text = data['temperature'];
      _humidityController.text = data['humidity'];
      _lightLevelController.text = data['light_level'];
    });
  }

  Future<void> _saveChanges() async {
    await http.post(
      Uri.parse('http://localhost/flutter/updated_values.php'),
      body: {
        'incubatorID': widget.incubatorID,
        'temperature': _temperatureController.text,
        'humidity': _humidityController.text,
        'light_level': _lightLevelController.text,
      },
    );
    widget.updateValues(_temperatureController.text, _humidityController.text,
        _lightLevelController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Edit Incubator Values'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Edit Incubator Values',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildConfigTextField(
                label: 'Temperature',
                controller: _temperatureController,
                hintText: 'Enter Temperature',
                readOnly: false,
                icon: Icons.thermostat,
              ),
              const SizedBox(height: 20),
              _buildConfigTextField(
                label: 'Humidity',
                controller: _humidityController,
                hintText: 'Enter Humidity',
                readOnly: false,
                icon: Icons.water_drop,
              ),
              const SizedBox(height: 20),
              _buildConfigTextField(
                label: 'Light Level',
                controller: _lightLevelController,
                hintText: 'Enter Light Level',
                readOnly: false,
                icon: Icons.wb_sunny,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool readOnly,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 30),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              labelText: label,
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
} db_connection.php - <?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "sgm_database";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
distinct_ID.php - <?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept');

include 'db_connection.php'; // Update this to your database connection file

$query = "SELECT incubatorID FROM incubator_status ORDER BY id DESC LIMIT 1";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode(['status' => 'success', 'incubatorID' => $row['incubatorID']]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'No data found']);
}
?>
EditValuesScreen.dart - import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditValuesScreen extends StatefulWidget {
  final String incubatorID;
  final Function(String, String, String) updateValues;

  const EditValuesScreen({
    super.key,
    required this.incubatorID,
    required this.updateValues,
  });

  @override
  _EditValuesScreenState createState() => _EditValuesScreenState();
}

class _EditValuesScreenState extends State<EditValuesScreen> {
  late TextEditingController _temperatureController;
  late TextEditingController _humidityController;
  late TextEditingController _lightLevelController;

  @override
  void initState() {
    super.initState();
    _temperatureController = TextEditingController();
    _humidityController = TextEditingController();
    _lightLevelController = TextEditingController();
    _fetchCurrentValues();
  }

  Future<void> _fetchCurrentValues() async {
    final response = await http.post(
      Uri.parse('http://localhost/flutter/fetch_values.php'),
      body: {'incubatorID': widget.incubatorID},
    );
    final data = json.decode(response.body);

    setState(() {
      _temperatureController.text = data['temperature'];
      _humidityController.text = data['humidity'];
      _lightLevelController.text = data['light_level'];
    });
  }

  Future<void> _saveChanges() async {
    await http.post(
      Uri.parse('http://localhost/flutter/updated_values.php'),
      body: {
        'incubatorID': widget.incubatorID,
        'temperature': _temperatureController.text,
        'humidity': _humidityController.text,
        'light_level': _lightLevelController.text,
      },
    );
    widget.updateValues(_temperatureController.text, _humidityController.text,
        _lightLevelController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Edit Incubator Values'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Edit Incubator Values',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              buildConfigTextField('Temperature', _temperatureController,
                  'Enter Temperature', false),
              const SizedBox(height: 20),
              buildConfigTextField(
                  'Humidity', _humidityController, 'Enter Humidity', false),
              const SizedBox(height: 20),
              buildConfigTextField('Light Level', _lightLevelController,
                  'Enter Light Level', false),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConfigTextField(String label, TextEditingController controller,
      String hintText, bool readOnly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
fetch_incubator_values.php - <?php
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
get_last_incubator_id.php - <?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept');

include 'db_connection.php';

$query = "SELECT incubatorID FROM incubator_status ORDER BY status_Id DESC LIMIT 1";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode(['status' => 'success', 'incubatorID' => $row['incubatorID']]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'No data found']);
}
?>
home.dart - import 'package:flutter/material.dart';
import 'configure.dart';
import 'current.dart';
import 'history.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final String incubatorID; // Add this line

  const HomeScreen({Key? key, required this.incubatorID}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String temperature = '25';
  String humidity = '60';
  String lightLevel = '300';
  String incubatorID = "";

  @override
  void initState() {
    super.initState();
    _fetchLastIncubatorID();
  }

  Future<void> _fetchLastIncubatorID() async {
    final response = await http.get(
      Uri.parse('http://localhost/flutter/get_last_incubator_id.php'),
    );
    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      setState(() {
        incubatorID = data['incubatorID'];
      });
    }
  }

  void updateValues(String temp, String hum, String light) {
    setState(() {
      temperature = temp;
      humidity = hum;
      lightLevel = light;
    });
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: const Text('Logout', style: TextStyle(color: Colors.black)),
          content: const Text('Are you sure you want to logout?',
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text('Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < buttonLabels.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (buttonLabels[i] == 'Configure') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfigureViewScreen(
                            incubatorID: widget.incubatorID,
                            updateValues: updateValues,
                          ),
                        ),
                      );
                    } else if (buttonLabels[i] == 'Current') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CurrentDataScreen(),
                        ),
                      );
                    } else if (buttonLabels[i] == 'History') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryScreen(),
                        ),
                      );
                    } else if (buttonLabels[i] == 'Logout') {
                      _showLogoutConfirmationDialog();
                    }
                  },
                  icon: Icon(
                    icons[i],
                    color: Colors.white,
                  ),
                  label: Text(
                    buttonLabels[i],
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

List<String> buttonLabels = ['Configure', 'Current', 'History', 'Logout'];
List<IconData> icons = [
  Icons.settings,
  Icons.bar_chart,
  Icons.history,
  Icons.logout,
];
login.dart - import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _incubatorIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    final response = await http.post(
      Uri.parse('http://localhost/flutter/login.php'),
      body: {
        'incubatorID': _incubatorIdController.text,
        'password': _passwordController.text,
      },
    );

    final responseData = json.decode(response.body);

    if (responseData['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  incubatorID: _incubatorIdController.text,
                )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width25Percent = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Incubator ID',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: width25Percent,
              child: TextField(
                controller: _incubatorIdController,
                decoration: const InputDecoration(
                  hintText: 'Enter Incubator ID',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: width25Percent,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Connect'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
login.php - <?php
header('Access-Control-Allow-Origin: *'); // Allow all origins
header('Access-Control-Allow-Methods: POST, GET, OPTIONS'); // Allow specific HTTP methods
header('Access-Control-Allow-Headers: Content-Type, Authorization'); // Allow specific headers

$servername = "localhost";
$username = "root"; // Default WAMP username
$password = ""; // Default WAMP password
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
start_incubator.php - <?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept');

include 'db_connection.php';

if (isset($_POST['incubatorID'])) {
    $incubatorID = $_POST['incubatorID'];

    $query = "UPDATE incubator_status SET is_running = 1 WHERE incubatorID = '$incubatorID'";
    if ($conn->query($query) === TRUE) {
        echo json_encode(['status' => 'success', 'message' => 'Incubator started successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to start incubator']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'No incubatorID provided']);
}
?>
stop_incubator.php - <?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept');

include 'db_connection.php';

if (isset($_POST['incubatorID'])) {
    $incubatorID = $_POST['incubatorID'];

    $query = "UPDATE incubator_status SET is_running = 0 WHERE incubatorID = '$incubatorID'";
    if ($conn->query($query) === TRUE) {
        echo json_encode(['status' => 'success', 'message' => 'Incubator stopped successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to stop incubator']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'No incubatorID provided']);
}
?>
.[database name: dgm_database , table name: incubator_status 
 , php file location: C:\wamp64\www\flutter and structure of table(phpmyadmin): 	#	Name	Type	Collation	Attributes	Null	Default	Comments	Extra	Action
	1	incubatorID Primary	int			No	None			Change Change	Drop Drop	
	2	temperature	float			Yes	NULL			Change Change	Drop Drop	
	3	start_time	datetime			Yes	NULL			Change Change	Drop Drop	
	4	end_time	datetime			Yes	NULL			Change Change	Drop Drop	
	5	humidity	float			Yes	NULL			Change Change	Drop Drop	
	6	light_level	int			No	None			Change Change	Drop Drop	
	7	is_running	tinyint(1)			Yes	0			Change Change	Drop Drop	
	8	status_Id Primary	timestamp			No	CURRENT_TIMESTAMP		DEFAULT_GENERATED	Change Change	Drop Drop	(incubatorId + status_Id is primary key)























import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditValuesScreen extends StatefulWidget {
  final String incubatorID;
  final Function(String, String, String) updateValues;

  const EditValuesScreen({
    Key? key,
    required this.incubatorID,
    required this.updateValues,
  }) : super(key: key);

  @override
  _EditValuesScreenState createState() => _EditValuesScreenState();
}

class _EditValuesScreenState extends State<EditValuesScreen> {
  late TextEditingController _temperatureController;
  late TextEditingController _humidityController;
  late TextEditingController _lightLevelController;

  @override
  void initState() {
    super.initState();
    _temperatureController = TextEditingController();
    _humidityController = TextEditingController();
    _lightLevelController = TextEditingController();
    _fetchCurrentValues();
  }

  Future<void> _fetchCurrentValues() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter/fetch_values.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'incubatorID': widget.incubatorID},
      );
      print('Fetch values response: ${response.body}');
      final data = json.decode(response.body);

      setState(() {
        _temperatureController.text = data['temperature'] ?? '';
        _humidityController.text = data['humidity'] ?? '';
        _lightLevelController.text = data['light_level'] ?? '';
      });
    } catch (error) {
      print('Error fetching values: $error');
    }
  }

  void _handleLogin() async {
    final response = await http.post(
      Uri.parse('http://localhost/flutter/fetch_incubator_values.php'),
      body: {
        'incubatorID': 1234,
      },
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      print(responseData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    }
  }

  void _saveChanges() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/flutter/create_new_record.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'incubatorID': widget.incubatorID,
          'temperature': _temperatureController.text,
          'humidity': _humidityController.text,
          'light_level': _lightLevelController.text,
        },
      );
      print('Save changes response: ${response.body}');
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        widget.updateValues(
          _temperatureController.text,
          _humidityController.text,
          _lightLevelController.text,
        );
        Navigator.pop(context);
      } else {
        // Handle the error appropriately
        print('Error: ${data['message']}');
      }
    } catch (error) {
      print('Error saving changes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Edit Incubator Values'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Edit Incubator Values',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              buildConfigTextField(
                'Temperature',
                _temperatureController,
                'Enter Temperature',
                false,
              ),
              const SizedBox(height: 20),
              buildConfigTextField(
                'Humidity',
                _humidityController,
                'Enter Humidity',
                false,
              ),
              const SizedBox(height: 20),
              buildConfigTextField(
                'Light Level',
                _lightLevelController,
                'Enter Light Level',
                false,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConfigTextField(
    String label,
    TextEditingController controller,
    String hintText,
    bool readOnly,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
