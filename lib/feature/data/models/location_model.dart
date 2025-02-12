import 'package:test_app/feature/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel(
      {name, region, country, lat, lon, tzid, localtimeepoch, localtime})
      : super(
          name: name,
          region: region,
          country: country,
          lat: lat,
          lon: lon,
          tzid: tzid,
          localtimeepoch: localtimeepoch,
          localtime: localtime,
        );

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
        name: json['name'],
        region: json['region'],
        country: json['country'],
        lat: json['lat'],
        lon: json['lon'],
        tzid: json['tz_id'],
        localtimeepoch: json['localtime_epoch'],
        localtime: json['localtime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['region'] = region;
    data['country'] = country;
    data['lat'] = lat;
    data['lon'] = lon;
    data['tz_id'] = tzid;
    data['localtime_epoch'] = localtimeepoch;
    data['localtime'] = localtime;
    return data;
  }
}
