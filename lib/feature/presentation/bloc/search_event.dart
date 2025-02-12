import 'package:equatable/equatable.dart';

abstract class LocationSearchEvent extends Equatable {
  const LocationSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchLocations extends LocationSearchEvent {
  final String locationQuery;

  SearchLocations({required this.locationQuery});
}
