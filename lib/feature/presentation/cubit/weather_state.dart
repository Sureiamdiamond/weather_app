import 'package:equatable/equatable.dart';
import 'package:test_app/feature/domain/entities/forecast_entity.dart';

abstract class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object> get props => [];
}

class ForecastEmpty extends ForecastState {}

class ForecastLoading extends ForecastState {
  final GeneralForecastEntity oldForecast;

  ForecastLoading(this.oldForecast);

  List<Object> get props => [oldForecast];
}

class ForecastLoaded extends ForecastState {
  final GeneralForecastEntity forecast;

  ForecastLoaded(this.forecast);

  @override
  List<Object> get props => [forecast];
}

class ForecastError extends ForecastState {
  final String message;

  ForecastError({required this.message});

  @override
  List<Object> get props => [message];
}
