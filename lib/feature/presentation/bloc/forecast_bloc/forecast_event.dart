import 'package:equatable/equatable.dart';

abstract class ForecastEvent extends Equatable {
  const ForecastEvent();

  @override
  List<Object> get props => [];
}

class GeneralForecast extends ForecastEvent {
  final String location;
  final int days;

  GeneralForecast({required this.location, required this.days});
}
