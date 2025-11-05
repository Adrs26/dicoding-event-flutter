// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventEntityAdapter extends TypeAdapter<EventEntity> {
  @override
  final int typeId = 0;

  @override
  EventEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventEntity(
      id: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String,
      beginTime: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.beginTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
