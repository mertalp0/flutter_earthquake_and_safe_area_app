part of 'earthquake_bloc.dart';

abstract class EarthquakeState extends Equatable {
  const EarthquakeState([List props = const []]);

  @override
  List<Object> get props => [];
}

class EarthquakeInitial extends EarthquakeState {}

class EarthquakeLoadingState extends EarthquakeState {}

class EarthquakeLoadedState extends EarthquakeState {
  final List<Earthquake> earthquakes;
  final String filter;
  EarthquakeLoadedState({required this.earthquakes,required this.filter}) : super([earthquakes]);
}

class EarthquakesErrorState extends EarthquakeState {}
