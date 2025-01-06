import 'package:available/core/helpers/availability_worker.dart';
import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/data/models/room_model.dart';
import 'package:available/src/room/domain/entities/room.dart';

/// A controller class to manage the availability of rooms.
class AvailabilityController {
  /// A cache to store the availability status of rooms.
  ///
  /// The key is the room ID, and the value is a map where the key is the
  /// minute and the value is a boolean indicating availability.
  Map<String, Map<int, bool>> availabilityCache = {};

  /// A map to store room information.
  ///
  /// The key is the room ID, and the value is the [Room] object.
  Map<String, Room> _roomMap = {};

  /// Getter for the room map.
  Map<String, Room> get roomMap => _roomMap;

  /// Caches the availability status for a list of rooms.
  ///
  /// [rooms] - The list of rooms to cache availability for.
  Future<void> cacheAvailabilityForRooms(List<Room> rooms) async {
    _roomMap = {for (final room in rooms) room.id: room};
    availabilityCache = await AvailabilityWorker.preprocess(rooms);
  }

  /// Updates the availability cache for a specific room.
  ///
  /// [roomId] - The ID of the room to update.
  ///
  /// [updatedBookings] - The list of updated bookings for the room.
  ///
  /// [room] - The room object. If provided will create a new room entry if it
  /// doesn't exist.
  ///
  /// [create] - A flag indicating whether to create a new cache entry if it
  /// doesn't exist.
  Future<void> updateRoomAvailabilityCache({
    required String roomId,
    required List<Booking> updatedBookings,
    Room? room,
    bool create = false,
  }) async {
    if (create) {
      availabilityCache[roomId] = await AvailabilityWorker.preprocessRoom(
        updatedBookings,
      );
    } else if (availabilityCache.containsKey(roomId)) {
      availabilityCache[roomId] = await AvailabilityWorker.preprocessRoom(
        updatedBookings,
      );
    }

    if (_roomMap.containsKey(roomId)) {
      _roomMap[roomId] = (_roomMap[roomId]! as RoomModel).copyWith(
        bookings: updatedBookings,
      );
    } else if (room != null) {
      _roomMap[roomId] = room;
    }
  }
}
