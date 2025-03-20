import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_bloc.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_event.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_state.dart';
import 'package:test_app/feature/presentation/pages/search_page.dart';
import 'package:test_app/feature/presentation/widgets/app_menu_widget.dart';
import 'package:test_app/feature/presentation/widgets/loading_widget.dart';
import 'package:test_app/feature/presentation/widgets/progress_bar_widget.dart';
import 'package:test_app/feature/presentation/widgets/sunset_moonset_widget.dart';
import 'package:test_app/feature/presentation/widgets/uv_index_widget.dart';
import 'package:test_app/feature/presentation/widgets/weather_icon_widget.dart';
import 'package:test_app/feature/presentation/widgets/weather_info_widget.dart';
import '../components/int/show_hour_int.dart';
import '../components/strings/feels_like_string.dart';
import '../components/strings/get_date_string.dart';
import '../components/strings/get_day_night_string.dart';
import '../components/strings/week_day_strings.dart';
import '../style/gradiant_color.dart';
import '../style/text_styles.dart';
import 'error_widget.dart';

class ForecastWidget extends StatefulWidget {
  const ForecastWidget({super.key});

  @override
  _ForecastWidgetState createState() => _ForecastWidgetState();
}

class _ForecastWidgetState extends State<ForecastWidget> with SingleTickerProviderStateMixin {
  String location = 'Tehran';
  Logger logger = Logger();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _loadingFadeAnimation;

  void _fetchForecast() {
    BlocProvider.of<ForecastBloc>(context).add(GeneralForecast(location: location, days: 7));
  }

