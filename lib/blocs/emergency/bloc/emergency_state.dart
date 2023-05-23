part of 'emergency_bloc.dart';


abstract class EmergencyState extends Equatable {
  const EmergencyState();

  @override
  List<Object> get props => [];
}

class EmergencyInitial extends EmergencyState {}

class LoadingState extends EmergencyState {}
class EmptyState extends EmergencyState{}


class LoadedState extends EmergencyState {
  final List<Directory> persons;

  LoadedState({required this.persons});

  @override
  List<Object> get props => [persons];
}
class ErrorState extends EmergencyState {}