import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_bloc.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_event.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_state.dart';
import 'package:test_app/feature/presentation/widgets/loading_widget.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastWidget extends StatefulWidget {
  @override
  _ForecastWidgetState createState() => _ForecastWidgetState();
}

class _ForecastWidgetState extends State<ForecastWidget> {
  @override
  Widget build(BuildContext context) {
    String location = 'Moscow';
    int days = 7;

    BlocProvider.of<ForecastBloc>(context)
        .add(GeneralForecast(location: location, days: days));

    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastLoading) {
          return Container(color: Colors.lightBlue, child: LoadingIcon());
        } else if (state is ForecastLoaded) {
          final forecast = state.forecast;
          final Color? backColor = _getBackgroundColor(
              forecast.current?.condition?.text ?? "",
              forecast.current?.isday ?? 2);
          String dayName = _getWeekDay(forecast.location?.localtime ?? "");
          return Scaffold(
            appBar: AppBar(
              backgroundColor: backColor,
              leading: IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
                iconSize: 35,
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  iconSize: 35,
                )
              ],
            ),
            body: Container(
              color: backColor,
              padding: EdgeInsets.all(5.0),
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // Цвет рамки
                      width: 2.0, // Ширина рамки
                    ),
                    borderRadius:
                        BorderRadius.circular(16.0), // Закругленные углы
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(forecast.location?.name ?? "",
                                  style: AppTextStyles.heading),
                              Text(forecast.location?.country ?? "",
                                  style: AppTextStyles.subheading),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(dayName, style: AppTextStyles.heading),
                              Text(forecast.current?.condition?.text ?? "",
                                  style: AppTextStyles.subheading),
                            ],
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // Цвет рамки
                      width: 2.0, // Ширина рамки
                    ),
                    borderRadius:
                        BorderRadius.circular(16.0), // Закругленные углы
                  ),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 45.0),
                                  child: Image.network(
                                      "https:${forecast.current?.condition?.icon}",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 60.0),
                                  child: Text(
                                    '${forecast.current?.tempc?.toInt()}°',
                                    style: AppTextStyles.temperature,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      const BoxedIcon(
                                        WeatherIcons.cloud,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${forecast.current?.cloud.toString()}%' ??
                                            "",
                                        style: AppTextStyles.subheading,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const BoxedIcon(
                                        WeatherIcons.humidity,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${forecast.current?.humidity.toString()}%' ??
                                            "",
                                        style: AppTextStyles.subheading,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const BoxedIcon(
                                        WeatherIcons.strong_wind,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '${forecast.current?.windkph.toString()} kmh' ??
                                            "",
                                        style: AppTextStyles.subheading,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ]),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                    _getWeekDay(
                                            '${forecast.forecast?.forecastday?[0]?.date} ')
                                        .substring(0, 3),
                                    style: AppTextStyles.days),
                                Image.network(
                                    "https:${forecast.forecast?.forecastday?[0]?.day?.condition?.icon}"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    _getWeekDay(
                                            '${forecast.forecast?.forecastday?[1]?.date} ')
                                        .substring(0, 3),
                                    style: AppTextStyles.days),
                                Image.network(
                                    "https:${forecast.forecast?.forecastday?[1]?.day?.condition?.icon}"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    _getWeekDay(
                                            '${forecast.forecast?.forecastday?[2]?.date} ')
                                        .substring(0, 3),
                                    style: AppTextStyles.days),
                                Image.network(
                                    "https:${forecast.forecast?.forecastday?[2]?.day?.condition?.icon}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(children: [
                  const Divider(),
                  const Text(
                    "Additional Information",
                    style: AppTextStyles.heading,
                  ),
                  Text(
                    "Temperature feels like: ${forecast.current?.feelslikec}°C\nPressure: ${forecast.current?.pressuremb} mb\nGust: ${forecast.current?.gustkph} kmh",
                    style: AppTextStyles.subheading,
                  ),
                  const Divider(),
                  const Text("Astro part", style: AppTextStyles.heading),
                  Text(
                    "Sunrise: ${forecast.forecast?.forecastday?[0]?.astro?.sunrise ?? ""}",
                    style: AppTextStyles.subheading,
                  ),
                  Text(
                    "Sunset: ${forecast.forecast?.forecastday?[0]?.astro?.sunset ?? ""}",
                    style: AppTextStyles.subheading,
                  ),
                  Text(
                    "Moonrise: ${forecast.forecast?.forecastday?[0]?.astro?.moonrise ?? ""}",
                    style: AppTextStyles.subheading,
                  ),
                  Text(
                    "Moonset: ${forecast.forecast?.forecastday?[0]?.astro?.moonset ?? ""}",
                    style: AppTextStyles.subheading,
                  ),
                  Text(
                    'Moon phase: ${forecast.forecast?.forecastday?[0]?.astro?.moonphase ?? ""}',
                    style: AppTextStyles.subheading,
                  )
                ]),
              ]),
            ),
          );
        } else if (state is ForecastError) {
          return _showErrorText(state.message);
        } else {
          return const Center(
            child: AnimatedEmoji(
              AnimatedEmojis.bandageFace,
              size: 128,
            ),
          );
        }
      },
    );
  }
}

String _getWeekDay(String localtime) {
  int year = int.parse(localtime?.substring(0, 4) ?? '0');
  int month = int.parse(localtime?.substring(5, 7) ?? '0');
  int day = int.parse(localtime?.substring(8, 10) ?? '0');

  DateTime date = DateTime(year, month, day);

  int weekday = date.weekday;

  String dayName;
  switch (weekday) {
    case 1:
      dayName = 'Monday';
      break;
    case 2:
      dayName = 'Tuesday';
      break;
    case 3:
      dayName = 'Wednesday';
      break;
    case 4:
      dayName = 'Thursday';
      break;
    case 5:
      dayName = 'Friday';
      break;
    case 6:
      dayName = 'Saturday';
      break;
    case 7:
      dayName = 'Sunday';
      break;
    default:
      dayName = 'Unknown day';
  }
  return dayName;
}

Widget _showErrorText(String message) {
  return Center(
      child: Text(
    message,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ));
}

Color? _getBackgroundColor(String description, int isDay) {
  // Определяем цвет фона в зависимости от погоды и времени суток
  if (isDay == 1) {
    if (description.contains("sunny")) {
      return Colors.lightBlue;
    } else if (description.contains("cloudly") ||
        description.contains("overcast") ||
        description.contains("mist") ||
        description.contains("fog")) {
      return const Color.fromARGB(255, 150, 143, 143);
    } else if (description.contains("rain") ||
        description.contains("drizzle") ||
        description.contains("thundery")) {
      return const Color.fromARGB(255, 3, 88, 157);
    } else if (description.contains("snow") ||
        description.contains("sleet") ||
        description.contains("pellets")) {
      return const Color.fromARGB(255, 6, 138, 246);
    }
  } else {
    return const Color.fromARGB(255, 4, 56, 99); // Ночной фон
  }
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontFamily: 'Open Sans',
    color: Colors.white,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontFamily: 'Open Sans',
    color: Colors.white,
  );

  static const TextStyle temperature = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    fontFamily: 'Open Sans',
    color: Colors.white,
  );

  static const TextStyle days = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    fontFamily: 'Open Sans',
    color: Colors.white,
  );
}
