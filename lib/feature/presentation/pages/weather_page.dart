import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_app/feature/presentation/widgets/forecast_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.search), color: Colors.white)
        ],
      ),
      body: Forecast(),
    );
  }
}
