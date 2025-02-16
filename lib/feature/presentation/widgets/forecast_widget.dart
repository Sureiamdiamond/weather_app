import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_bloc.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_event.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_state.dart';
import 'package:test_app/feature/presentation/widgets/loading_widget.dart';

class Forecast extends StatelessWidget {
  const Forecast({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ForecastBloc>(context)
        .add(GeneralForecast(location: 'Москва', days: 7));

    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        print(state);
        if (state is ForecastLoading) {
          return LoadingIcon();
        } else if (state is ForecastLoaded) {
          final forecast = state.forecast;
          return Text(forecast.current?.condition?.text ?? "",
              style: TextStyle(color: Colors.black));
        } else if (state is ForecastError) {
          return _showErrorText(state.message);
        } else {
          return const Center(
            child: Icon(Icons.nature),
          );
        }
      },
    );
  }
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
