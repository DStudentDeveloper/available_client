import 'package:available/src/block/domain/entities/block.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:equatable/equatable.dart';

class Room extends Equatable {
  const Room({
    required this.id,
    required this.code,
    required this.fullCode,
    required this.isAvailable,
    this.block,
    this.bookings,
  });

  const Room.empty()
      : id = 'Test String',
        block = null,
        code = 'Test String',
        fullCode = 'Test String',
        isAvailable = true,
        bookings = null;

  final String id;
  final Block? block;
  final String code;
  final String fullCode;
  final bool isAvailable;
  final List<Booking>? bookings;

  @override
  List<dynamic> get props => [
        id,
        block,
        code,
        fullCode,
        isAvailable,
        ...?bookings,
      ];
}
