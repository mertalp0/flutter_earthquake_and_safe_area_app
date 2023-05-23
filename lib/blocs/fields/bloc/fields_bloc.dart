import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import '../../../data/repository.dart';
import '../../../methods.dart';
import '../../../models/field_model.dart';

part 'fields_event.dart';
part 'fields_state.dart';

class FieldsBloc extends Bloc<FieldsEvent, FieldsState> {
    final FieldRepository fieldRepository = FieldRepository();
  FieldsBloc() : super(FieldsInitial()) {
    on<FieldsEvent>((event, emit) async {
      
      if (event is FetchFieldsEvent) {
          
        emit(FieldsLoadingState());

        try {
          
          final List<Field> fields = await fieldRepository.getField(event.lat,event.lon);
          emit(FieldLoadedState(fields: fields));
        } catch (e) {
          emit(FieldErrorState());
        }
      } else if (event is RefreshFieldsEvent) {
        emit(FieldsLoadingState());
        try {
          final List<Field> fields = await fieldRepository.getField(event.lat ,event.lon);
          

     




          emit(FieldLoadedState(fields: fields));
        } catch (_) {
          emit(state);
        
        }
      }
    });
  }
}
