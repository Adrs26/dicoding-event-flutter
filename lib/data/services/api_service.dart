import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test_project/data/models/event_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://event-api.dicoding.dev'))
    ..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

  Future<List<EventCoverModel>> fetchEvents(int active) async {
    final response = await _dio.get(
      '/events',
      queryParameters: {'active': active},
    );
    return (response.data['listEvents'] as List)
        .map((e) => EventCoverModel.fromJson(e))
        .toList();
  }

  Future<List<EventCoverModel>> fetchEventsByQuery(String query) async {
    final response = await _dio.get(
      '/events',
      queryParameters: {
        'active': -1,
        'q': query
      },
    );
    return (response.data['listEvents'] as List)
        .map((e) => EventCoverModel.fromJson(e))
        .toList();
  }

  Future<EventDetailModel> fetchEventDetail(int id) async {
    final response = await _dio.get('/events/$id');
    return EventDetailModel.fromJson(response.data['event']);
  }
}
