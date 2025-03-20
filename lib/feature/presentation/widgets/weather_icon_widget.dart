import 'package:flutter/material.dart';

import '../style/text_styles.dart';

Widget getWeatherIcon(String condition, String dayOrNight, String? conditionText) {
  const Map<String, List<String>> weatherConditions = {
    'cloudy': ["cloud", "wind", "overcast", "fog", "mist"],
    'rainy': ["rain", "drizzle"],
    'snowy': ["snow", "sleet", "pellets"],
    'thunder': ["thunder", "storm"],
    'clear': ["clear", "sunny"],
    'misty': ["mist"],
  };

  const Map<String, Map<String, String>> weatherIcons = {
    'cloudy': {
      'day': 'assets/images/day_clouds.png',
      'night': 'assets/images/night_clouds.png',
    },
    'rainy': {
      'day': 'assets/images/day_rain.png',
      'night': 'assets/images/night_rain.png',
    },
    'snowy': {
      'day': 'assets/images/day_snow.png',
      'night': 'assets/images/night_snow.png',
    },
    'thunder': {
      'day': 'assets/images/day_storm_thunder.png',
      'night': 'assets/images/night_storm_thunder.png',
    },
    'clear': {
      'day': 'assets/images/Sun.png',
      'night': 'assets/images/Moon.png',
    },
    'misty': {
      'day': 'assets/images/day_wind.png',
      'night': 'assets/images/night_wind.png',
    },
  };

  String? weatherType;
  for (var entry in weatherConditions.entries) {
    if (entry.value.any((c) => condition.contains(c))) {
      weatherType = entry.key;
      break;
    }
  }

  if (weatherType != null) {
    return Image.asset(weatherIcons[weatherType]![dayOrNight]!);
  }

  // Default case
  return Column(
    children: [
      const SizedBox(height: 30),
      Text(
        conditionText ?? "",
        style: AppTextStyles.conditionText,
      ),
    ],
  );
}
