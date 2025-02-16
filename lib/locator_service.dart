import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/platform/network_info.dart';
import 'package:test_app/feature/data/datasources/forecast_local_data.dart';
import 'package:test_app/feature/data/datasources/forecast_remote_data.dart';
import 'package:test_app/feature/data/repositories/forecast_repository.dart';
import 'package:test_app/feature/domain/repositories/forecast_repo.dart';
import 'package:test_app/feature/domain/usecases/get_forecast.dart';
import 'package:test_app/feature/domain/usecases/search_location.dart';
import 'package:test_app/feature/presentation/bloc/forecast_bloc/forecast_bloc.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  //Repository
  getIt.registerLazySingleton<ForecastRemoteData>(
      () => ForecastRemoteDataSource(client: getIt<http.Client>()));

  getIt.registerLazySingleton<ForecastLocalData>(() =>
      ForecastLocalDataSource(sharedPreferences: getIt<SharedPreferences>()));

  getIt.registerLazySingleton<ForecastRepo>(() => ForecastRepository(
      remoteDataSource: getIt<ForecastRemoteData>(),
      localDataSource: getIt<ForecastLocalData>(),
      networkInfo: getIt<NetworkInfo>()));

  //UseCases
  getIt.registerLazySingleton(() => GetForecast(getIt<ForecastRepo>()));
  getIt.registerLazySingleton(() => SearchLocation(getIt<ForecastRepo>()));

  //Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => InternetConnectionChecker.instance);

  // Bloc
  getIt.registerFactory(
    () => ForecastBloc(getForecast: getIt<GetForecast>()),
  );
  getIt.registerFactory(
    () => LocationSearchBloc(searchLocation: getIt<SearchLocation>()),
  );
}
