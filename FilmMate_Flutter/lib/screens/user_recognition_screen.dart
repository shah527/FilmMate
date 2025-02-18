import 'package:flutter/material.dart';

class UserRecognitionScreen extends StatefulWidget {
  const UserRecognitionScreen({super.key});

  @override
  State<UserRecognitionScreen> createState() => _UserRecognitionScreenState();
}

class _UserRecognitionScreenState extends State<UserRecognitionScreen> {
  String? selectedColorName;
  Color? selectedColorValue;
  bool isRecording = false;

  final List<Map<String, dynamic>> neonColors = [
    {'name': 'Yellow', 'color': const Color(0xFFCCFF00)},
    {'name': 'Green', 'color': const Color(0xFF39FF14)},
    {'name': 'Pink', 'color': const Color(0xFFFF10F0)},
    {'name': 'Orange', 'color': const Color(0xFFFF5E00)},
    {'name': 'Red', 'color': const Color(0xFFFF073A)},
    {'name': 'Purple', 'color': const Color(0xFF9D00FF)},
    {'name': 'Blue', 'color': const Color(0xFF0FF0FC)},
  ];

  void _toggleRecording() {
    if (selectedColorName == null) {
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
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Camera Preview Placeholder (Flexible Top)
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  'Camera View',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),
          ),

          // Bottom Bar with Buttons + Colors on the same section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            height: 140, // Make bottom section taller
            color: Colors.white,
            child: Column(
              children: [
                // Color Name Display (Above the color palette)
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    children: [
                      const TextSpan(
                        text: 'Neon ',
                        style: TextStyle(color: Colors.black),
                      ),
                      if (selectedColorName != null)
                        TextSpan(
                          text: selectedColorName!,
                          style: TextStyle(color: selectedColorValue),
                        )
                      else
                        const TextSpan(
                          text: 'Choose Tracking Color',
                          style: TextStyle(color: Colors.black),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Color Palette + Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('CANCEL',
                          style: TextStyle(color: Colors.white)),
                    ),

                    // Color Palette Centered
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: neonColors.map((neon) {
                              final isSelected = selectedColorName == neon['name'];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedColorName = neon['name'];
                                    selectedColorValue = neon['color'];
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  width: 40,
                                  height: 40,
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
                        ),
                      ),
                    ),

                    // FAB Button
                    FloatingActionButton(
                      onPressed: _toggleRecording,
                      backgroundColor: isRecording ? Colors.red : Colors.blue,
                      child: Icon(
                        isRecording ? Icons.stop : Icons.videocam,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
