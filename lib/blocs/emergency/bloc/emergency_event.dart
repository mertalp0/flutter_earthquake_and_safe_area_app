part of 'emergency_bloc.dart';

abstract class EmergencyEvent extends Equatable {
  const EmergencyEvent([List props = const []]);

  @override
  List<Object> get props => [];
}
class LoadPersonsEvent extends EmergencyEvent {}

class AddPersonEvent extends EmergencyEvent {
  final Contact selectedContact;

  AddPersonEvent({ required this.selectedContact}):super([selectedContact]);

  @override
  List<Object> get props => [selectedContact];
}

class DeletePersonEvent extends EmergencyEvent {
  final int personId;

  DeletePersonEvent({required this.personId});

  @override
  List<Object> get props => [personId];
}
