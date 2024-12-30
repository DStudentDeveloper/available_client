import 'dart:convert';

import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/room/data/models/room_model.dart';
import 'package:available/src/room/domain/entities/room.dart';

class BlockModel extends Block {
  const BlockModel({
    required super.id,
    required super.code,
    super.rooms,
  });

  const BlockModel.empty()
      : this(
          id: 'Test String',
          code: 'Test String',
          rooms: null,
        );

  BlockModel.fromJson(String source)
      : this.fromMap(jsonDecode(source) as DataMap);

  BlockModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          code: map['code'] as String,
          rooms: map['classes'] != null
              ? List<DataMap>.from(map['classes'] as List<dynamic>)
                  .map<Room>(RoomModel.fromMap)
                  .toList()
              : null,
        );

  BlockModel copyWith({
    String? id,
    String? code,
    List<Room>? rooms,
  }) {
    return BlockModel(
      id: id ?? this.id,
      code: code ?? this.code,
      rooms: rooms ?? this.rooms,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'classes': rooms
          ?.map<DataMap>(
            (room) => (room as RoomModel).toMap(),
          )
          .toList(),
    };
  }

  String toJson() => jsonEncode(toMap());
}
