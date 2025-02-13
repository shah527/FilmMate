import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // App-wide background
        useMaterial3: false, // Optional - Reverts to Material2 style
      ),
      home: const HomeScreen(),
    );
  }
}

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

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  String? selectedDevice;

  final List<String> bluetoothDevices = [
    'Tripod_123',
    'Tripod_456',
    'Tripod_789',
    'Tripod_XYZ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Bluetooth Connection')),
      body: Center(
        child: DropdownButton<String>(
          value: selectedDevice,
          hint: const Text('Select a Bluetooth Device'),
          items: bluetoothDevices.map((String device) {
            return DropdownMenuItem<String>(
              value: device,
              child: Text(device),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedDevice = value;
            });
          },
        ),
      ),
    );
  }
}

class UserRecognitionScreen extends StatefulWidget {
  const UserRecognitionScreen({super.key});

  @override
  State<UserRecognitionScreen> createState() => _UserRecognitionScreenState();
}

class _UserRecognitionScreenState extends State<UserRecognitionScreen> {
  String? selectedColor;
  bool isRecording = false;

  final List<String> neonColors = [
    'Neon Green',
    'Neon Pink',
    'Neon Blue',
    'Neon Yellow',
    'Neon Orange',
  ];

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Smart Tripod - User Recognition')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('[ CAMERA PREVIEW / ICON ]', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('"Choose Color"'),
            DropdownButton<String>(
              value: selectedColor,
              hint: const Text('Select Neon Color'),
              items: neonColors.map((String color) {
                return DropdownMenuItem<String>(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedColor = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleRecording,
        backgroundColor: isRecording ? Colors.red : Colors.blue,
        child: Icon(isRecording ? Icons.stop : Icons.videocam),
      ),
    );
  }
}
