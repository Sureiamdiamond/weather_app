import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_app/env/env.dart';
import 'package:test_app/core/error/exceptions.dart';
import 'package:test_app/feature/data/models/forecast_model.dart';
import 'package:test_app/feature/data/models/location_model.dart';

abstract class ForecastRemoteData {
  //http://api.weatherapi.com/v1/forecast.json?key=7e544180c7b345848a2195540240812&q=London&days=7
  Future<GeneralForecastModel> getForecast(String location, int days);
  //https://api.weatherapi.com/v1/search.json?key=7e544180c7b345848a2195540240812&q=Moscow
  Future<List<LocationModel>> searchForecast(String location);
}

class ForecastRemoteDataSource implements ForecastRemoteData {
  final http.Client client;

  ForecastRemoteDataSource({required this.client});

  @override
  Future<GeneralForecastModel> getForecast(String location, int days) async {
    final response = await client.get(
        Uri.parse(
            '//http://api.weatherapi.com/v1/forecast.json?key=${Env.forecastApiKey}&q=$location&days=$days'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final forecast = json.decode(response.body);
      return GeneralForecastModel.fromJson(forecast);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<LocationModel>> searchForecast(String location) async {
    final response = await client.get(
        Uri.parse(
            '//https://api.weatherapi.com/v1/search.json?key=${Env.forecastApiKey}&q=$location'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final forecasts = json.decode(response.body);
      return (forecasts['results'] as List)
          .map((forecast) => LocationModel.fromJson(forecast))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
