import 'package:flutter/material.dart';

Gradient getBackgroundGradient(String description, int isDay) {
  if (isDay == 1) {
    if (description.contains("sunny")) {
      return const LinearGradient(
        colors: [Color(0xff2bd6ed), Color(0xff33AADD), Color(0xff00a6ff)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        // stops: [0,47,100]
      );
    } else if (description.contains("cloudly") ||
        description.contains("overcast") ||
        description.contains("mist") ||
        description.contains("cloud") ||
        description.contains("fog")) {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 86, 89, 90),
          Color.fromARGB(255, 90, 87, 87),
          Color.fromARGB(255, 106, 151, 186),
          Color.fromARGB(255, 68, 139, 202)
        ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      );
    } else if (description.contains("rain") ||
        description.contains("drizzle") ||
        description.contains("thundery")) {
      return const LinearGradient(
        colors: [Color(0xff061f45), Color(0xff1453c6), Color(0xff0a4ecf)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (description.contains("snow") ||
        description.contains("sleet") ||
        description.contains("pellets")) {
      return const LinearGradient(
        colors: [Color.fromARGB(255, 6, 138, 246), Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  } else {
    return const LinearGradient(
      colors: [Color.fromARGB(255, 1, 37, 66), Color.fromARGB(255, 4, 83, 149)],
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    );
  }

  return const LinearGradient(
    colors: [Colors.blueGrey, Colors.black],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );
}
