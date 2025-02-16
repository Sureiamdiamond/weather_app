import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/core/usecases/usecase.dart';
import 'package:test_app/feature/data/repositories/forecast_repository.dart';
import 'package:test_app/feature/domain/entities/forecast_entity.dart';
import 'package:test_app/feature/domain/repositories/forecast_repo.dart';

class GetForecast extends UseCase<GeneralForecastEntity, GetForecastParams> {
  final ForecastRepo forecastRepo;

  GetForecast(this.forecastRepo);

  @override
  Future<Either<Failure, GeneralForecastEntity>> call(
      GetForecastParams params) async {
    return await forecastRepo.getForecast(params.location, params.days);
  }
}

class GetForecastParams extends Equatable {
  final int days;
  final String location;

  const GetForecastParams({required this.days, required this.location});

  @override
  List<Object> get props => [days, location];
}
