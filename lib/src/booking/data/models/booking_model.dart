import 'dart:convert';

import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/data/models/room_model.dart';
import 'package:available/src/room/domain/entities/room.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.startTime,
    required super.endTime,
    super.room,
    super.course,
    super.level,
  });

  BookingModel.empty()
      : this(
          id: 'Test String',
          room: null,
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          course: null,
          level: null,
        );

  factory BookingModel.fromJson(String source) =>
      BookingModel.fromMap(jsonDecode(source) as DataMap);

  factory BookingModel.fromMap(DataMap map) {
    final timeRange = map['timeRange'] as DataMap;
    return BookingModel(
      id: map['id'] as String,
      room: map['class'] != null
          ? RoomModel.fromMap(map['class'] as DataMap)
          : null,
      startTime: DateTime.parse(timeRange['start'] as String),
      endTime: DateTime.parse(timeRange['end'] as String),
      course: map['course'] as String?,
      level: map['level'] as String?,
    );
  }

  BookingModel copyWith({
    String? id,
    Room? room,
    DateTime? startTime,
    DateTime? endTime,
    String? course,
    String? level,
  }) {
    return BookingModel(
      id: id ?? this.id,
      room: room ?? this.room,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      course: course ?? this.course,
      level: level ?? this.level,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'class': (room as RoomModel?)?.toMap(),
      'timeRange': {
        'start': startTime.toIso8601String(),
        'end': endTime.toIso8601String(),
      },
      'course': course,
      'level': level,
    };
  }

  DataMap toRemoteMap() {
    return <String, dynamic>{
      'classId': room!.id,
      'timeRange': {
        'start': startTime.toIso8601String(),
        'end': endTime.toIso8601String(),
      },
      'course': course,
      'level': level,
    };
  }

  String toJson() => jsonEncode(toRemoteMap());
}
