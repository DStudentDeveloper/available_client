import 'package:available/src/room/domain/entities/room.dart';
import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.room,
    this.course,
    this.level,
  });

  Booking.empty()
      : id = 'Test String',
        room = null,
        startTime = DateTime.now(),
        endTime = DateTime.now(),
        course = null,
        level = null;

  final String id;
  final Room? room;
  final DateTime startTime;
  final DateTime endTime;
  final String? course;
  final String? level;

  @override
  List<dynamic> get props => [
        id,
        room,
        startTime,
        endTime,
        course,
        level,
      ];
}
