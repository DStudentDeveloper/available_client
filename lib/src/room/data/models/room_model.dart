import 'dart:convert';

import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/block/data/models/block_model.dart';
import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/booking/data/models/booking_model.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/domain/entities/room.dart';

class RoomModel extends Room {
  const RoomModel({
    required super.id,
    required super.code,
    required super.fullCode,
    required super.isAvailable,
    super.block,
    super.bookings,
  });

  const RoomModel.empty()
      : this(
          id: 'Test String',
          block: null,
          code: 'Test String',
          fullCode: 'Test String',
          isAvailable: true,
          bookings: null,
        );

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(jsonDecode(source) as DataMap);

  RoomModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          block: map['block'] != null
              ? BlockModel.fromMap(map['block'] as DataMap)
              : null,
          code: map['code'] as String,
          fullCode: map['fullCode'] as String,
          isAvailable: map['isAvailable'] as bool,
          bookings: map['bookings'] != null
              ? List<DataMap>.from(map['bookings'] as List<dynamic>)
                  .map(BookingModel.fromMap)
                  .toList()
              : null,
        );

  RoomModel copyWith({
    String? id,
    Block? block,
    String? code,
    String? fullCode,
    bool? isAvailable,
    List<Booking>? bookings,
  }) {
    return RoomModel(
      id: id ?? this.id,
      block: block ?? this.block,
      code: code ?? this.code,
      fullCode: fullCode ?? this.fullCode,
      isAvailable: isAvailable ?? this.isAvailable,
      bookings: bookings ?? this.bookings,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'block': (block as BlockModel?)?.toMap(),
      'code': code,
      'fullCode': fullCode,
      'isAvailable': isAvailable,
      'bookings': bookings?.map((booking) => (booking as BookingModel).toMap()),
    };
  }

  String toJson() => jsonEncode(toMap());
}
