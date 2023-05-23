
import 'package:equatable/equatable.dart';

import '../../../models/field_model.dart';

abstract class DirectionsEvent extends Equatable {
  const DirectionsEvent();

  @override
  List<Object?> get props => [];
}

class GetDirections extends DirectionsEvent {
  final Field field;

  const GetDirections(this.field);

  @override
  List<Object?> get props => [field];
}
