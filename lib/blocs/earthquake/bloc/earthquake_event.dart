part of 'earthquake_bloc.dart';

abstract class EarthquakeEvent extends Equatable {
  const EarthquakeEvent();

  @override
  List<Object> get props => [];
}
class FetchEarthquakeEvent extends EarthquakeEvent {
  final String filter ;

  FetchEarthquakeEvent( { required this.filter}); 
}

class RefreshEarthquakeEvent extends EarthquakeEvent {
    final String filter ;

  RefreshEarthquakeEvent({ required this.filter});
    
}


