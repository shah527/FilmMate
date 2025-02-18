import 'package:flutter/material.dart';
import 'bluetooth_screen.dart';
import 'user_recognition_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isConnected = false;
  String pairedDevice = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Smart Tripod - Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isConnected
                  ? 'Bluetooth Status: CONNECTED\nDevice Paired: $pairedDevice'
                  : 'Bluetooth Status: DISCONNECTED\nPlease enable Bluetooth to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BluetoothScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isConnected ? Colors.green : Colors.red,
                  width: 2,
                ),
              ),
              child: const Text('Enable Bluetooth'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserRecognitionScreen(),
                  ),
                );
              },
              child: const Text('Choose Color'),
            ),
          ],
        ),
      ),
    );
  }
}
