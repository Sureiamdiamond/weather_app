import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/feature/domain/usecases/get_forecast.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_event.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_state.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  final GetForecast getForecast;

  ForecastBloc({required this.getForecast}) : super(ForecastEmpty()) {
    on<GeneralForecast>(_onEvent);
  }

  FutureOr<void> _onEvent(
      GeneralForecast event, Emitter<ForecastState> emit) async {
    emit(ForecastLoading());

    final failureOrForecast = await getForecast(
        GetForecastParams(days: event.days, location: event.location));
    emit(failureOrForecast.fold(
        (failure) => ForecastError(message: _failureToMessage(failure)),
        (forecast) => ForecastLoaded(forecast: forecast)));
  }

  String _failureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server Failure';
      default:
        return '?? failure)';
    }
  }
}
