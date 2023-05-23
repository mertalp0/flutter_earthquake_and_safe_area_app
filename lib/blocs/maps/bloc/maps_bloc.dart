import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/repository.dart';
import '../../../models/earthquake_model.dart';

part 'maps_event.dart';
part 'maps_state.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  final EarthquakeRepository earthquakeRepository = EarthquakeRepository();
  MapsBloc() : super(MapsInitial()) {
    on<MapsEvent>((event, emit) async {
      if (event is GetFieldsMapsEvent) {
        try {
          emit(MapsLoadingState());

          emit(MapsLoadedState(
              list: event.fieldList,
              location: event.location,
              type: event.type));
        } catch (e) {
          emit(MapsErrorState());
        }
      }

      if (event is GetEarthquakeMapsEvent) {
        try {
          emit(MapsLoadingState());
           final List<Earthquake> earthquakeList =
              await earthquakeRepository.getEarthquake();
          emit(MapsLoadedState(
              list: earthquakeList,
              location: event.centerLocation,
              type: event.type));
        } catch (e) {
          emit(MapsErrorState());
        }
      }
    });
  }
}
