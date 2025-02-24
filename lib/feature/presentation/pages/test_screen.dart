import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/feature/presentation/pages/search_page.dart';

import '../bloc/forecast_bloc/forecast_bloc.dart';
import '../bloc/forecast_bloc/forecast_event.dart';


class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String location = 'Moscow';
  void changeLocation (){}

  Logger logger = Logger();

  late AnimationController _fadeController;

  late Animation<double> _fadeAnimation;

  late Animation<double> _loadingFadeAnimation;

  void _fetchForecast(BuildContext context) {
    BlocProvider.of<ForecastBloc>(context)
        .add(GeneralForecast(location: location, days: 7));
  }

  Future<void> _loadLocation(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      location =
          prefs.getString('location') ?? 'Moscow';
    });
    _fetchForecast( context);
  }

  Future<void> _saveLocation(String newLocation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'location', newLocation);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Column(
          children: [
            LocationHeader(saveLoc: _saveLocation, loadLoc: ()=> _loadLocation(context),location: location,),
            WeatherSummary(),
            WeatherDetails(),
            TodayForecast(),
            NextForecast(),
          ],
        ),
      ),
    );
  }
}

class LocationHeader extends StatefulWidget {
  final Function saveLoc;
  final Function loadLoc;
  final String location;
  const LocationHeader({
    required this.saveLoc,
    required this.loadLoc,
    required this.location,
    super.key});

  @override
  State<LocationHeader> createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
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

                    });
                   await widget.saveLoc(result);
                   widget.loadLoc();
                  }
                },
                icon: const Icon(Icons.search),
                color: Colors.white,
                iconSize: 35,
              ),
              const SizedBox(width: 8),
              Text(
               "test",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const Icon(Icons.notifications, color: Colors.white),
        ],
      ),
    );
  }
}

class WeatherSummary extends StatelessWidget {
  const WeatherSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.cloud, size: 100, color: Colors.white),
        SizedBox(height: 16),
        Text(
          '28º',
          style: TextStyle(color: Colors.white, fontSize: 64),
        ),
        Text(
          'Precipitations',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
        Text(
          'Max.: 31º  Min.: 25º',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }
}

class WeatherDetails extends StatelessWidget {
  const WeatherDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WeatherDetailItem(icon: Icons.water_drop, value: '6%'),
          WeatherDetailItem(icon: Icons.thermostat, value: '90%'),
          WeatherDetailItem(icon: Icons.air, value: '19 km/h'),
        ],
      ),
    );
  }
}

class WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String value;

  const WeatherDetailItem({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}

class TodayForecast extends StatelessWidget {
  const TodayForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                'Mar, 9',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                ForecastItem(time: '15:00', temp: '29ºC', icon: Icons.cloud),
                ForecastItem(time: '16:00', temp: '26ºC', icon: Icons.cloud_queue),
                ForecastItem(time: '17:00', temp: '24ºC', icon: Icons.cloud_outlined),
                ForecastItem(time: '18:00', temp: '23ºC', icon: Icons.wb_cloudy),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ForecastItem extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;

  const ForecastItem({
    super.key,
    required this.time,
    required this.temp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            temp,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class NextForecast extends StatelessWidget {
  const NextForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Forecast',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Icon(Icons.calendar_today, color: Colors.white70),
            ],
          ),
          SizedBox(height: 16),
          NextForecastItem(day: 'Monday', temp: '13º | 10º', icon: Icons.water),
          NextForecastItem(day: 'Tuesday', temp: '17º | 12º', icon: Icons.wb_sunny),
        ],
      ),
    );
  }
}

class NextForecastItem extends StatelessWidget {
  final String day;
  final String temp;
  final IconData icon;

  const NextForecastItem({
    super.key,
    required this.day,
    required this.temp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 16),
              Text(
                day,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          Text(
            temp,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}