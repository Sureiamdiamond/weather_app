import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';



class popupScreen extends StatefulWidget {
  const popupScreen({super.key});

  @override
  State<popupScreen> createState() => _popupScreenState();
}

class _popupScreenState extends State<popupScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          title: const Text('example'),
          actions: const [
            // example0 menu
            Padding(
              padding: EdgeInsets.only(right: 30),
              child: CustomPopup(

                contentPadding: EdgeInsets.all(10),
                showArrow: true,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [


                  ],
                ),
                child: Icon(Icons.add_circle_outline),
              ),
            ),
          ],
        ),

      ),
    );
  }
}

class _Slider extends StatefulWidget {
  const _Slider();

  @override
  State<_Slider> createState() => __SliderState();
}

class __SliderState extends State<_Slider> {
  double progress = 0.5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 100,
      child: Slider(
        value: progress,
        onChanged: (value) {
          setState(() => progress = value);
        },
      ),
    );
  }
}