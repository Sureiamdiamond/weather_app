import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/core/usecases/usecase.dart';
import 'package:test_app/feature/domain/entities/location_entity.dart';
import 'package:test_app/feature/domain/entities/search_location_entity.dart';
import 'package:test_app/feature/domain/repositories/forecast_repo.dart';

class SearchLocation
    extends UseCase<List<SearchLocationEntity>, SearchLocationParams> {
  final ForecastRepo forecastRepo;

  SearchLocation(this.forecastRepo);

  Future<Either<Failure, List<SearchLocationEntity>>> call(
      SearchLocationParams params) async {
    return await forecastRepo.searchForecast(params.location);
  }
}

class SearchLocationParams extends Equatable {
  final String location;

  const SearchLocationParams({required this.location});

  @override
  List<Object> get props => [];
}
