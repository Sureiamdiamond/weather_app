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

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => ForecastBloc(getForecast: sl()),
  );
  sl.registerFactory(
    () => LocationSearchBloc(searchLocation: sl()),
  );

  //UseCases
  sl.registerLazySingleton(() => GetForecast(sl()));
  sl.registerLazySingleton(() => SearchLocation(sl()));

  //Repository
  sl.registerLazySingleton<ForecastRepo>(() => ForecastRepository(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<ForecastRemoteData>(
      () => ForecastRemoteDataSource(client: http.Client()));

  sl.registerLazySingleton<ForecastLocalData>(
      () => ForecastLocalDataSource(sharedPreferences: sl()));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker);
}
