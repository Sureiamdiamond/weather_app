import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_bloc.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:test_app/feature/presentation/pages/weathet_page.dart';
import 'package:test_app/locator_service.dart';

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
        BlocProvider<ForecastBloc>(create: (context) => sl<ForecastBloc>()),
        BlocProvider<LocationSearchBloc>(
            create: (context) => sl<LocationSearchBloc>()),
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          dialogBackgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.grey,
        ),
        home: HomePage(),
      ),
    );
  }
}
