import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:test_app/env/env.dart';
import 'package:test_app/core/error/exceptions.dart';
import 'package:test_app/feature/data/models/forecast_model.dart';
import 'package:test_app/feature/data/models/search_location_model.dart';

abstract class ForecastRemoteData {
  Future<GeneralForecastModel> getForecast(String location, int days);
  Future<List<SearchLocationModel>> searchForecast(String location);
}

class ForecastRemoteDataSource implements ForecastRemoteData {
  final http.Client client;
  Logger logger = Logger();

  ForecastRemoteDataSource({required this.client});

  @override
  Future<GeneralForecastModel> getForecast(String location, int days) async {
    final response = await client.get(
        Uri.parse(
            'https://api.weatherapi.com/v1/forecast.json?key=${Env.forecastApiKey}&q=$location&days=$days'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final forecast = json.decode(response.body);
      return GeneralForecastModel.fromJson(forecast);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SearchLocationModel>> searchForecast(String location) async {
    final response = await client.get(
        Uri.parse(
            'https://api.weatherapi.com/v1/search.json?key=${Env.forecastApiKey}&q=$location'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final forecasts = json.decode(response.body);
      logger.i("Responce successful ${forecasts}");
      return (forecasts as List)
          .map((forecast) => SearchLocationModel.fromJson(forecast))
          .toList();
    } else {
      logger.e("Somethhing wrong ${response.statusCode}");
      throw ServerException();
    }
  }
}
