import 'package:equatable/equatable.dart';

import '../data/models/event_model.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}
class EventLoading extends EventState {}
class EventSuccess extends EventState {
  final List<EventCoverModel> events;
  EventSuccess(this.events);

  @override
  List<Object?> get props => [events];
}
class EventError extends EventState {
  final String message;
  EventError(this.message);

  @override
  List<Object?> get props => [message];
}