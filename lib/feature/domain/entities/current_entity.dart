import 'package:test_app/feature/domain/entities/condition_entity.dart';

class CurrentEntity {
  int? lastupdatedepoch;
  String? lastupdated;
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
  double? viskm;
  double? vismiles;
  double? uv;
  double? gustmph;
  double? gustkph;

  CurrentEntity(
      {this.lastupdatedepoch,
      this.lastupdated,
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
      this.viskm,
      this.vismiles,
      this.uv,
      this.gustmph,
      this.gustkph});
}
