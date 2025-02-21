import 'package:equatable/equatable.dart';
import 'package:test_app/feature/domain/entities/search_location_entity.dart';

abstract class LocationSearchState extends Equatable {
  const LocationSearchState();

  @override
  List<Object> get props => [];
}

class LocationEmpty extends LocationSearchState {}

class LocationLoading extends LocationSearchState {}

class LocationLoaded extends LocationSearchState {
  final List<SearchLocationEntity> locations;

  LocationLoaded({required this.locations});

  @override
  List<Object> get props => [locations];
}

class LocationSearchError extends LocationSearchState {
  final String message;

  LocationSearchError({required this.message});

  @override
  List<Object> get props => [message];
}
