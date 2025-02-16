import 'package:animated_emoji/animated_emoji.dart';
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
    String location = 'Moscow';
    int days = 7;

    BlocProvider.of<ForecastBloc>(context)
        .add(GeneralForecast(location: location, days: days));

    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastLoading) {
          return LoadingIcon();
        } else if (state is ForecastLoaded) {
          final forecast = state.forecast;
          return Container(
            color: Colors.white,
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Распределяем пространство между элементами
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Выравниваем текст по левому краю
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
                        crossAxisAlignment: CrossAxisAlignment
                            .end, // Выравниваем текст по правому краю
                        children: [
                          Text(
                              forecast.location?.localtime?.substring(0, 10) ??
                                  "",
                              style: AppTextStyles.heading),
                          Text(forecast.current?.condition?.text ?? "",
                              style: AppTextStyles.subheading),
                        ],
                      ),
                    ),
                  ]),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Image.network(
                        "https:${forecast.current?.condition?.icon}",
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      '${forecast.current?.tempc?.toInt()}°',
                      style: AppTextStyles.temperature,
                    )
                  ],
                ),
              ),
            ]),
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

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontFamily: 'Open Sans',
    color: Colors.black,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontFamily: 'Open Sans',
    color: Colors.black,
  );

  static const TextStyle temperature = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontFamily: 'Open Sans',
    color: Colors.black,
  );
}
