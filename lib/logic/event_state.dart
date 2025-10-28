import 'package:equatable/equatable.dart';
import 'package:test_project/data/models/event_model.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}
class EventLoading extends EventState {}
class ListEventSuccess extends EventState {
  final List<EventCoverModel> events;
  ListEventSuccess(this.events);

  @override
  List<Object?> get props => [events];
}
class SingleEventSuccess extends EventState {
  final EventDetailModel event;
  SingleEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}
class EventError extends EventState {
  final String message;
  EventError(this.message);

  @override
  List<Object?> get props => [message];
}