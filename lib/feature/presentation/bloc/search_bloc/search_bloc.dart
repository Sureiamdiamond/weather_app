import 'package:bloc/bloc.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/feature/domain/usecases/search_location.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_state.dart';

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  final SearchLocation searchLocation;

  LocationSearchBloc({required this.searchLocation}) : super(LocationEmpty());

  Stream<LocationSearchState> mapEventToState(
      LocationSearchEvent event) async* {
    if (event is SearchLocations) {
      yield* _mapLocationsToState(event.locationQuery);
    }
  }

  Stream<LocationSearchState> _mapLocationsToState(
      String locationQuery) async* {
    yield LocationLoading();

    final failureOrLocation =
        await searchLocation(SearchLocationParams(location: locationQuery));
    yield failureOrLocation.fold(
        (failure) => LocationSearchError(message: _failureToMessage(failure)),
        (location) => LocationLoaded(locations: location));
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
