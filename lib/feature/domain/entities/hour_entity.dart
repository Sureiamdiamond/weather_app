import 'package:test_app/feature/domain/entities/condition_entity.dart';

class HourEntity {
  int? timeepoch;
  String? time;
  double? tempc;
  double? tempf;
  int? isday;
  ConditionEntity? condition;
  double? windmph;
  double? windkph;
  int? winddegree;
  String? winddir;
  double? pressuremb;
  double? pressurein;
  double? precipmm;
  double? precipin;
  double? snowcm;
  int? humidity;
  int? cloud;
  double? feelslikec;
  double? feelslikef;
  double? windchillc;
  double? windchillf;
  double? heatindexc;
  double? heatindexf;
  double? dewpointc;
  double? dewpointf;
  int? willitrain;
  int? chanceofrain;
  int? willitsnow;
  int? chanceofsnow;
  double? viskm;
  double? vismiles;
  double? gustmph;
  double? gustkph;
  num? uv;

  HourEntity(
      {this.timeepoch,
      this.time,
      this.tempc,
      this.tempf,
      this.isday,
      this.condition,
      this.windmph,
      this.windkph,
      this.winddegree,
      this.winddir,
      this.pressuremb,
      this.pressurein,
      this.precipmm,
      this.precipin,
      this.snowcm,
      this.humidity,
      this.cloud,
      this.feelslikec,
      this.feelslikef,
      this.windchillc,
      this.windchillf,
      this.heatindexc,
      this.heatindexf,
      this.dewpointc,
      this.dewpointf,
      this.willitrain,
      this.chanceofrain,
      this.willitsnow,
      this.chanceofsnow,
      this.viskm,
      this.vismiles,
      this.gustmph,
      this.gustkph,
      this.uv});
}
