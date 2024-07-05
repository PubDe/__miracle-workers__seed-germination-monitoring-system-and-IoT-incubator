import 'package:flutter/material.dart';

class AddIncubatorScreen extends StatefulWidget {
  @override
  _AddIncubatorScreenState createState() => _AddIncubatorScreenState();
}

class _AddIncubatorScreenState extends State<AddIncubatorScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Incubator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Incubator',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'Incubator ID',
                filled: true,
                fillColor: Colors.grey.shade300,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.grey.shade300,
              ),
              obscureText: true,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'id': _idController.text,
                      'password': _passwordController.text
                    });
                  },
                  child: Text('Confirm'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
