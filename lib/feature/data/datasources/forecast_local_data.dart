import 'dart:convert';

import 'package:test_app/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/feature/data/models/forecast_model.dart';

abstract class ForecastLocalData {
  Future<GeneralForecastModel> getLastForecastFromCache();
  Future<void> forecastToCache(GeneralForecastModel forecast);
}

const CACHED_FORECAST = 'CACHED_FORECAST';

class ForecastLocalDataSource implements ForecastLocalData {
  final SharedPreferences sharedPreferences;

  ForecastLocalDataSource({required this.sharedPreferences});

  @override
  Future<GeneralForecastModel> getLastForecastFromCache() {
    final jsonForecast = sharedPreferences.getString((CACHED_FORECAST));
    if (jsonForecast!.isNotEmpty) {
      print('Cache: ${jsonForecast.length}');
      return Future.value(
          GeneralForecastModel.fromJson(json.decode(jsonForecast)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> forecastToCache(GeneralForecastModel forecast) {
    final String jsonForecast = json.encode(forecast.toJson());

    sharedPreferences.setString(CACHED_FORECAST, jsonForecast);
    print('Cache:  ${jsonForecast}');
    return Future.value(jsonForecast);
  }
}
