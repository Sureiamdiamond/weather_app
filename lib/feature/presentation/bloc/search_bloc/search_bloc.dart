import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/feature/domain/usecases/search_location.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_state.dart';

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  final SearchLocation searchLocation;
  Logger logger = Logger();

  LocationSearchBloc({required this.searchLocation}) : super(LocationEmpty()) {
    on<SearchLocations>(_onEvent);
  }

  FutureOr<void> _onEvent(
      SearchLocations event, Emitter<LocationSearchState> emit) async {
    emit(LocationLoading());

    try {
      final failureOrForecast =
          await searchLocation(SearchLocationParams(location: event.location));

      failureOrForecast.fold(
        (failure) {
          logger.e(
              "Search failed with error: ${_failureToMessage(failure)}"); // Логируем ошибку
          emit(LocationSearchError(message: _failureToMessage(failure)));
        },
        (location) {
          logger.i(
              "Search successful, locations found: ${location.length}"); // Логируем успешный поиск
          emit(LocationLoaded(locations: location));
        },
      );
    } catch (e) {
      logger
          .e("An unexpected error occurred: $e"); // Логируем неожиданную ошибку
      emit(const LocationSearchError(message: "An unexpected error occurred."));
    }
  }

  String _failureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server Failure';
      default:
        return '?? failure)';
    }
  }
}
