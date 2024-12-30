import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/domain/entities/room.dart';

abstract class RoomRepo {
  ResultFuture<List<Room>> getAllRooms();

  ResultFuture<List<Booking>> getRoomBookings(String roomId);

  ResultFuture<Room> getRoomById(String roomId);
}
