import 'package:flutter/material.dart';

class UserRecognitionScreen extends StatefulWidget {
  const UserRecognitionScreen({super.key});

  @override
  State<UserRecognitionScreen> createState() => _UserRecognitionScreenState();
}

class _UserRecognitionScreenState extends State<UserRecognitionScreen> {
  String? selectedColor;
  bool isRecording = false;

  final List<Map<String, dynamic>> neonColors = [
    {'name': 'Neon Yellow', 'color': const Color(0xFFCCFF00)},
    {'name': 'Neon Green', 'color': const Color(0xFF39FF14)},
    {'name': 'Neon Pink', 'color': const Color(0xFFFF10F0)},
    {'name': 'Neon Orange', 'color': const Color(0xFFFF5E00)},
    {'name': 'Neon Red', 'color': const Color(0xFFFF073A)},
    {'name': 'Neon Purple', 'color': const Color(0xFF9D00FF)},
    {'name': 'Neon Blue', 'color': const Color(0xFF0FF0FC)},
  ];

  void _toggleRecording() {
    if (selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a color before recording.')),
      );
      return;
    }
    setState(() {
      isRecording = !isRecording;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isRecording ? 'Recording Started' : 'Recording Stopped'),
        backgroundColor: isRecording ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Smart Tripod - User Recognition'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              '[ CAMERA PREVIEW ]',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Choose Tracking Color',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: neonColors.map((neon) {
              final isSelected = selectedColor == neon['name'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = neon['name'];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: neon['color'],
                    boxShadow: [
                      BoxShadow(
                        color: neon['color'].withOpacity(0.8),
                        blurRadius: 10,
                        spreadRadius: isSelected ? 6 : 2,
                      ),
                    ],
                    border: isSelected
                        ? Border.all(color: Colors.black, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
            ),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleRecording,
        backgroundColor: isRecording ? Colors.red : Colors.blue,
        child: Icon(
          isRecording ? Icons.stop : Icons.videocam,
          color: Colors.white,
        ),
      ),
    );
  }
}
