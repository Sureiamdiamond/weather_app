import 'package:test_app/feature/data/models/condition_model.dart';
import 'package:test_app/feature/domain/entities/hour_entity.dart';

class HourModel extends HourEntity {
  HourModel(
      {timeepoch,
      time,
      tempc,
      tempf,
      isday,
      condition,
      windmph,
      windkph,
      winddegree,
      winddir,
      pressuremb,
      pressurein,
      precipmm,
      precipin,
      snowcm,
      humidity,
      cloud,
      feelslikec,
      feelslikef,
      windchillc,
      windchillf,
      heatindexc,
      heatindexf,
      dewpointc,
      dewpointf,
      willitrain,
      chanceofrain,
      willitsnow,
      chanceofsnow,
      viskm,
      vismiles,
      gustmph,
      gustkph,
      uv})
      : super(
          timeepoch: timeepoch,
          time: time,
          tempc: tempc,
          tempf: tempf,
          isday: isday,
          condition: condition,
          windmph: windmph,
          windkph: windkph,
          winddegree: winddegree,
          winddir: winddir,
          pressuremb: pressuremb,
          pressurein: pressurein,
          precipmm: precipmm,
          precipin: precipin,
          snowcm: snowcm,
          humidity: humidity,
          cloud: cloud,
          feelslikec: feelslikec,
          feelslikef: feelslikef,
          windchillc: windchillc,
          windchillf: windchillf,
          heatindexc: heatindexc,
          heatindexf: heatindexf,
          dewpointc: dewpointc,
          dewpointf: dewpointf,
          willitrain: willitrain,
          chanceofrain: chanceofrain,
          willitsnow: willitsnow,
          chanceofsnow: chanceofsnow,
          viskm: viskm,
          vismiles: vismiles,
          gustmph: gustmph,
          gustkph: gustkph,
          uv: uv,
        );

  HourModel.fromJson(Map<String, dynamic> json) {
    timeepoch = json['time_epoch'];
    time = json['time'];
    tempc = json['temp_c'];
    tempf = json['temp_f'];
    isday = json['is_day'];
    condition = json['condition'] != null
        ? ConditionModel?.fromJson(json['condition'])
        : null;
    windmph = json['wind_mph'];
    windkph = json['wind_kph'];
    winddegree = json['wind_degree'];
    winddir = json['wind_dir'];
    pressuremb = json['pressure_mb'];
    pressurein = json['pressure_in'];
    precipmm = json['precip_mm'];
    precipin = json['precip_in'];
    snowcm = json['snow_cm'];
    humidity = json['humidity'];
    cloud = json['cloud'];
    feelslikec = json['feelslike_c'];
    feelslikef = json['feelslike_f'];
    windchillc = json['windchill_c'];
    windchillf = json['windchill_f'];
    heatindexc = json['heatindex_c'];
    heatindexf = json['heatindex_f'];
    dewpointc = json['dewpoint_c'];
    dewpointf = json['dewpoint_f'];
    willitrain = json['will_it_rain'];
    chanceofrain = json['chance_of_rain'];
    willitsnow = json['will_it_snow'];
    chanceofsnow = json['chance_of_snow'];
    viskm = json['vis_km'];
    vismiles = json['vis_miles'];
    gustmph = json['gust_mph'];
    gustkph = json['gust_kph'];
    uv = json['uv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['time_epoch'] = timeepoch;
    data['time'] = time;
    data['temp_c'] = tempc;
    data['temp_f'] = tempf;
    data['is_day'] = isday;
    data['condition'] = condition;
    data['wind_mph'] = windmph;
    data['wind_kph'] = windkph;
    data['wind_degree'] = winddegree;
    data['wind_dir'] = winddir;
    data['pressure_mb'] = pressuremb;
    data['pressure_in'] = pressurein;
    data['precip_mm'] = precipmm;
    data['precip_in'] = precipin;
    data['snow_cm'] = snowcm;
    data['humidity'] = humidity;
    data['cloud'] = cloud;
    data['feelslike_c'] = feelslikec;
    data['feelslike_f'] = feelslikef;
    data['windchill_c'] = windchillc;
    data['windchill_f'] = windchillf;
    data['heatindex_c'] = heatindexc;
    data['heatindex_f'] = heatindexf;
    data['dewpoint_c'] = dewpointc;
    data['dewpoint_f'] = dewpointf;
    data['will_it_rain'] = willitrain;
    data['chance_of_rain'] = chanceofrain;
    data['will_it_snow'] = willitsnow;
    data['chance_of_snow'] = chanceofsnow;
    data['vis_km'] = viskm;
    data['vis_miles'] = vismiles;
    data['gust_mph'] = gustmph;
    data['gust_kph'] = gustkph;
    data['uv'] = uv;
    return data;
  }
}
