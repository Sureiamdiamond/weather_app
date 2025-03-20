import 'package:flutter/material.dart';

Widget showErrorText(String message) {
  return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));
}