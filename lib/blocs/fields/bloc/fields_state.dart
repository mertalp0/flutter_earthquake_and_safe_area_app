part of 'fields_bloc.dart';

abstract class FieldsState extends Equatable {
  const FieldsState([List props = const []]);

  @override
  List<Object> get props => [];
}

class FieldsInitial extends FieldsState {}

class FieldsLoadingState extends FieldsState {}
class FieldLoadedState extends FieldsState {
  final List<Field> fields;
  FieldLoadedState({required this.fields}) : super([fields]);
}

class FieldErrorState extends FieldsState {}
