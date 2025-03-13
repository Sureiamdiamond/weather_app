import 'package:flutter/material.dart';

class WeatherInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String description;
  final String iconPath;
  final Widget? progressBar; // New parameter for progress bars
  final TextStyle? unitStyle; // New parameter for unit styling

  const WeatherInfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.description,
    required this.iconPath,
    this.progressBar,
    this.unitStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 2.38; // Ensuring a square shape

    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Color.fromARGB(56, 1, 17, 28),
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 12),
            child: Row(
              children: [
                Image.asset(iconPath, height: 18, color: const Color(0xe5c7e9ff)),
                const SizedBox(width: 5),
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xe5c7e9ff))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 11, top: 10),
            child: Row(
              children: [
                Text(value, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Color(0xe5c7e9ff))),
                const SizedBox(width: 2),
                Text(unit, style: unitStyle ?? const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xe5c7e9ff))),
              ],
            ),
          ),
          if (progressBar != null) // Conditionally show progress bar
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(child: progressBar!),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 11, top: 9),
            child: SizedBox(
              width: size,
              child: Text(
                description,
                style: const TextStyle(fontSize: 12.5, color: Color(0xe5c7e9ff)),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
