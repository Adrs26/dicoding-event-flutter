import 'package:equatable/equatable.dart';

abstract class EventIntent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUpcomingEvents extends EventIntent {}
class FetchFinishedEvents extends EventIntent {}
class FetchDetailEvent extends EventIntent {}