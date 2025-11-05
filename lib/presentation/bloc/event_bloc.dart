import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:test_project/data/local/event_entity.dart';
import 'package:test_project/data/models/event_model.dart';
import 'package:test_project/data/repositories/event_repository.dart';
import 'package:test_project/presentation/bloc/event_intent.dart';
import 'package:test_project/presentation/bloc/event_state.dart';
import 'package:test_project/utils/formatter.dart';

class UpcomingEventsBloc extends Bloc<EventIntent, EventState> {
  final EventRepository repository;

  bool _isLoaded = false;

  UpcomingEventsBloc(this.repository) : super(InitialState()) {
    on<FetchUpcomingEvents>((event, emit) async {
      if (!_isLoaded) {
        emit(LoadingState());
        try {
          List<EventCoverModel> events = await repository.getEvents(1);
          emit(SuccessState.list(events));
          _isLoaded = true;
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
    });
  }
}

class FinishedEventsBloc extends Bloc<EventIntent, EventState> {
  final EventRepository repository;

  bool _isLoaded = false;

  FinishedEventsBloc(this.repository) : super(InitialState()) {
    on<FetchFinishedEvents>((event, emit) async {
      if (!_isLoaded) {
        emit(LoadingState());
        try {
          List<EventCoverModel> events = await repository.getEvents(0);
          emit(SuccessState.list(events));
          _isLoaded = true;
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
    });
  }
}

class EventsByQueryBloc extends Bloc<EventIntent, EventState> {
  final EventRepository repository;

  EventsByQueryBloc(this.repository) : super(InitialState()) {
    on<FetchEventsByQuery>((event, emit) async {
      emit(LoadingState());
      try {
        List<EventCoverModel> events = await repository.getEventsByQuery(
          event.query,
        );
        emit(SuccessState.list(events));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
  }
}

class DetailEventBloc extends Bloc<EventIntent, EventState> {
  final EventRepository repository;
  final Box<EventEntity> eventBox;

  bool _isLoaded = false;

  DetailEventBloc(this.repository, this.eventBox) : super(InitialState()) {
    on<FetchDetailEvent>((event, emit) async {
      if (!_isLoaded) {
        emit(LoadingState());
        try {
          final eventFavorite = eventBox.values.firstWhere(
            (u) => u.id == event.id,
            orElse: () =>
                EventEntity(id: 0, name: '', image: '', beginTime: ''),
          );
          final eventDetail = await repository.getEventDetail(event.id);
          final eventDetailBloc = EventDetailBlocModel.fromEventDetailModel(
            eventDetail,
            eventFavorite.id != 0,
          );

          emit(SuccessState.single(eventDetailBloc));
          _isLoaded = true;
        } catch (e) {
          emit(ErrorState(e.toString()));
        }
      }
    });

    on<HandleFavoriteEvent>((event, emit) async {
      final eventFavorite = eventBox.values.firstWhere(
            (u) => u.id == event.event.id,
        orElse: () => EventEntity(id: 0, name: '', image: '', beginTime: ''),
      );

      if (eventFavorite.id == 0) {
        await eventBox.add(event.event);
      } else {
        final keyToDelete = eventBox.keys.firstWhere(
              (k) => eventBox.get(k)?.id == eventFavorite.id,
          orElse: () => null,
        );
        await eventBox.delete(keyToDelete);
      }
    });
  }
}

class EventDetailBlocModel {
  final int id;
  final String imageLogo;
  final String mediaCover;
  final String name;
  final String ownerName;
  final String category;
  final String beginTime;
  final String formattedDate;
  final String cityName;
  final String remainingQuota;
  final String description;
  final String link;
  final bool isFavorite;

  EventDetailBlocModel({
    required this.id,
    required this.imageLogo,
    required this.mediaCover,
    required this.name,
    required this.ownerName,
    required this.category,
    required this.beginTime,
    required this.formattedDate,
    required this.cityName,
    required this.remainingQuota,
    required this.description,
    required this.link,
    required this.isFavorite,
  });

  factory EventDetailBlocModel.fromEventDetailModel(
    EventDetailModel event,
    bool isFavorite,
  ) {
    return EventDetailBlocModel(
      id: event.id,
      imageLogo: event.imageLogo,
      mediaCover: event.mediaCover,
      name: event.name,
      ownerName: event.ownerName,
      category: event.category,
      beginTime: event.beginTime,
      formattedDate: Formatter.dateToReadable(event.beginTime),
      cityName: event.cityName,
      remainingQuota: (event.quota - event.registrants).toString(),
      description: event.description,
      link: event.link,
      isFavorite: isFavorite,
    );
  }
}

class FavoriteEventsBloc extends Bloc<EventIntent, EventState> {
  final Box<EventEntity> eventBox;

  FavoriteEventsBloc(this.eventBox) : super(InitialState()) {
    on<GetAllFavoriteEvents>((event, emit) {
      List<EventEntity> events = eventBox.values.toList();
      emit(SuccessState.list(events));
    });
  }
}
