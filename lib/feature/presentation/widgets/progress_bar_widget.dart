import 'package:flutter/material.dart';

Widget ProgressBar({required double value}) {
  double progress = (value.clamp(0, 70)) / 70;

  Color getColor(double value) {
    if (value >= 0 && value < 4) {
      return Colors.purple;
    } else if (value >= 4 && value < 12) {
      return Colors.blue;
    } else if (value >= 12 && value < 20) {
      return Colors.green;
    } else if (value >= 20 && value < 28) {
      return Colors.yellow;
    } else if (value >= 28 && value < 35) {
      return Colors.orange;
    } else if (value >= 35 && value < 45) {
      return Colors.red;
    } else if (value >= 45 && value <= 70) {
      return Colors.deepPurple;
    } else {
      return Colors.white;
    }
  }

  return Container(
    width: 150,
    height: 6,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0x25021C2E), // Background color
    ),
    child: Stack(
      children: [
        FractionallySizedBox(
          widthFactor: progress, // Fill proportionally from 0 to 1
          child: Container(
            decoration: BoxDecoration(
              color: getColor(value),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    ),
  );
}