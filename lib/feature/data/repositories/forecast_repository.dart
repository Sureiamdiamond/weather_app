import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/exceptions.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/core/platform/network_info.dart';
import 'package:test_app/feature/data/datasources/forecast_local_data.dart';
import 'package:test_app/feature/data/datasources/forecast_remote_data.dart';
import 'package:test_app/feature/domain/entities/forecast_entity.dart';
import 'package:test_app/feature/domain/entities/search_location_entity.dart';
import 'package:test_app/feature/domain/repositories/forecast_repo.dart';

class ForecastRepository implements ForecastRepo {
  final ForecastRemoteData remoteDataSource;
  final ForecastLocalData localDataSource;
  final NetworkInfo networkInfo;

  ForecastRepository(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, GeneralForecastEntity>> getForecast(
      String location, int days) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteForecast =
            await remoteDataSource.getForecast(location, days);
        localDataSource.forecastToCache(remoteForecast);
        return Right(remoteForecast);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localForecast = await localDataSource.getLastForecastFromCache();
        return Right(localForecast);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<SearchLocationEntity>>> searchForecast(
      String location) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteForecast = await remoteDataSource.searchForecast(location);
        return Right(remoteForecast);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return throw ServerException();
    }
  }
}
