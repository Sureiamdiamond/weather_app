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
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Повторяем анимацию бесконечно
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2.0 * 3.14159, // 2π для полного оборота
          child: const FaIcon(
            FontAwesomeIcons.spinner, // Иконка загрузки
            size: 50,
            color: Colors.white,
          ),
        );
      },
    ));
  }
}
