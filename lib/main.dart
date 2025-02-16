import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_bloc.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:test_app/feature/presentation/pages/weather_page.dart';
import 'package:test_app/locator_service.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ForecastBloc>(create: (context) => getIt<ForecastBloc>()),
        BlocProvider<LocationSearchBloc>(
            create: (context) => getIt<LocationSearchBloc>()),
      ],
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
