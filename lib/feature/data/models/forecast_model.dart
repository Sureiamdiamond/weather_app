import 'package:test_app/feature/data/models/astro_model.dart';
import 'package:test_app/feature/data/models/current_model.dart';
import 'package:test_app/feature/data/models/day_model.dart';
import 'package:test_app/feature/data/models/hour_model.dart';
import 'package:test_app/feature/data/models/location_model.dart';
import 'package:test_app/feature/domain/entities/forecast_entity.dart';

class ForecastModel extends ForecastEntity {
  ForecastModel({forecastday}) : super(forecastday: forecastday);

  ForecastModel.fromJson(Map<String, dynamic> json) {
    if (json['forecastday'] != null) {
      forecastday = <ForecastdayModel>[];
      json['forecastday'].forEach((v) {
        forecastday!.add(ForecastdayModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['forecastday'] = forecastday?.map((v) => v).toList();
    return data;
  }
}

class ForecastdayModel extends ForecastdayEntity {
  ForecastdayModel({date, dateepoch, day, astro, hour})
      : super(
            date: date,
            dateepoch: dateepoch,
            day: day,
            astro: astro,
            hour: hour);

  ForecastdayModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dateepoch = json['date_epoch'];
    day = json['day'] != null ? DayModel?.fromJson(json['day']) : null;
    astro = json['astro'] != null ? AstroModel?.fromJson(json['astro']) : null;
    if (json['hour'] != null) {
      hour = <HourModel>[];
      json['hour'].forEach((v) {
        hour!.add(HourModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = date;
    data['date_epoch'] = dateepoch;
    data['day'] = day;
    data['astro'] = astro;
    data['hour'] = hour != null ? hour!.map((v) => v).toList() : null;
    return data;
  }
}

class GeneralForecastModel extends GeneralForecastEntity {
  GeneralForecastModel({location, current, forecast})
      : super(location: location, current: current, forecast: forecast);

  GeneralForecastModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? LocationModel?.fromJson(json['location'])
        : null;
    current = json['current'] != null
        ? CurrentModel?.fromJson(json['current'])
        : null;
    forecast = json['forecast'] != null
        ? ForecastModel?.fromJson(json['forecast'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['location'] = location;
    data['current'] = current;
    data['forecast'] = forecast;
    return data;
  }
}
