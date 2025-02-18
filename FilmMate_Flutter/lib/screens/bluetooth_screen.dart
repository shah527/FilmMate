import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  String? selectedDeviceId;
  List<BluetoothDevice> devicesList = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  void scanForDevices() async {
    setState(() {
      devicesList.clear();
      isScanning = true;
    });

    // Start scanning for 12 seconds (adjust as needed)
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 12));

    // Listen to scan results
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        devicesList = results.map((r) => r.device).toList();
      });
    });

    // Stop scan after 12 seconds
    await Future.delayed(const Duration(seconds: 12));
    FlutterBluePlus.stopScan();

    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Connection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isScanning) const CircularProgressIndicator(),
            if (!isScanning && devicesList.isEmpty)
              const Text("No devices found. Try scanning again."),
            if (!isScanning && devicesList.isNotEmpty)
              DropdownButton<String>(
                value: selectedDeviceId,
                hint: const Text('Select a Bluetooth Device'),
                items: devicesList.map((device) {
                  return DropdownMenuItem<String>(
                    value: device.remoteId.str,
                    child: Text(device.platformName.isNotEmpty
                        ? device.platformName
                        : 'Unknown Device (${device.remoteId.str})'),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedDeviceId = value;
                  });
                  final selectedDevice = devicesList.firstWhere(
                    (device) => device.remoteId.str == value,
                  );

                  // Optionally connect after selecting
                  _connectToDevice(selectedDevice);
                },
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: scanForDevices,
              child: const Text('Rescan for Devices'),
            ),
          ],
        ),
      ),
    );
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected to ${device.platformName}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect: $e'),
        ),
      );
    }
  }
}
