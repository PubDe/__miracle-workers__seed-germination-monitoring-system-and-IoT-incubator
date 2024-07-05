import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrentDataScreen extends StatefulWidget {
  const CurrentDataScreen({Key? key}) : super(key: key);

  @override
  _CurrentDataScreenState createState() => _CurrentDataScreenState();
}

class _CurrentDataScreenState extends State<CurrentDataScreen> {
  int totalSeedCount = 0;
  int germinatedSeedCount = 0;
  double germinatedPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost/flutter/current.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print('Fetched data: $data'); // Debugging statement

      setState(() {
        totalSeedCount = int.parse(data['Total_seed_count']);
        germinatedSeedCount = int.parse(data['Germinated_seed_count']);
        germinatedPercentage = (germinatedSeedCount / totalSeedCount) * 100;
      });

      print('Total seed count: $totalSeedCount'); // Debugging statement
      print(
          'Germinated seed count: $germinatedSeedCount'); // Debugging statement
      print(
          'Germinated percentage: $germinatedPercentage'); // Debugging statement
    } else {
      // Handle the error
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00FF00), Color(0xFFFFFF00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Current Data'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(229, 3, 44, 12),
                ),
              ),
              const SizedBox(height: 20),
              buildTextRow('Total seed count:', totalSeedCount.toString()),
              const SizedBox(height: 20),
              buildTextRow(
                  'Germinated seed count:', germinatedSeedCount.toString()),
              const SizedBox(height: 20),
              buildTextRow('Germinated percentage:',
                  '${germinatedPercentage.toStringAsFixed(2)}%'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchData,
                child: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 5, 92, 26), // Green color
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

  Widget buildTextRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 2, 71, 18),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 132, 204, 148),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
