import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoadingIcon extends StatefulWidget {
  const LoadingIcon({super.key});

  @override
  _LoadingIconState createState() => _LoadingIconState();
}

class _LoadingIconState extends State<LoadingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2.0 * 3.14159,
                child:const CircularProgressIndicator( color: Colors.black,)
              );
                      },
                    ),
              const SizedBox(height: 12),
              const Text("Loading" , style: TextStyle(fontFamily: "SF" , fontWeight: FontWeight.bold),)
            ],
          )),
    );
  }
}
