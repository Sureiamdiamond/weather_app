import 'package:test_app/feature/domain/entities/astro_entity.dart';

class AstroModel extends AstroEntity {
  AstroModel(
      {sunrise,
      sunset,
      moonrise,
      moonset,
      moonphase,
      moonillumination,
      ismoonup,
      issunup})
      : super(
          sunrise: sunrise,
          sunset: sunset,
          moonrise: moonrise,
          moonset: moonset,
          moonphase: moonphase,
          moonillumination: moonillumination,
          ismoonup: ismoonup,
          issunup: issunup,
        );

  AstroModel.fromJson(Map<String, dynamic> json) {
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    moonrise = json['moonrise'];
    moonset = json['moonset'];
    moonphase = json['moon_phase'];
    moonillumination = json['moon_illumination'];
    ismoonup = json['is_moon_up'];
    issunup = json['is_sun_up'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['moonrise'] = moonrise;
    data['moonset'] = moonset;
    data['moon_phase'] = moonphase;
    data['moon_illumination'] = moonillumination;
    data['is_moon_up'] = ismoonup;
    data['is_sun_up'] = issunup;
    return data;
  }
}
