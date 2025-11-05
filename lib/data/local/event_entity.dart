import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'event_entity.g.dart';

@HiveType(typeId: 0)
class EventEntity extends HiveObject with EquatableMixin {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String beginTime;

  EventEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.beginTime
  });

  @override
  List<Object?> get props => [id, name, image, beginTime];
}