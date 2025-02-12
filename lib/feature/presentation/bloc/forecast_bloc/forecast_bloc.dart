import 'package:bloc/bloc.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/feature/domain/usecases/get_forecast.dart';
import 'package:test_app/feature/domain/usecases/search_location.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_event.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_state.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  final GetForecast getForecast;

  ForecastBloc({required this.getForecast}) : super(ForecastEmpty());

  Stream<ForecastState> mapEventToState(ForecastEvent event) async* {
    if (event is GeneralForecast) {
      yield* _mapForecastToState(event.location, event.days);
    }
  }

  Stream<ForecastState> _mapForecastToState(
      String locationQuery, int days) async* {
    yield ForecastLoading();

    final failureOrLocation = await getForecast(
        GetForecastParams(location: locationQuery, days: days));
    yield failureOrLocation.fold(
        (failure) => ForecastError(message: _failureToMessage(failure)),
        (forecast) => ForecastLoaded(forecast: forecast));
  }

  String _failureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      default:
        return '?? failure)';
    }
  }
}
