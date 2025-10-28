import 'package:test_project/data/models/event_model.dart';
import 'package:test_project/data/services/api_service.dart';

class EventRepository {
  final ApiService apiService;

  EventRepository({required this.apiService});

  Future<List<EventCoverModel>> getEvents(int active) async {
    return await apiService.fetchEvents(active);
  }

  Future<EventDetailModel> getEventDetail(int id) async {
    return await apiService.fetchEventDetail(id);
  }
}
