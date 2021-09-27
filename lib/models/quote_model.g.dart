// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteModelAdapter extends TypeAdapter<QuoteModel> {
  @override
  final int typeId = 0;

  @override
  QuoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuoteModel(
      author: fields[0] as String,
      id: fields[1] as int,
      quote: fields[2] as String,
      permalink: fields[3] as String,
    )..isLiked = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, QuoteModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.quote)
      ..writeByte(3)
      ..write(obj.permalink)
      ..writeByte(4)
      ..write(obj.isLiked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
