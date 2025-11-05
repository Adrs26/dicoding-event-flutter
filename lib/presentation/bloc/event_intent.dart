import 'package:equatable/equatable.dart';
import 'package:test_project/data/local/event_entity.dart';

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

class GetAllFavoriteEvents extends EventIntent {}

class HandleFavoriteEvent extends EventIntent {
  final EventEntity event;

  HandleFavoriteEvent(this.event);
}
