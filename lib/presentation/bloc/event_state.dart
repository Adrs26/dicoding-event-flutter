import 'package:equatable/equatable.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends EventState {}

class LoadingState extends EventState {}

class SuccessState<T> extends EventState {
  final T? item;
  final List<T>? items;

  SuccessState._({this.item, this.items});

  factory SuccessState.single(T item) => SuccessState._(item: item);
  factory SuccessState.list(List<T> items) => SuccessState._(items: items);

  @override
  List<Object?> get props => [item, items];
}

class ErrorState extends EventState {
  final String message;

  ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
