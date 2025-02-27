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

  String feelsLikeTexts(double tempC, double feelsLikeC) {
    if (feelsLikeC < tempC) {
      return "little colder than current temp";
    } else if (feelsLikeC > tempC) {
      return "little warmer than current temp";
    } else {
      return "Similar to the actual temperature.";
    }
  }


  int showHour (String localtime) {
    int hour = int.parse(localtime.split(" ")[1].split(":")[0]);
    return hour;
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

          _fadeController.forward();
          final forecast = state.forecast;
          showHour(forecast.location?.localtime??"00:00");
          final String dayOrNight = _getDayOrNight(forecast.location?.localtime ?? "00:00");
          String condition = forecast.current!.condition!.text!.toLowerCase();
          final Gradient backColor = _getBackgroundGradient(
              forecast.current?.condition?.text?.toLowerCase() ?? "sunny",
              forecast.current?.isday ?? 2);
          String dayName = _getWeekDay(forecast.location?.localtime ?? "");
          final tempC = forecast.forecast?.forecastday?.first?.hour?.first?.tempc ?? 0.0;
          final feelsLikeC = forecast.forecast?.forecastday?.first?.hour?.first?.feelslikec ?? 0.0;

          final temperatureMessage = feelsLikeTexts(tempC, feelsLikeC);
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
                                    height: 138,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: forecast.forecast?.forecastday?.first?.hour?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        final hourData = forecast.forecast?.forecastday?.first?.hour?[index];
                                        final time = hourData?.time?.split(" ").last ?? "No Data";
                                        final temp = hourData?.tempc?.toInt() ?? "N/A"; // Temperature in Celsius
                                        final iconUrl = "https:${hourData?.condition?.icon ?? ""}"; // Weather icon URL

                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: 75,
                                          margin: const EdgeInsets.symmetric(horizontal: 8),
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(18, 3, 15, 25),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // Display temperature
                                              Text(
                                                "$temp°C",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // Display weather icon
                                              Image.network(
                                                iconUrl,
                                                width: 45,
                                                height: 45,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.cloud,
                                                    color: Colors.white70,
                                                    size: 30,
                                                  ); // Fallback icon
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                              // Display time
                                              Text(
                                                time,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'SP'
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20,),
                          /// medium (third) circular radius container
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(56, 1, 17, 28),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    Padding(
                                      padding: EdgeInsets.only(top : 13.0 , left: 15 , right: 15),
                                      child: Text("Next Forecast" ,  style: AppTextStyles.today),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top : 13.0 , left: 13 , right: 13),
                                      child: Icon(Icons.calendar_month_outlined , color: Colors.white,size: 26,),
                                    )
                                  ],),
                                  SizedBox(
                                    height: 125,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: forecast.forecast?.forecastday?.length ?? 0, // 3 days of forecast
                                      itemBuilder: (context, index) {
                                        final dayData = forecast.forecast?.forecastday?[index];
                                        final date = dayData?.date != null ? _getDate(dayData!.date!) : "No Date";

                                        final minTemp = dayData?.day?.mintempc?.toInt() ?? "N/A";
                                        final maxTemp = dayData?.day?.maxtempc?.toInt() ?? "N/A";
                                        final iconUrl = "https:${dayData?.day?.condition?.icon ?? ""}"; // Weather icon URL

                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: 200,
                                          margin: const EdgeInsets.symmetric(horizontal: 8),
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),

                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Display Date (Day) on the left
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    date,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Display Weather Icon in the center
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [

                                                  Image.network(
                                                    iconUrl,
                                                    width: 44,
                                                    height: 44,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return const Icon(
                                                        Icons.cloud,
                                                        color: Colors.white70,
                                                        size: 30,
                                                      ); // Fallback icon
                                                    },
                                                  ),
                                                ],
                                              ),
                                              // Display Max and Min Temp on the right
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text( "$maxTemp°C",

                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),),

                                                  Text(
                                                    "$minTemp°C",
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                    
                    ///first two small widget
                    Padding(
                      padding: const EdgeInsets.only(left: 25 , right:25),
                      child: Row(
                        children: [
                          ///feels like
                          Container(
                            height: 165,
                            width: MediaQuery.of(context).size.width / 2.42,
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
                                    '${forecast.current?.feelslikec?.toInt()}°',
                                    style: AppTextStyles.temperatureSmall,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 11),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.42 , // Ensure text doesn't exceed width
                                    child: Text(
                                      temperatureMessage,
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


                          const SizedBox(width: 15),

                          ///gust
                          Container(
                          height: 165,
                          width: MediaQuery.of(context).size.width/2.35,
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
                                      '${forecast.current?.gustkph}',
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
                                child: ProgressBar(value: forecast.current?.gustkph?.toDouble() ?? 0.0),
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
                          const SizedBox(height: 13,),

                    ///sunset & moonset
                    Padding(
                      padding: const EdgeInsets.only(left: 25 , right:25),
                      child: Container(
                          height: 180,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(56, 1, 17, 28),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(22)),
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/images/sunrise.png",
                                fit: BoxFit.cover, // Adjust the fit as needed
                                height: double.infinity,
                                width: double.infinity,
                              ),
                               const Positioned(
                                bottom: 45, // You can adjust the position of the text
                                left: 20,
                                child:
                                    Text(
                                      "Sunrise",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                              ),
                              Positioned(
                                bottom: 37, // You can adjust the position of the text
                                left: 20,
                                child:
                                Text(
                                  forecast.forecast?.forecastday?[0]?.astro?.sunrise ?? "",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),)

                              ),
                              const Positioned(
                                bottom: 13, // You can adjust the position of the text
                                left: 20,
                                child:
                                Text(
                                  "Sunset",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ),
                              Positioned(
                                  bottom: 6, // You can adjust the position of the text
                                  left: 20,
                                  child:
                                  Text(
                                    forecast.forecast?.forecastday?[0]?.astro?.sunset ?? "",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),)

                              ),


                              const Positioned(
                                bottom: 45, // You can adjust the position of the text
                                right: 20,
                                child:
                                Text(
                                  "Moonrise",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ),
                              Positioned(
                                  bottom: 37, // You can adjust the position of the text
                                  right: 50,
                                  child:
                                  Text(
                                    forecast.forecast?.forecastday?[0]?.astro?.moonrise ?? "",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),)

                              ),
                              const Positioned(
                                bottom: 13, // You can adjust the position of the text
                                right: 26,
                                child:
                                Text(
                                  "Moonset",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ),
                              Positioned(
                                  bottom: 6, // You can adjust the position of the text
                                  right: 50,
                                  child:
                                  Text(
                                    forecast.forecast?.forecastday?[0]?.astro?.moonset ?? "",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),)

                              ),


                            ],
                          )),
                      ),
                    ),
                          const SizedBox(height: 13,),


                   ///second two small widget
                          Padding(
                      padding: const EdgeInsets.only(left: 25 , right:25),
                      child: Row(
                        children: [

                          ///UV
                          Container(
                            height: 165,
                            width: MediaQuery.of(context).size.width/2.35,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(56, 1, 17, 28),
                                borderRadius: BorderRadius.all(Radius.circular(22))
                            ),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/uv_small.png",
                                        height: 20,

                                        color: const Color(0xe5c7e9ff),
                                      ),
                                      const SizedBox(width: 5), // Add spacing
                                      const Padding(
                                        padding: EdgeInsets.only(top:3.0),
                                        child: Text("UV INDEX", style: AppTextStyles.smallWidget),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 11),
                                      child: Text(
                                        forecast.forecast?.forecastday?.first?.day?.uv?.toString() ?? "No Data",
                                        style: AppTextStyles.gust,
                                      ),
                                    ),

                                  ],
                                ),
                                Center(
                                  child:UVIndexBar(uvIndex:forecast.forecast?.forecastday?.first?.day?.uv?.toDouble() ??0),
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

                          const SizedBox(width: 15),

                          /// pressure
                          Container(
                            height: 165,
                            width: MediaQuery.of(context).size.width / 2.42,
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
                                        "assets/images/pressure.png",
                                        height: 18,
                                        color: const Color(0xe5c7e9ff),
                                      ),
                                      const SizedBox(width: 5), // Add spacing
                                      const Text("PRESSURE", style: AppTextStyles.smallWidget),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 11 , top: 10),
                                  child: Row(
                                    children: [
                                      Text(forecast.current?.pressuremb?.toString()??"" , style: AppTextStyles.pressure,),
                                      const SizedBox(width: 2,),
                                      const Padding(
                                        padding: EdgeInsets.only(top:9.5),
                                        child: Text(
                                          'mb',
                                          style: AppTextStyles.mb,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 11 , top: 9),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.42 , // Ensure text doesn't exceed width
                                    child: const Text(
                                      "indicating how heavy or light it is in location",
                                      style: AppTextStyles.smallText,
                                      overflow: TextOverflow.ellipsis, // Avoid overflow
                                      maxLines: 4, // Set max lines
                                      softWrap: true, // Enable text wrapping
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                      const SizedBox(height: 100,),



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
        colors: [Color.fromARGB(255, 86, 89, 90), Color.fromARGB(255, 90, 87, 87) ,Color.fromARGB(
            255, 106, 151, 186),Color.fromARGB(255, 68, 139, 202)  ],
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
  static const TextStyle smallWidget = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontFamily: 'SF',
    color: Color(0xe5c7e9ff),
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

  static const TextStyle temperatureSmall = TextStyle(
    fontSize: 60,
    fontFamily: 'SF',
    color:Color(0xe5c7e9ff)
  );
  static const TextStyle gust = TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.w500,
      fontFamily: 'SF',
      color:Color(0xe5c7e9ff)
  );

  static const TextStyle smallText = TextStyle(
      fontSize: 13,
      fontFamily: 'SF',
      color:Color(0xe5c7e9ff),

  );
  static const TextStyle mb = TextStyle(
      fontSize: 13,
      fontFamily: 'SF',
      color:Color(0xe5c7e9ff),
    fontWeight: FontWeight.w600,

  );


  static const TextStyle pressure = TextStyle(
      fontSize: 40,
      fontFamily: 'SF',
      fontWeight: FontWeight.w500,
      color:Color(0xe5c7e9ff)
  );
  static const TextStyle kph = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      fontFamily: 'SF',
      color:Color(0xe5c7e9ff)
  );

  static const TextStyle days = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    fontFamily: 'Open Sans',
    color: Colors.white,
  );
}



