import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_bloc.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_event.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_state.dart';
import 'package:test_app/feature/presentation/pages/search_page.dart';
import 'package:test_app/feature/presentation/widgets/loading_widget.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastWidget extends StatefulWidget {

  const ForecastWidget({super.key});

  @override
  _ForecastWidgetState createState() => _ForecastWidgetState();
}

class _ForecastWidgetState extends State<ForecastWidget>
    with SingleTickerProviderStateMixin {

  String location = 'Tehran';
  Logger logger = Logger();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _loadingFadeAnimation;

  void _fetchForecast() {
    BlocProvider.of<ForecastBloc>(context)
        .add(GeneralForecast(location: location, days: 7));
  }

  Future<void> _loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      location =
          prefs.getString('location') ?? 'Tehran';
    });
    _fetchForecast();
  }

  Future<void> _saveLocation(String newLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'location', newLocation);
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    _loadingFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );
    _loadLocation();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }


  String _getDayOrNight(String localtime) {
    int hour = int.parse(localtime.split(" ")[1].split(":")[0]);
    return (hour >= 2 && hour <= 18) ? "day" : "night";
  }


  String _getDate(String localtime) {
    String dateName = DateFormat('MMM d').format(DateFormat("yyyy-MM-DD").parse(localtime));
    return dateName;
  }






  @override
  Widget build(BuildContext context) {


    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {


        if (state is ForecastLoading) {


          return Container(
           color: Colors.white,
            child: FadeTransition(
              opacity: _loadingFadeAnimation,
              child: const LoadingIcon(),
            ),
          );
        } else if (state is ForecastLoaded) {



          final List<Map<String, String>> weatherData = [
            {'temp': '31°C', 'time': '15:00'},
            {'temp': '30°C', 'time': '16:00'},
            {'temp': '28°C', 'time': '17:00'},
            {'temp': '28°C', 'time': '18:00'},
          ];


          _fadeController.forward();

          final forecast = state.forecast;
          final String dayOrNight = _getDayOrNight(forecast.location?.localtime ?? "00:00");
          String condition = forecast.current!.condition!.text!.toLowerCase();
          final Gradient backColor = _getBackgroundGradient(
              forecast.current?.condition?.text?.toLowerCase() ?? "sunny",
              forecast.current?.isday ?? 2
          );

          String dayName = _getWeekDay(forecast.location?.localtime ?? "");
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: backColor,
              ),
              child: Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    gradient: backColor,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                        children: [
                          const SizedBox(height: 50,),
                          Padding(
                            padding: const EdgeInsets.only(left: 15 , right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.location_on_outlined),
                                      color: Colors.white,
                                      iconSize: 35,
                                      onPressed: () {},
                                    ),
                                    Text(forecast.location?.name ?? "", style: AppTextStyles.cityName,),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final result = await Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) {
                                          return SearchPage();
                                        },
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(0.0, 1.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;
                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                    if (result != null) {
                                      setState(() {
                                        location = result;
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return const Scaffold(
                                              body: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: CircularProgressIndicator(color: Colors.black,),
                                                  ),
                                                  SizedBox(height: 12,),
                                                  Text("Loading", style: TextStyle(fontFamily: "SF", fontWeight: FontWeight.bold),)
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      });
                                      await _saveLocation(result);
                                      _loadLocation();
                                      await Future.delayed(const Duration(milliseconds: 5500));
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  icon: const Icon(CupertinoIcons.search),
                                  color: Colors.white,
                                  iconSize: 35,
                                ),
                              ],
                            ),
                          ),


                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 25),

                          ///icon condition
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: () {
                              // Conditions grouped together
                              List<String> cloudyConditions = ["cloud", "wind", "overcast", "fog", "mist"];
                              List<String> rainyConditions = ["rain" , "drizzle"];
                              List<String> snowyConditions = ["snow" , "sleet" , "pellets"];
                              List<String> thunderConditions = ["thunder", "storm"];
                              List<String> clearConditions = ["clear" , "sunny"];
                              List<String> mistyConditions = ["mist"];

                              if (cloudyConditions.any((c) => condition.contains(c))) {
                                return dayOrNight == 'day'
                                    ? Image.asset('assets/images/day_clouds.png')
                                    : Image.asset('assets/images/night_clouds.png');
                              } else if (rainyConditions.any((c) => condition.contains(c))) {
                                return dayOrNight == 'day'
                                    ? Image.asset('assets/images/day_rain.png')
                                    : Image.asset('assets/images/night_rain.png');
                              } else if (snowyConditions.any((c) => condition.contains(c))) {
                                return dayOrNight == 'day'
                                    ? Image.asset('assets/images/day_snow.png')
                                    : Image.asset('assets/images/night_snow.png');
                              } else if (thunderConditions.any((c) => condition.contains(c))) {
                                return dayOrNight == 'day'
                                    ? Image.asset('assets/images/day_storm_thunder.png')
                                    : Image.asset('assets/images/night_storm_thunder.png');
                              } else if (clearConditions.any((c) => condition.contains(c))) {
                                return dayOrNight == 'day'
                                    ? Image.asset('assets/images/Sun.png')
                                    : Image.asset('assets/images/Moon.png');
                              } else if (mistyConditions.any((c) => condition.contains(c))) {
                                return dayOrNight == 'day'
                                    ? Image.asset('assets/images/day_wind.png')
                                    : Image.asset('assets/images/night_wind.png');
                              }

                              // Default case
                              return Column(
                                children: [
                                  const SizedBox(height: 30),
                                  Text(
                                    forecast.current!.condition!.text ?? "",
                                    style: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            }(),
                          ),

                          ///country and time
                          // Row(
                          //   children: [
                          //
                          //     Text(forecast.location?.country ?? "", style: AppTextStyles.timeSmall,),
                          //     const SizedBox(width: 5,),
                          //     Text(forecast.location?.localtime?.split(" ")[1] ?? "", style: AppTextStyles.timeSmall,),
                          //   ],
                          // ),

                          //date and condition

                          /// Days of Week and Conditions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(dayName,style: AppTextStyles.lightTexts),
                              const Padding(
                                padding: EdgeInsets.only(left: 5 , right: 5),
                                child: Text('|',  style: AppTextStyles.lightTexts),
                              ),
                              Text(forecast.current?.condition?.text ?? "",
                                  style: AppTextStyles.lightTexts),
                            ],
                          ),

                          ///Temperature
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text(
                              '${forecast.current?.tempc?.toInt()?? '--'}°',
                              style: AppTextStyles.temperature,
                            ),
                          ),

                           ///Ttile and Max Min
                           const Text(
                               "Precipitations" , style: AppTextStyles.lightTexts),
                            Text(
                              'Min: ${forecast.forecast?.forecastday?.first?.day?.mintempc?.toInt()}°   Max: ${forecast.forecast?.forecastday?.first?.day?.maxtempc?.toInt()  }° ',style: AppTextStyles.lightTexts),

                          const SizedBox(height: 40,),
                          /// small (first) circular radius container
                          Padding(
                            padding: const EdgeInsets.only(left: 25 , right:25),
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(56, 1, 17, 28),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(children: [
                                    SvgPicture.asset('assets/images/Union.svg' , height: 16,color: Colors.white,),
                                    const SizedBox(width: 5,),
                                    Text(
                                      '${forecast.current?.cloud.toString()}%',
                                      style: AppTextStyles.subheading,
                                    ),


                                  ],),
                                  Row(
                                    children: [

                                      SvgPicture.asset('assets/images/humidity_bar.svg') ,
                                      Text(
                                        '${forecast.current?.humidity.toString()}%'??"",
                                        style: AppTextStyles.subheading,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/images/wind_bar.svg'),
                                      const SizedBox(width: 2,),
                                      Text(
                                        '${forecast.current?.windkph.toString()}',
                                        style: AppTextStyles.subheading,
                                      ),
                                      const SizedBox(width: 4,),
                                      const Text(
                                        'km/h',
                                        style: AppTextStyles.format,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20,),
                          /// big (second) circular radius container
                          Padding(
                            padding: const EdgeInsets.only(left: 25 , right:25),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(56, 1, 17, 28),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child:  Column(
                                children: [
                                  /// Date
                                  Padding(
                                    padding: const EdgeInsets.only(top : 13.0 , left: 15 , right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Today" , style: AppTextStyles.today),
                                        Text(_getDate(forecast.location?.localtime?.split(" ")[0]?? "00:00") , style: AppTextStyles.date,),


                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  SizedBox(
                                    height: 140,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: weatherData.length,
                                      itemBuilder: (context, index) {

                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: 75,
                                          margin: const EdgeInsets.symmetric(horizontal: 8),
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(18, 3, 15, 25),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                weatherData[index]['temp']!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              const Icon(
                                                Icons.cloud,
                                                color: Colors.white70,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                weatherData[index]['time']!,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20,),
                          /// medium (third) circular radius container
                          Padding(
                            padding: const EdgeInsets.only(left: 25 , right:25),
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(56, 1, 17, 28),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: const Column(),
                            ),
                          )


                        ],
                      ),
                      const SizedBox(height: 150,),




                      ///
                      /// ///
                      ///
                          /// ///
                          /// ///
                          /// /
                          /// //
                          ///
                          ///
                          ///
                          ///


                      Container(
                        padding: const EdgeInsets.only(top: 5),

                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
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
                        ),
                        const SizedBox(height: 50,),

                      ]),
                    ]),
                  ),
                ),
              ),
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
  int year = int.parse(localtime.substring(0, 4));
  int month = int.parse(localtime.substring(5, 7));
  int day = int.parse(localtime.substring(8, 10));

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

Gradient _getBackgroundGradient(String description, int isDay) {
  if (isDay == 1) {
    if (description.contains("sunny")) {
      return const LinearGradient(
        colors: [ Color(0xff2bd6ed),Color(0xff33AADD),Color(0xff00a6ff)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        // stops: [0,47,100]
      );
    } else if (description.contains("cloudly") ||
        description.contains("overcast") ||
        description.contains("mist") ||
        description.contains("cloud") ||
        description.contains("fog")) {
      return  const LinearGradient(
        colors: [Color.fromARGB(255, 214, 214, 214), Color.fromARGB(255, 90, 87, 87) ,Color.fromARGB(
            255, 19, 19, 19) ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      );
    } else if (description.contains("rain") ||
        description.contains("drizzle") ||
        description.contains("thundery")) {
      return const LinearGradient(
        colors: [ Color(0xff061f45),Color(0xff1453c6),Color(0xff0a4ecf)],
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
      colors: [Color.fromARGB(255, 1, 37, 66),Color.fromARGB(255, 4, 83, 149)],
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


class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontFamily: 'Open Sans',
    color: Colors.white,
  );

  static const TextStyle cityName = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w700,
    fontFamily: 'SF',
    color: Colors.white,
  );

  static const TextStyle format = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    fontFamily: 'SF',
    color: Colors.white,
  );

  static const TextStyle date = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w400,
    fontFamily: 'SF',
    color: Colors.white,
  );

  static const TextStyle today = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontFamily: 'SF',
    color: Colors.white,
  );


  static const TextStyle lightTexts = TextStyle(
      fontFamily: 'SF' , fontWeight: FontWeight.w500 , color: Colors.white ,fontSize: 15
  );

  static const TextStyle timeSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    fontFamily: 'SF',
    color: Colors.white,
  );
  static const TextStyle subheading = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,

    fontFamily: 'SF',
    color: Colors.white,
  );

  static const TextStyle temperature = TextStyle(
    fontSize: 100,
    fontFamily: 'SF',
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
