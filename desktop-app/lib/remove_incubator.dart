import 'package:flutter/material.dart';

class RemoveIncubatorScreen extends StatefulWidget {
  @override
  _RemoveIncubatorScreenState createState() => _RemoveIncubatorScreenState();
}

class _RemoveIncubatorScreenState extends State<RemoveIncubatorScreen> {
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remove Incubator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Remove Incubator',
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
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _idController.text);
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
