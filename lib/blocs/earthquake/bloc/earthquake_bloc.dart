import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import '../../../data/repository.dart';
import '../../../../models/earthquake_model.dart';

part 'earthquake_event.dart';
part 'earthquake_state.dart';

class EarthquakeBloc extends Bloc<EarthquakeEvent, EarthquakeState> {
  final EarthquakeRepository earthquakeRepository = EarthquakeRepository();
  EarthquakeBloc() : super(EarthquakeInitial()) {
    on<EarthquakeEvent>((event, emit) async {
      if (event is FetchEarthquakeEvent) {
        emit(EarthquakeLoadingState());

        try {
          final List<Earthquake> earthquakes =
              await earthquakeRepository.getEarthquake();
          emit(EarthquakeLoadedState(earthquakes: earthquakes,filter: event.filter));
        } catch (e) {
          emit(EarthquakesErrorState());
          print(e.toString());
        }
      } else if (event is RefreshEarthquakeEvent) {
        try {
          emit(EarthquakeLoadingState());
          final List<Earthquake> earthquakes =
              await earthquakeRepository.getEarthquake();
          emit(EarthquakeLoadedState(earthquakes: earthquakes,filter: event.filter));
        } catch (_) {
          emit(state);
        }
      }
    });
  }
}
