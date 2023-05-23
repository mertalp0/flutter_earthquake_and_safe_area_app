// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'fields_bloc.dart';

abstract class FieldsEvent extends Equatable {
  const FieldsEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class FetchFieldsEvent extends FieldsEvent {
  double lat;
  double lon ; 
  FetchFieldsEvent({
    required this.lat,
    required this.lon,
  }) : super([lat,lon]);
 
}
class RefreshFieldsEvent extends FieldsEvent{

  double lat;
  double lon ; 
  RefreshFieldsEvent({
    required this.lat,
    required this.lon,
  }) : super([lat,lon]);
}
