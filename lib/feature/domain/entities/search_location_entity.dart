import 'package:flutter/material.dart';

class SearchLocationEntity {
  int? id;
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? url;

  SearchLocationEntity(
      {this.id,
      this.name,
      this.region,
      this.country,
      this.lat,
      this.lon,
      this.url});
}
