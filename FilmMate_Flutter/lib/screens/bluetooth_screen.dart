import 'package:flutter/material.dart';

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
