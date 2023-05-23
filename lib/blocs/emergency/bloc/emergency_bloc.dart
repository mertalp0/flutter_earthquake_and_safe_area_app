import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import '../../../database/emergency_repositroy.dart';
import '../../../models/directory_model.dart';

part 'emergency_event.dart';
part 'emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final EmergencyRepository emergencyRepository;
  EmergencyBloc(this.emergencyRepository) : super(EmergencyInitial()) {
    on<EmergencyEvent>((event, emit) async {
      if (event is LoadPersonsEvent) {
        try {
          emit(LoadingState());
          final persons = await emergencyRepository.getPersons();
          if (persons.isEmpty) {
            emit(EmptyState());
          } else {
            emit(LoadedState(persons: persons));
          }
        } catch (e) {
          emit(ErrorState());
        }
      }
      if (event is AddPersonEvent) {
        
        try {
          emit(LoadingState());
            final displayName = event.selectedContact.displayName;
    final phoneNumber = event.selectedContact.phones?.first.value;

    final exists = await emergencyRepository.isPersonExists(
        displayName!, phoneNumber!);
        if(exists){
          print("bu kişi zaten eklenmiş ");
              final persons = await emergencyRepository.getPersons();
          emit(LoadedState(persons: persons));}
          
          else{
            print("aaaaaaaaaaaaaaaaaaaaaaa oldu");
              await emergencyRepository.addPerson(event.selectedContact);
          final persons = await emergencyRepository.getPersons();
          emit(LoadedState(persons: persons));
          
        }
        } catch (e) {
          emit(ErrorState());
        }
      }
      if (event is DeletePersonEvent) {
        try {
           emit(LoadingState());
          await emergencyRepository.deletePerson(event.personId);
          final persons = await emergencyRepository.getPersons();
          emit(LoadedState(persons: persons));
        } catch (e) {
          emit(ErrorState());
        }
      }
    });
  }
}
