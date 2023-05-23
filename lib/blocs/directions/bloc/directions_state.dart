import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DirectionsState extends Equatable {
  const DirectionsState();

  @override
  List<Object?> get props => [];
}

class DirectionsInitial extends DirectionsState {}

class DirectionsLoading extends DirectionsState {}

class DirectionsLoaded extends DirectionsState {
  final Position currentPosition;
  final List<Marker> markers;
  final List<Circle> circles;
  final List<Polyline> polylines;
  final LatLng destination;

  const DirectionsLoaded({
    required this.currentPosition,
    required this.markers,
    required this.circles,
    required this.polylines,
    required this.destination,
  });

  @override
  List<Object?> get props => [currentPosition, markers, circles, polylines];
}

class DirectionsError extends DirectionsState {
  final String error;

  const DirectionsError({required this.error});

  @override
  List<Object?> get props => [error];
}
