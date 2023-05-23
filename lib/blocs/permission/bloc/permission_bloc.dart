import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionInitial()) {
    on<PermissionEvent>((event, emit) async {
      double latitude = 0;
      double longitude = 0;

      if (event is PermissionCheckEvent) {
        emit(PermissionLoadingState());

        try {
          final status = await Geolocator.checkPermission();
          if (status == LocationPermission.denied) {
            await Geolocator.requestPermission();
            final status2 = await Geolocator.checkPermission();
            if (status2 == LocationPermission.denied) {
             emit(PermissionNotGrantedState());
            } else {
              try {
                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                latitude = position.latitude;
                longitude = position.longitude;
                emit(PermissionGrantedState(
                    latitude: latitude, longitude: longitude));
              } catch (e) {
                emit(PermissonErrorState());
              }
            }
          } else {
            try {
              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
              latitude = position.latitude;
              longitude = position.longitude;
              emit(PermissionGrantedState(
                  latitude: latitude, longitude: longitude));
            } catch (e) {
              emit(PermissonErrorState());
            }
          }
        } catch (e) {
          emit(PermissonErrorState());
        }
      }
    });
  }
}
