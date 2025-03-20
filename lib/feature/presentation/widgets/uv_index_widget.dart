
import 'package:flutter/material.dart';

Widget UVIndexBar({required double uvIndex}) {
  // Calculate position of the circle based on UV index, ensuring it's between 0 and 1
  double position = uvIndex * 11.8;

  // Colors for the gradient based on UV index
  List<Color> gradientColors = [
    Colors.green, // Low UV
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.blue, // High UV
  ];

  return Container(
    width: 150,
    height: 6,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          left: position, // Position the circle
          top: 0, // Slightly above the bar to center the circle
          child: Container(
            width: 6,
            height: 7,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
