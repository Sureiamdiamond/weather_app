import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/feature/domain/usecases/search_location.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_state.dart';

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  final SearchLocation searchLocation;

  LocationSearchBloc({required this.searchLocation}) : super(LocationEmpty()) {
    on<SearchLocations>(_onEvent);
  }

  FutureOr<void> _onEvent(
      SearchLocations event, Emitter<LocationSearchState> emit) async {
    emit(LocationLoading());

    final failureOrForecast =
        await searchLocation(SearchLocationParams(location: event.location));
    emit(failureOrForecast.fold(
        (failure) => LocationSearchError(message: _failureToMessage(failure)),
        (location) => LocationLoaded(locations: location)));
  }

  String _failureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      default:
        return '?? failure)';
    }
  }
}
