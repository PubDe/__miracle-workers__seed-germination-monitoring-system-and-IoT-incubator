import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_incubator.dart';
import 'remove_incubator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desktop Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost/desktop_APP/view.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _data = data.map<Map<String, String>>((item) {
          return {
            'incubator_ID': item['incubatorID'].toString(),
            'Password': item['password'].toString(),
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _addRow(String id, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost/desktop_APP/add.php'),
      body: {
        'incubatorID': id,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      _fetchData();
    } else {
      throw Exception('Failed to add data');
    }
  }

  Future<void> _removeRow(String id) async {
    final response = await http.post(
      Uri.parse('http://localhost/desktop_APP/remove.php'),
      body: {
        'incubatorID': id,
      },
    );

    if (response.statusCode == 200) {
      _fetchData();
    } else {
      throw Exception('Failed to remove data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incubator Monitoring System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddIncubatorScreen(),
                      ),
                    );
                    if (result != null &&
                        result['id'] != '' &&
                        result['password'] != '') {
                      _addRow(result['id'], result['password']);
                    }
                  },
                  child: Text('Add'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RemoveIncubatorScreen(),
                      ),
                    );
                    if (result != null && result != '') {
                      _removeRow(result);
                    }
                  },
                  child: Text('Remove'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Incubator ID')),
                    DataColumn(label: Text('Password')),
                  ],
                  rows: _data.map((row) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            color: Colors.green,
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(row['incubator_ID'] ?? ''),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            color: Colors.green,
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(row['Password'] ?? ''),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  dataRowHeight: 50,
                  headingRowHeight: 60,
                  horizontalMargin: 12,
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return Colors.blueGrey.shade200;
                    },
                  ),
                  border: TableBorder.all(
                    color: Colors.blue,
                    width: 2,
                    style: BorderStyle.solid,
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
