import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/feature/domain/entities/forecast_entity.dart';
import 'package:test_app/feature/domain/entities/search_location_entity.dart';

abstract class ForecastRepo {
  Future<Either<Failure, GeneralForecastEntity>> getForecast(
      String location, int days);
  Future<Either<Failure, List<SearchLocationEntity>>> searchForecast(
      String location);
}
