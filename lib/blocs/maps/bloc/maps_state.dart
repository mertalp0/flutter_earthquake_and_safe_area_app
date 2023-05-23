part of 'maps_bloc.dart';

abstract class MapsState extends Equatable {
  const MapsState([List props = const []]);

  @override
  List<Object> get props => [];
}

class MapsInitial extends MapsState {}

class MapsLoadingState extends MapsState {}

class MapsLoadedState extends MapsState {
  final List list;
  final LatLng location;
  final String type ; 
  MapsLoadedState({required this.list, required this.location ,required this.type})
      : super([list, location]);
}


class MapsErrorState extends MapsState {}
