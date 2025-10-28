import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/data/models/event_model.dart';

import '../data/repositories/event_repository.dart';
import 'event_intent.dart';
import 'event_state.dart';

class UpcomingEventsBloc extends Bloc<EventIntent, EventState> {
  final EventRepository repository;

  bool _isLoaded = false;

  UpcomingEventsBloc(this.repository) : super(EventInitial()) {
    on<FetchUpcomingEvents>((event, emit) async {
      if (!_isLoaded) {
        emit(EventLoading());
        try {
          List<EventCoverModel> events = await repository.getEvents(1);
          emit(EventSuccess(events));
          _isLoaded = true;
        } catch (e) {
          emit(EventError(e.toString()));
        }
      }
    });
  }
}

class FinishedEventsBloc extends Bloc<EventIntent, EventState> {
  final EventRepository repository;

  bool _isLoaded = false;

  FinishedEventsBloc(this.repository) : super(EventInitial()) {
    on<FetchFinishedEvents>((event, emit) async {
      if (!_isLoaded) {
        emit(EventLoading());
        try {
          List<EventCoverModel> events = await repository.getEvents(0);
          emit(EventSuccess(events));
          _isLoaded = true;
        } catch (e) {
          emit(EventError(e.toString()));
        }
      }
    });
  }
}