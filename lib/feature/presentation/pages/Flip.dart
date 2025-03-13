
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';

import '../widgets/forecast_widget.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  final con = FlipCardController();
  final con1 = FlipCardController();
  final cong = GestureFlipCardController();
  final cong1 = GestureFlipCardController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 30,),

            FlipCard(
              animationDuration: const Duration(milliseconds: 230 ),
              rotateSide: RotateSide.top,
              disableSplashEffect: false,
              onTapFlipping: true,
              axis: FlipAxis.horizontal,
              controller: con,
              frontWidget: Row(
                children: [
                  Container(
                    height: 165,
                    width: 165,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(56, 1, 17, 28),
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 12),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/tempture.png",
                                height: 18,
                                color: const Color(0xe5c7e9ff),
                              ),
                              const SizedBox(width: 5), // Add spacing
                              const Text("FEELS LIKE", style: AppTextStyles.smallWidget),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 11),
                          child: Text(
                            '10°',
                            style: AppTextStyles.temperatureSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 11),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.42 , // Ensure text doesn't exceed width
                            child: Text(
                              "hi this is my message",
                              style: AppTextStyles.smallText,
                              overflow: TextOverflow.ellipsis, // Avoid overflow
                              maxLines: 2, // Set max lines
                              softWrap: true, // Enable text wrapping
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backWidget: Row(
                children: [
                  Container(
                    height: 165,

                    width: 165,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(56, 1, 17, 28),
                        borderRadius: BorderRadius.all(Radius.circular(22))
                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 12),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/small_wind.png",
                                height: 18,
                                color: const Color(0xe5c7e9ff),
                              ),
                              const SizedBox(width: 5), // Add spacing
                              const Text("GUST", style: AppTextStyles.smallWidget),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 11),
                              child: Text(
                                '32',
                                style: AppTextStyles.gust,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 2 , top: 15),
                              child: Text(
                                'Kp/h',
                                style: AppTextStyles.kph,
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: ProgressBar( value: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 11 , top: 6.5),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.42 , // Ensure text doesn't exceed width
                            child: const Text(
                              "The gust shows sudden, strong bursts of wind",
                              style: AppTextStyles.smallText,
                              overflow: TextOverflow.ellipsis, // Avoid overflow
                              maxLines: 2, // Set max lines
                              softWrap: true, // Enable text wrapping
                            ),
                          ),
                        ),

                      ],
                    ),),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }
}