import 'package:test_app/feature/domain/entities/condition_entity.dart';

class DayEntity {
  double? maxtempc;
  double? maxtempf;
  double? mintempc;
  double? mintempf;
  double? avgtempc;
  double? avgtempf;
  double? maxwindmph;
  double? maxwindkph;
  double? totalprecipmm;
  double? totalprecipin;
  double? totalsnowcm;
  double? avgviskm;
  double? avgvismiles;
  int? avghumidity;
  int? dailywillitrain;
  int? dailychanceofrain;
  int? dailywillitsnow;
  int? dailychanceofsnow;
  ConditionEntity? condition;
  double? uv;

  DayEntity(
      {this.maxtempc,
      this.maxtempf,
      this.mintempc,
      this.mintempf,
      this.avgtempc,
      this.avgtempf,
      this.maxwindmph,
      this.maxwindkph,
      this.totalprecipmm,
      this.totalprecipin,
      this.totalsnowcm,
      this.avgviskm,
      this.avgvismiles,
      this.avghumidity,
      this.dailywillitrain,
      this.dailychanceofrain,
      this.dailywillitsnow,
      this.dailychanceofsnow,
      this.condition,
      this.uv});
}
