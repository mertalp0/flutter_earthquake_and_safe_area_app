// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'permission_bloc.dart';

abstract class PermissionState extends Equatable {
  const PermissionState([List props = const []]);

  @override
  List<Object> get props => [];
}

class PermissionInitial extends PermissionState {}

class  PermissionGrantedState extends PermissionState {
  double latitude;
  double longitude;
  PermissionGrantedState({
    required this.latitude,
    required this.longitude,
  }) : super([latitude, longitude]);
}

class PermissionNotGrantedState extends PermissionState {}
class PermissonErrorState extends PermissionState{}
class PermissionLoadingState extends PermissionState{}
