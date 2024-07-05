import 'package:flutter/material.dart';
import 'configure.dart';
import 'current.dart';
import 'history.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  final String incubatorID;

  const HomeScreen({Key? key, required this.incubatorID}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRunning = false;

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: const Text('Logout', style: TextStyle(color: Colors.black)),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black),
          ),
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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

  void _navigateToScreen(BuildContext context, String label) async {
    Widget screen;
    switch (label) {
      case 'Configure':
        screen = ConfigureViewScreen(
          incubatorID: widget.incubatorID,
          initialIsRunning: isRunning,
          onRunningStateChanged: (newRunningState) {
            setState(() {
              isRunning = newRunningState;
            });
          },
        );
        break;
      case 'Current':
        screen = const CurrentDataScreen();
        break;
      case 'History':
        screen = const HistoryScreen();
        break;
      case 'Logout':
        _showLogoutConfirmationDialog(context);
        return;
      default:
        return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00FF00), Color(0xFFFFFF00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                    shadows: [
                      Shadow(
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                for (int i = 0; i < buttonLabels.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _navigateToScreen(context, buttonLabels[i]);
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
                        backgroundColor: Colors.green[900],
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        shadowColor: Colors.black45,
                        elevation: 5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
