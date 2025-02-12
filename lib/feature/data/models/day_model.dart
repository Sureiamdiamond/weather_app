import 'package:test_app/feature/data/models/condition_model.dart';
import 'package:test_app/feature/domain/entities/day_entity.dart';

class DayModel extends DayEntity {
  DayModel(
      {maxtempc,
      maxtempf,
      mintempc,
      mintempf,
      avgtempc,
      avgtempf,
      maxwindmph,
      maxwindkph,
      totalprecipmm,
      totalprecipin,
      totalsnowcm,
      avgviskm,
      avgvismiles,
      avghumidity,
      dailywillitrain,
      dailychanceofrain,
      dailywillitsnow,
      dailychanceofsnow,
      condition,
      uv})
      : super(
          maxtempc: maxtempc,
          maxtempf: maxtempf,
          mintempc: mintempc,
          mintempf: mintempf,
          avgtempc: avgtempc,
          avgtempf: avgtempf,
          maxwindmph: maxwindmph,
          maxwindkph: maxwindkph,
          totalprecipmm: totalprecipmm,
          totalprecipin: totalprecipin,
          totalsnowcm: totalsnowcm,
          avgviskm: avgviskm,
          avgvismiles: avgvismiles,
          avghumidity: avghumidity,
          dailywillitrain: dailywillitrain,
          dailychanceofrain: dailychanceofrain,
          dailywillitsnow: dailywillitsnow,
          dailychanceofsnow: dailychanceofsnow,
          condition: condition,
          uv: uv,
        );

  DayModel.fromJson(Map<String, dynamic> json) {
    maxtempc = json['maxtemp_c'];
    maxtempf = json['maxtemp_f'];
    mintempc = json['mintemp_c'];
    mintempf = json['mintemp_f'];
    avgtempc = json['avgtemp_c'];
    avgtempf = json['avgtemp_f'];
    maxwindmph = json['maxwind_mph'];
    maxwindkph = json['maxwind_kph'];
    totalprecipmm = json['totalprecip_mm'];
    totalprecipin = json['totalprecip_in'];
    totalsnowcm = json['totalsnow_cm'];
    avgviskm = json['avgvis_km'];
    avgvismiles = json['avgvis_miles'];
    avghumidity = json['avghumidity'];
    dailywillitrain = json['daily_will_it_rain'];
    dailychanceofrain = json['daily_chance_of_rain'];
    dailywillitsnow = json['daily_will_it_snow'];
    dailychanceofsnow = json['daily_chance_of_snow'];
    condition = json['condition'] != null
        ? ConditionModel?.fromJson(json['condition'])
        : null;
    uv = json['uv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['maxtemp_c'] = maxtempc;
    data['maxtemp_f'] = maxtempf;
    data['mintemp_c'] = mintempc;
    data['mintemp_f'] = mintempf;
    data['avgtemp_c'] = avgtempc;
    data['avgtemp_f'] = avgtempf;
    data['maxwind_mph'] = maxwindmph;
    data['maxwind_kph'] = maxwindkph;
    data['totalprecip_mm'] = totalprecipmm;
    data['totalprecip_in'] = totalprecipin;
    data['totalsnow_cm'] = totalsnowcm;
    data['avgvis_km'] = avgviskm;
    data['avgvis_miles'] = avgvismiles;
    data['avghumidity'] = avghumidity;
    data['daily_will_it_rain'] = dailywillitrain;
    data['daily_chance_of_rain'] = dailychanceofrain;
    data['daily_will_it_snow'] = dailywillitsnow;
    data['daily_chance_of_snow'] = dailychanceofsnow;
    data['condition'] = condition;
    data['uv'] = uv;
    return data;
  }
}
