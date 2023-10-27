// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StateModelAdapter extends TypeAdapter<StateModel> {
  @override
  final int typeId = 0;

  @override
  StateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StateModel(
      state: fields[0] as String,
      date: fields[1] as int,
      phone: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StateModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.state)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
