import 'package:available/src/room/domain/entities/room.dart';
import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.representativeId,
    required this.startTime,
    required this.endTime,
    this.room,
    this.course,
    this.level,
  });

  Booking.empty()
      : id = 'Test String',
        representativeId = 'Test String',
        room = null,
        startTime = DateTime.now(),
        endTime = DateTime.now(),
        course = null,
        level = null;

  final String id;
  final String representativeId;
  final Room? room;
  final DateTime startTime;
  final DateTime endTime;
  final String? course;
  final String? level;

  @override
  List<dynamic> get props => [
        id,
        representativeId,
        room,
        startTime,
        endTime,
        course,
        level,
      ];
}
