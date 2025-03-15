import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';

class WeatherInfoCard extends StatefulWidget {
  final String title;
  final String value;
  final String unit;
  final String description;
  final String iconPath;
  final String backText;
  final Widget? progressBar; // New parameter for progress bars
  final TextStyle? unitStyle; // New parameter for unit styling
  final TextStyle? valuetStyle; // New parameter for unit styling

  const WeatherInfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.description,
    required this.iconPath,
    required this.backText,
    this.progressBar,
    this.unitStyle,
    this.valuetStyle,

  }) : super(key: key);

  @override
  State<WeatherInfoCard> createState() => _WeatherInfoCardState();
}

class _WeatherInfoCardState extends State<WeatherInfoCard> {
  final con = FlipCardController();
  final con1 = FlipCardController();
  final cong = GestureFlipCardController();
  final cong1 = GestureFlipCardController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 2.35; // Ensuring a square shape

    return Bounceable(
      onTap: () {
        print("tap");
      },
      onLongPress: () {},
      child: FlipCard(
        animationDuration: const Duration(milliseconds: 200),
        rotateSide: RotateSide.top,
        disableSplashEffect: false,
        onTapFlipping: true,
        axis: FlipAxis.horizontal,
        controller: con,
        frontWidget: Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(
            color: Color.fromARGB(56, 1, 17, 28),
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 12),
                  child: Row(
                    children: [
                      Image.asset(widget.iconPath, height: 18, color: const Color(0xe5c7e9ff)),
                      const SizedBox(width: 5),
                      Text(widget.title,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xe5c7e9ff))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 11, top: 7, right: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.value,
                          style: widget.valuetStyle??const TextStyle(fontSize: 46, fontWeight: FontWeight.w500, color: Color(0xe5c7e9ff) ,  fontFamily: 'SF',),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(widget.unit,
                          style: widget.unitStyle ??
                              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xe5c7e9ff) ,  fontFamily: 'SF',)),
                    ],
                  ),
                ),
                if (widget.progressBar != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(child: widget.progressBar!),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 13, top: 9),
                  child: SizedBox(
                    width: size,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        widget.description,
                        style: const TextStyle(fontSize: 13.5, color: Color(0xe5c7e9ff)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backWidget: Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(
            color: Color.fromARGB(56, 1, 17, 28),
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 12),
                  child: Row(
                    children: [
                      Image.asset(widget.iconPath, height: 18, color: const Color(0xe5c7e9ff)),
                      const SizedBox(width: 5),
                      Text(widget.title,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xe5c7e9ff))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9, top: 12, right: 5),
                  child: SizedBox(
                    width: 170,
                    child: Text(
                      widget.backText,
                      style: const TextStyle(fontSize: 14, color: Color(0xe5c7e9ff)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 6,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}