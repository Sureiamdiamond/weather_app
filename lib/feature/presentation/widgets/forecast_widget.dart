import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastLoading) {
          return Container(
            color: Colors.lightBlue,
            child: FadeTransition(
              opacity: _loadingFadeAnimation,
              child: const LoadingIcon(),
            ),
          );
        } else if (state is ForecastLoaded) {

          _fadeController.forward();

          final forecast = state.forecast;
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
                    child: Column(children: [
                      const SizedBox(height: 50,),
                      Padding(
                        padding: const EdgeInsets.only(left : 15 , right: 15),
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
                                Text(forecast.location?.name ?? "" , style: AppTextStyles.cityName,)
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                final result = await Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) {
                                      return SearchPage();
                                    },
                                    transitionsBuilder:
                                        (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
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
                                  });
                                  await _saveLocation(result);
                                  _loadLocation();
                                }
                              },
                              icon: const Icon(CupertinoIcons.search),
                              color: Colors.white,
                              iconSize: 35,
                            )
                          ],),
                      ),
                      Column(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //icon condition
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: (forecast.current!.condition!.text!.toLowerCase().contains("cloud"))
                                ?
                           SizedBox(child: Image.asset('assets/images/day_clouds.png'))
                                :
                            (forecast.current!.condition!.text!.toLowerCase().contains("rain"))
                                ?
                            SizedBox(child: Image.asset('assets/images/day_rain.png'))
                                :
                            (forecast.current!.condition!.text!.toLowerCase().contains("sun"))
                                ?
                            SizedBox(child: Image.asset('assets/images/Sun.png'))
                                :
                            (forecast.current!.condition!.text!.toLowerCase().contains("wind"))
                                ?
                            SizedBox(child: Image.asset('assets/images/day_wind.png'))
                                :
                            (forecast.current!.condition!.text!.toLowerCase().contains("snow"))
                                ?
                            SizedBox(child: Image.asset('assets/images/day_snow.png'))
                                :
                            (forecast.current!.condition!.text!.toLowerCase().contains("thunder"))
                                ?
                            SizedBox(child: Image.asset('assets/images/day_storm_thunder.png.png'))
                                :
                            (forecast.current!.condition!.text!.toLowerCase().contains("storm"))
                                ?
                            SizedBox(child: Image.asset('assets/images/day_storm_thunder.png.png'))
                            :
                            Center(child: Column(
                              children: [
                                const SizedBox(height: 30,),
                                Text(forecast.current!.condition!.text??"" , style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'SF',
                                  color: Colors.white,
                                )),
                              ],
                            )),
                          ),
                          Text(forecast.location?.localtime?.split(" ")[1]?? "" , style: AppTextStyles.lightTexts,),
                          Text(
                            '${forecast.current?.tempc?.toInt() ?? '--'}°',
                            style: AppTextStyles.temperature,
                          ),
                           const Text("Precipitations" , style: AppTextStyles.lightTexts),
                            Text(
                              'Min: ${forecast.forecast?.forecastday?.first?.day?.mintempc?.toInt()}°   Max: ${forecast.forecast?.forecastday?.first?.day?.maxtempc?.toInt()  }° ',style: AppTextStyles.lightTexts),

                          const SizedBox(height: 40,),

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
                                        '${forecast.current?.humidity.toString()}%',
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
                          Padding(
                            padding: const EdgeInsets.only(left: 25 , right:25),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(56, 1, 17, 28),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: const Column(),
                            ),
                          ),
                          const SizedBox(height: 20,),
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

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius:
                              BorderRadius.circular(16.0),
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
                                padding: const EdgeInsets.only(right: 14.0),
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
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius:
                              BorderRadius.circular(16.0),
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
                                          padding:
                                              const EdgeInsets.only(left: 45.0),
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Image.network(
                                                "https:${forecast.current?.condition?.icon}",
                                                fit: BoxFit.contain,
                                                filterQuality: FilterQuality.high),
                                          )),
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
                                              '${forecast.current?.cloud.toString()}%',
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
                                              '${forecast.current?.humidity.toString()}%',
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
                                              '${forecast.current?.windkph.toString()} kmh',
                                              style: AppTextStyles.subheading,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
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
  static const TextStyle lightTexts = TextStyle(
      fontFamily: 'SF' , fontWeight: FontWeight.w500 , color: Colors.white ,fontSize: 15
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,

    fontFamily: 'SF',
    color: Colors.white,
  );

  static const TextStyle temperature = TextStyle(
    fontSize: 95,
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
