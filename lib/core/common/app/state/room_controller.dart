import 'package:available/core/helpers/availability_worker.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/data/models/room_model.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:flutter/foundation.dart';

class RoomController {
  Map<String, Map<int, bool>> availabilityCache = {};
  final Map<String, ValueNotifier<Room>> activeRooms = {};

  Future<void> initializeRooms(List<Room> rooms) async {
    activeRooms.clear();
    for (final room in rooms) {
      activeRooms[room.id] = ValueNotifier<Room>(room);
    }
    availabilityCache = await AvailabilityWorker.preprocess(rooms);
  }

  Future<void> updateRoom({
    required String roomId,
    required List<Booking> updatedBookings,
  }) async {
    if (activeRooms.containsKey(roomId)) {
      activeRooms[roomId]!.value =
          (activeRooms[roomId]!.value as RoomModel).copyWith(
        bookings: updatedBookings,
      );
      availabilityCache[roomId] = await AvailabilityWorker.preprocessRoom(
        activeRooms[roomId]!.value,
      );
    }
  }
}
