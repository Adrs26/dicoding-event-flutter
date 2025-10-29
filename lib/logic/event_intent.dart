import 'package:equatable/equatable.dart';

abstract class EventIntent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUpcomingEvents extends EventIntent {}

class FetchFinishedEvents extends EventIntent {}

class FetchEventsByQuery extends EventIntent {
  final String query;

  FetchEventsByQuery(this.query);
}

class FetchDetailEvent extends EventIntent {
  final int id;

  FetchDetailEvent(this.id);
}
