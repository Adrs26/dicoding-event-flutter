import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:test_project/data/local/event_entity.dart';
import 'package:test_project/data/repositories/event_repository.dart';
import 'package:test_project/data/services/api_service.dart';
import 'package:test_project/presentation/bloc/event_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => ApiService());

  var eventBox = await Hive.openBox<EventEntity>('event');
  locator.registerLazySingleton(() => eventBox);

  locator.registerLazySingleton(
    () => EventRepository(apiService: locator<ApiService>()),
  );
  locator.registerFactory(() => UpcomingEventsBloc(locator<EventRepository>()));
  locator.registerFactory(() => FinishedEventsBloc(locator<EventRepository>()));
  locator.registerFactory(() => EventsByQueryBloc(locator<EventRepository>()));
  locator.registerFactory(
    () => DetailEventBloc(
      locator<EventRepository>(),
      locator<Box<EventEntity>>(),
    ),
  );
  locator.registerFactory(() => FavoriteEventsBloc(locator<Box<EventEntity>>()));
}
