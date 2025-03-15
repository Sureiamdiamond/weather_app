import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app/feature/presentation/widgets/forecast_widget.dart';
import 'package:test_app/gen/assets.gen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 1900),
      () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const ForecastWidget();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.splashWithText.path),
            fit: BoxFit.cover, // Fills the screen, cropping if necessary
          ),
        ),
      ),
    );
  }}