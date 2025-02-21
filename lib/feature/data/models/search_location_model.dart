import 'package:test_app/feature/domain/entities/search_location_entity.dart';

class SearchLocationModel extends SearchLocationEntity {
  SearchLocationModel({name, region, country, lat, lon, url})
      : super(
          name: name,
          region: region,
          country: country,
          lat: lat,
          lon: lon,
          url: url,
        );

  factory SearchLocationModel.fromJson(Map<String, dynamic> json) {
    return SearchLocationModel(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['region'] = region;
    data['country'] = country;
    data['lat'] = lat;
    data['lon'] = lon;
    data['url'] = url;
    return data;
  }
}
