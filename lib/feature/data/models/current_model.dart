import 'package:test_app/feature/data/models/condition_model.dart';
import 'package:test_app/feature/domain/entities/current_entity.dart';

class CurrentModel extends CurrentEntity {
  CurrentModel(
      {lastupdatedepoch,
      lastupdated,
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
      viskm,
      vismiles,
      uv,
      gustmph,
      gustkph})
      : super(
          lastupdatedepoch: lastupdatedepoch,
          lastupdated: lastupdated,
          tempc: tempc,
          tempf: tempf,
          isday: isday,
          condition: condition,
          windkph: windkph,
          windmph: windmph,
          winddegree: winddegree,
          winddir: winddir,
          pressuremb: pressuremb,
          pressurein: pressurein,
          precipmm: precipmm,
          precipin: precipin,
          humidity: humidity,
          cloud: cloud,
          feelslikec: feelslikec,
          feelslikef: feelslikec,
          windchillc: windchillc,
          windchillf: windchillf,
          heatindexc: heatindexc,
          heatindexf: heatindexf,
          dewpointc: dewpointc,
          dewpointf: dewpointf,
          viskm: viskm,
          vismiles: vismiles,
          uv: uv,
          gustmph: gustmph,
          gustkph: gustkph,
        );

  CurrentModel.fromJson(Map<String, dynamic> json) {
    lastupdatedepoch = json['last_updated_epoch'];
    lastupdated = json['last_updated'];
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
    viskm = json['vis_km'];
    vismiles = json['vis_miles'];
    uv = json['uv'];
    gustmph = json['gust_mph'];
    gustkph = json['gust_kph'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['last_updated_epoch'] = lastupdatedepoch;
    data['last_updated'] = lastupdated;
    data['temp_c'] = tempc;
    data['temp_f'] = tempf;
    data['is_day'] = isday;
    data['condition'] != condition;
    data['wind_mph'] = windmph;
    data['wind_kph'] = windkph;
    data['wind_degree'] = winddegree;
    data['wind_dir'] = winddir;
    data['pressure_mb'] = pressuremb;
    data['pressure_in'] = pressurein;
    data['precip_mm'] = precipmm;
    data['precip_in'] = precipin;
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
    data['vis_km'] = viskm;
    data['vis_miles'] = vismiles;
    data['uv'] = uv;
    data['gust_mph'] = gustmph;
    data['gust_kph'] = gustkph;
    return data;
  }
}
