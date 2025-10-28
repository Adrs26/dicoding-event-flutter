import 'package:get_it/get_it.dart';

import '../data/repositories/event_repository.dart';
import '../data/services/api_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(
    () => EventRepository(apiService: locator<ApiService>()),
  );
}
