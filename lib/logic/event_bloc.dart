import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/data/models/event_model.dart';
import 'package:test_project/data/repositories/event_repository.dart';
import 'package:test_project/logic/event_intent.dart';
import 'package:test_project/logic/event_state.dart';

class UpcomingEventsBloc extends Bloc<EventIntent, EventState> {
  final EventRepository repository;

  bool _isLoaded = false;

  UpcomingEventsBloc(this.repository) : super(EventInitial()) {
    on<FetchUpcomingEvents>((event, emit) async {
      if (!_isLoaded) {
        emit(EventLoading());
        try {
          List<EventCoverModel> events = await repository.getEvents(1);
          emit(ListEventSuccess(events));
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
          emit(ListEventSuccess(events));
          _isLoaded = true;
        } catch (e) {
          emit(EventError(e.toString()));
        }
      }
    });
  }
}

class DetailEventBloc extends Bloc<EventIntent, EventState> {
  final EventRepository repository;
  final int eventId;

  bool _isLoaded = false;

  DetailEventBloc(this.repository, this.eventId) : super(EventInitial()) {
    on<FetchDetailEvent>((event, emit) async {
      if (!_isLoaded) {
        emit(EventLoading());
        try {
          EventDetailModel event = await repository.getEventDetail(eventId);
          emit(SingleEventSuccess(event));
          _isLoaded = true;
        } catch (e) {
          emit(EventError(e.toString()));
        }
      }
    });
  }
}