Widget ProgressBar({required double value}) {
  double progress = (value.clamp(0, 70)) / 70;

  Color getColor(double value) {
    if (value >= 0 && value < 4) {
      return Colors.purple;
    } else if (value >= 4 && value < 12) {
      return Colors.blue;
    } else if (value >= 12 && value < 20) {
      return Colors.green;
    } else if (value >= 20 && value < 28) {
      return Colors.yellow;
    } else if (value >= 28 && value < 35) {
      return Colors.orange;
    } else if (value >= 35 && value < 45) {
      return Colors.red;
    } else if (value >= 45 && value <= 70) {
      return Colors.deepPurple;
    } else {
      return Colors.white;
    }
  }

  return Container(
    width: 150,
    height: 6,
    decoration: BoxDecoration(

      borderRadius: BorderRadius.circular(10),
      color: const Color(0x25021C2E), // Background color
    ),
    child: Stack(
      children: [
        FractionallySizedBox(
          widthFactor: progress, // Fill proportionally from 0 to 1
          child: Container(
            decoration: BoxDecoration(
              color: getColor(value),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

      ],
    ),
  );
}

Widget UVIndexBar({required double uvIndex}) {
  // Calculate position of the circle based on UV index, ensuring it's between 0 and 1
  double position = uvIndex * 11.8;

  // Colors for the gradient based on UV index
  List<Color> gradientColors = [
    Colors.green, // Low UV
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.blue, // High UV
  ];

  return Container(
    width: 150,
    height: 6,

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          left: position, // Position the circle
          top: 0, // Slightly above the bar to center the circle
          child: Container(
            width: 6,
            height: 7,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
