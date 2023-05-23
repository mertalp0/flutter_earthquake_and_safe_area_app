part of 'maps_bloc.dart';

abstract class MapsEvent extends Equatable {
  const MapsEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class GetEarthquakeMapsEvent extends MapsEvent {

final LatLng  centerLocation = const LatLng(39.925533, 32.866287);
final String type = "GetEarthquakeMapsEvent" ; 
  GetEarthquakeMapsEvent() :super([]); 
}
class GetFieldsMapsEvent extends MapsEvent{
final List fieldList ; 
final LatLng  location ;
final String type = "GetFieldsMapsEvent" ; 

  GetFieldsMapsEvent({required this.fieldList,required  this.location}):super([fieldList,location]); 


}
