import 'package:test_app/feature/domain/entities/astro_entity.dart';
import 'package:test_app/feature/domain/entities/current_entity.dart';
import 'package:test_app/feature/domain/entities/day_entity.dart';
import 'package:test_app/feature/domain/entities/hour_entity.dart';
import 'package:test_app/feature/domain/entities/location_entity.dart';

class ForecastEntity {
  List<ForecastdayEntity?>? forecastday;

  ForecastEntity({this.forecastday});
}

class ForecastdayEntity {
  String? date;
  int? dateepoch;
  DayEntity? day;
  AstroEntity? astro;
  List<HourEntity?>? hour;

  ForecastdayEntity(
      {this.date, this.dateepoch, this.day, this.astro, this.hour});
}

class GeneralForecastEntity {
  LocationEntity? location;
  CurrentEntity? current;
  ForecastEntity? forecast;

  GeneralForecastEntity({this.location, this.current, this.forecast});
}
