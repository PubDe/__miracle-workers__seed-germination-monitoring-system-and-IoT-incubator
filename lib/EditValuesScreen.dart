import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  late String _selectedLightLevel;
  final _formKey = GlobalKey<FormState>();
  String? _temperatureError;
  String? _humidityError;

  @override
  void initState() {
    super.initState();
    _temperatureController = TextEditingController();
    _humidityController = TextEditingController();
    _selectedLightLevel = '0'; // Default to the first light level
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    _humidityController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost/flutter/updated_incubator_values.php'),
      body: {
        'incubatorID': widget.incubatorID,
        'temperature': _temperatureController.text,
        'humidity': _humidityController.text,
        'light_level': _selectedLightLevel,
      },
    );
    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      widget.updateValues(
        _temperatureController.text,
        _humidityController.text,
        _selectedLightLevel,
      );
      Navigator.pop(context, 'updated'); // Pass 'updated' as result
    } else {
      // Handle the error appropriately in your app
      print(data['message']);
    }
  }

  String? _validateTemperature(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter temperature';
    }
    try {
      final temperature = int.parse(value);
      if (temperature < 10 || temperature > 60) {
        return 'Temperature must be between 10 and 60';
      }
    } catch (e) {
      return 'Invalid temperature value';
    }
    return null;
  }

  String? _validateHumidity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter humidity';
    }
    try {
      final humidity = int.parse(value);
      if (humidity < 1 || humidity > 100) {
        return 'Humidity must be between 1 and 100';
      }
    } catch (e) {
      return 'Invalid humidity value';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Edit Incubator Values'),
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
          child: FadeTransition(
            opacity:
                ModalRoute.of(context)?.animation ?? AlwaysStoppedAnimation(1),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Edit Incubator Values',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildConfigTextField(
                      'Temperature',
                      _temperatureController,
                      'Enter Temperature',
                      _validateTemperature,
                      _temperatureError,
                    ),
                    const SizedBox(height: 20),
                    _buildConfigTextField(
                      'Humidity',
                      _humidityController,
                      'Enter Humidity',
                      _validateHumidity,
                      _humidityError,
                    ),
                    const SizedBox(height: 20),
                    _buildLightLevelDropdown(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 19, 184, 24),
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
          ),
        ),
      ),
    );
  }

  Widget _buildConfigTextField(
    String label,
    TextEditingController controller,
    String hintText,
    String? Function(String?)? validator,
    String? errorText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildLightLevelDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Light Level',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedLightLevel,
          onChanged: (newValue) {
            setState(() {
              _selectedLightLevel = newValue!;
            });
          },
          items: ['0', '25', '50', '75', '100'].map((level) {
            return DropdownMenuItem<String>(
              value: level,
              child: Text(level),
            );
          }).toList(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
