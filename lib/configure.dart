import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'EditValuesScreen.dart';

class ConfigureViewScreen extends StatefulWidget {
  final String incubatorID;
  final bool initialIsRunning;
  final Function(bool) onRunningStateChanged;

  const ConfigureViewScreen({
    Key? key,
    required this.incubatorID,
    required this.initialIsRunning,
    required this.onRunningStateChanged,
  }) : super(key: key);

  @override
  _ConfigureViewScreenState createState() => _ConfigureViewScreenState();
}

class _ConfigureViewScreenState extends State<ConfigureViewScreen> {
  String temperature = '';
  String humidity = '';
  String lightLevel = '';
  late bool isRunning;

  @override
  void initState() {
    super.initState();
    isRunning = widget.initialIsRunning;
    _fetchCurrentValues();
  }

  Future<void> _fetchCurrentValues({bool refresh = false}) async {
    final response = await http.post(
      Uri.parse('http://localhost/flutter/fetch_values.php'),
      body: {'incubatorID': widget.incubatorID},
    );
    final data = json.decode(response.body);

    if (data['temperature'] != null) {
      setState(() {
        temperature = data['temperature'];
        humidity = data['humidity'];
        lightLevel = data['light_level'];
        if (!refresh) {
          isRunning = data['is_running'] == 1;
        }
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
        widget.onRunningStateChanged(isRunning);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Incubator'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00FF00), Color(0xFFFFFF00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
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
                    label: 'Temperature',
                    value: temperature,
                    icon: Icons.thermostat,
                  ),
                  const SizedBox(height: 20),
                  _buildConfigTextField(
                    label: 'Humidity',
                    value: humidity,
                    icon: Icons.water_drop,
                  ),
                  const SizedBox(height: 20),
                  _buildConfigTextField(
                    label: 'Light Level',
                    value: lightLevel,
                    icon: Icons.wb_sunny,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _toggleIncubator,
                    icon: Icon(isRunning ? Icons.stop : Icons.play_arrow,
                        color: Colors.white),
                    label: Text(isRunning ? 'Stop' : 'Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRunning
                          ? Colors.red
                          : const Color.fromARGB(255, 3, 174, 9),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!isRunning) ...[
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    FadeTransition(
                              opacity: animation,
                              child: EditValuesScreen(
                                incubatorID: widget.incubatorID,
                                updateValues: (newTemperature, newHumidity,
                                    newLightLevel) {
                                  setState(() {
                                    temperature = newTemperature;
                                    humidity = newHumidity;
                                    lightLevel = newLightLevel;
                                  });
                                  _fetchCurrentValues(refresh: true);
                                },
                              ),
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(
                                CurveTween(curve: curve),
                              );

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                        if (result == 'updated') {
                          _fetchCurrentValues(refresh: true);
                        }
                      },
                      child: const Text('Edit Values'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 32, 9, 209),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfigTextField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 30),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            readOnly: true,
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
            controller: TextEditingController(text: value),
          ),
        ),
      ],
    );
  }
}