  Future<void> _loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      location = prefs.getString('location') ?? 'Tehran';
    });
    _fetchForecast();
  }

  Future<void> _saveLocation(String newLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', newLocation);
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
            color: Colors.white,
            child: FadeTransition(
              opacity: _loadingFadeAnimation,
              child: const LoadingIcon(),
            ),
          );
        } else if (state is ForecastLoaded) {


          _fadeController.forward();
          final forecast = state.forecast;
          showHour(forecast.location?.localtime ?? "00:00");
          final String dayOrNight = getDayOrNight(forecast.location?.localtime ?? "00:00");
          String condition = forecast.current!.condition!.text!.toLowerCase();
          final Gradient backColor = getBackgroundGradient(forecast.current?.condition?.text?.toLowerCase() ?? "sunny", forecast.current?.isday ?? 2);
          String dayName = getWeekDay(forecast.location?.localtime ?? "");
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
                    child: Column(children: [
                      const SizedBox(height: 50),
                      ///menu
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                               const AppMenu(),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          elevation: 0,
                                          backgroundColor: const Color(0x00234354),
                                          content: Container(
                                            width: 700,
                                            height: 60,
                                            // Set the width
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xC8042B49), // Background color
                                              borderRadius: BorderRadius.circular(30), // Rounded corners
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Your Chosen location is ${forecast.location?.name} - ${forecast.location?.country}',
                                                style: AppTextStyles.days,
                                              ),
                                            ),
                                          ),

                                          duration: const Duration(milliseconds: 2400),
                                          behavior: SnackBarBehavior.floating,
                                          // Make the Snackbar float
                                          margin:
                                              const EdgeInsets.fromLTRB(0, 0, 0, 20), // Space from the bottom
                                        ),
                                      );
                                    },
                                    child: Text(
                                      forecast.location?.name ?? "",
                                      style: AppTextStyles.cityName,
                                    )),
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                final result = await Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return const SearchPage();
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween =
                                          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
                                          backgroundColor: Colors.white,
                                          body: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: CircularProgressIndicator(color: Colors.black45),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                "Loading",
                                                style: TextStyle(
                                                    fontFamily: "SF",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45),
                                              )
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
                      ///Upper Part
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 25),

                            ///icon condition
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: getWeatherIcon(
                                condition,
                                dayOrNight,
                                forecast.current?.condition?.text,
                              ),
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
                                Text(dayName, style: AppTextStyles.lightTexts),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Text('|', style: AppTextStyles.lightTexts),
                                ),
                                Text(forecast.current?.condition?.text ?? "",
                                    style: AppTextStyles.lightTexts),
                              ],
                            ),

                            ///Temperature
                            Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child: Text(
                                '${forecast.current?.tempc?.toInt() ?? '--'}°',
                                style: AppTextStyles.temperature,
                              ),
                            ),

                            ///Ttile and Max Min
                            const Text("Precipitations", style: AppTextStyles.lightTexts),
                            Text(
                                'Min: ${forecast.forecast?.forecastday?.first?.day?.mintempc?.toInt()}°   Max: ${forecast.forecast?.forecastday?.first?.day?.maxtempc?.toInt()}° ',
                                style: AppTextStyles.lightTexts),

                            const SizedBox(
                              height: 40,
                            ),

                            /// small (first) circular radius container
                            Bounceable(
                              onTap: () {},
                              child: Container(
                                height: 45,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(56, 1, 17, 28),
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Union.svg',
                                          height: 16,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${forecast.current?.cloud.toString()}%',
                                          style: AppTextStyles.subheading,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/images/humidity_bar.svg'),
                                        Text(
                                          '${forecast.current?.humidity.toString()}%',
                                          style: AppTextStyles.subheading,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset('assets/images/wind_bar.svg'),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          '${forecast.current?.windkph.toString()}',
                                          style: AppTextStyles.subheading,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
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

                            const SizedBox(
                              height: 20,
                            ),

                            /// big (second) circular radius container
                            Bounceable(
                              onTap: () {},
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(56, 1, 17, 28),
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Column(
                                  children: [
                                    /// Date
                                    Padding(
                                      padding: const EdgeInsets.only(top: 13.0, left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Today", style: AppTextStyles.today),
                                          Text(
                                            getDate(forecast.location?.localtime?.split(" ")[0] ?? "00:00"),
                                            style: AppTextStyles.date,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 138,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: forecast.forecast?.forecastday?.first?.hour?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          final hourData =
                                              forecast.forecast?.forecastday?.first?.hour?[index];
                                          final time = hourData?.time?.split(" ").last ?? "No Data";
                                          final temp =
                                              hourData?.tempc?.toInt() ?? "N/A"; // Temperature in Celsius
                                          final iconUrl =
                                              "https:${hourData?.condition?.icon ?? ""}"; // Weather icon URL

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
                                                      color: Colors.white, fontSize: 14, fontFamily: 'SP'),
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

                            const SizedBox(
                              height: 20,
                            ),

                            /// medium (third) circular radius container
                            Bounceable(
                              onTap: () {},
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
                                          padding: EdgeInsets.only(top: 13.0, left: 15, right: 15),
                                          child: Text("Next Forecast", style: AppTextStyles.today),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 13.0, left: 13, right: 13),
                                          child: Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 125,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.vertical,
                                        itemCount: forecast.forecast?.forecastday?.length ?? 0,
                                        // 3 days of forecast
                                        itemBuilder: (context, index) {
                                          final dayData = forecast.forecast?.forecastday?[index];
                                          final date =
                                              dayData?.date != null ? getDate(dayData!.date!) : "No Date";

                                          final minTemp = dayData?.day?.mintempc?.toInt() ?? "N/A";
                                          final maxTemp = dayData?.day?.maxtempc?.toInt() ?? "N/A";
                                          final iconUrl =
                                              "https:${dayData?.day?.condition?.icon ?? ""}"; // Weather icon URL

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
                                                    Text(
                                                      "$maxTemp°C",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
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
                      ),
                      ///first two small widget
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 10),
                        child: Row(
                          children: [
                            WeatherInfoCard(
                              title: "FEELS LIKE",
                              value: '${forecast.current?.feelslikec?.toInt()}',
                              unit: "°",
                              unitStyle: AppTextStyles.pressure,
                              description: temperatureMessage,
                              iconPath: "assets/images/tempture.png",
                              backText:
                                  "How the temperature feels to the human body, factoring in wind and humidity.",
                            ),
                            const SizedBox(width: 15),
                            WeatherInfoCard(
                              title: "GUST",
                              valuetStyle: AppTextStyles.medium,
                              value: '${forecast.current?.gustkph}',
                              unitStyle: AppTextStyles.kph,
                              unit: "Kp/h",
                              description: "The gust shows sudden, strong bursts of wind",
                              iconPath: "assets/images/small_wind.png",
                              progressBar: ProgressBar(value: forecast.current?.gustkph?.toDouble() ?? 0.0),
                              backText: "The maximum speed of sudden bursts of wind",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ///sunset & moonset
                      SunSetPicture(forecast: forecast),
                      const SizedBox(
                          height: 5),
                      ///second two small widget
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 10),
                        child: Row(
                          children: [
                            WeatherInfoCard(
                              title: "UV INDEX",
                              value: forecast.forecast?.forecastday?.first?.day?.uv?.toString() ?? "No Data",
                              unit: "",
                              description: "Wear sunglasses.",
                              iconPath: "assets/images/uv_small.png",
                              progressBar: UVIndexBar(
                                  uvIndex: forecast.forecast?.forecastday?.first?.day?.uv?.toDouble() ?? 0.0),
                              backText:
                                  "A measure of the strength of ultraviolet (UV) radiation from the sun",
                            ),
                            const SizedBox(width: 15),
                            WeatherInfoCard(
                              title: "PRESSURE",
                              valuetStyle: AppTextStyles.medium,
                              value: forecast.current?.pressuremb?.toInt().toString() ?? "",
                              unit: "mb",
                              unitStyle: AppTextStyles.mb,
                              description: "Indicating how heavy or light it is in location",
                              iconPath: "assets/images/pressure.png",
                              backText: "The atmospheric pressure, indicating changes in weather patterns.",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
        } else if (state is ForecastError) {
          return showErrorText(state.message);
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






