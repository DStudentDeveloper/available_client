import 'dart:async';
import 'dart:isolate';

import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/domain/entities/room.dart';

/// A sealed class that provides methods to preprocess room availability data.
sealed class AvailabilityWorker {
  /// Preprocesses the availability data for a list of rooms.
  ///
  /// [rooms] - The list of rooms to preprocess.
  /// Returns a map where the key is the room ID and the value is a map
  /// of availability status for each minute of the day.
  static Future<Map<String, Map<int, bool>>> preprocess(
    List<Room> rooms,
  ) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_worker, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;

    final responsePort = ReceivePort();
    sendPort.send([rooms, responsePort.sendPort]);

    return await responsePort.first as Map<String, Map<int, bool>>;
  }

  /// Worker function to process room availability in an isolate.
  ///
  /// [sendPort] - The port to send data back to the main isolate.
  static Future<void> _worker(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      final rooms = (message as List)[0] as List<Room>;
      final responsePort = message[1] as SendPort;

      final result = <String, Map<int, bool>>{};

      for (final roomInfo in rooms) {
        final roomCache = <int, bool>{};
        for (var minute = 0; minute < 1440; minute++) {
          final time = DateTime.now()
              .copyWith(hour: 0, minute: 0)
              .add(Duration(minutes: minute));
          roomCache[minute] = _isAvailableAt(roomInfo.bookings ?? [], time);
        }
        result[roomInfo.id] = roomCache;
      }

      responsePort.send(result);
    }
  }

  /// Checks if a room is available at a specific time.
  ///
  /// [bookings] - The list of bookings for the room.
  /// [time] - The time to check availability for.
  /// Returns true if the room is available, false otherwise.
  static bool _isAvailableAt(List<Booking> bookings, DateTime time) {
    for (final booking in bookings) {
      if (time.isAfter(booking.startTime) && time.isBefore(booking.endTime)) {
        return false;
      }
    }
    return true;
  }

  /// Preprocesses the availability data for a single room.
  ///
  /// [bookings] - The list of bookings for the room.
  /// Returns a map of availability status for each minute of the day.
  static Future<Map<int, bool>> preprocessRoom(List<Booking> bookings) async {
    if (bookings.length > 50) {
      // Use an isolate for large data
      return _preprocessRoomInIsolate(bookings);
    } else {
      // Process directly on the main thread for smaller data
      return _preprocessRoomOnMain(bookings);
    }
  }

  /// Preprocesses the availability data for a single room on the main thread.
  ///
  /// [bookings] - The list of bookings for the room.
  /// Returns a map of availability status for each minute of the day.
  static Future<Map<int, bool>> _preprocessRoomOnMain(
    List<Booking> bookings,
  ) async {
    final result = <int, bool>{};
    for (var minute = 0; minute < 1440; minute++) {
      final time = DateTime.now()
          .copyWith(hour: 0, minute: 0)
          .add(Duration(minutes: minute));
      result[minute] = _isAvailableAt(bookings, time);
    }
    return result;
  }

  /// Preprocesses the availability data for a single room in an isolate.
  ///
  /// [bookings] - The list of bookings for the room.
  /// Returns a map of availability status for each minute of the day.
  static Future<Map<int, bool>> _preprocessRoomInIsolate(
    List<Booking> bookings,
  ) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_workerRoom, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;

    final responsePort = ReceivePort();
    sendPort.send([bookings, responsePort.sendPort]);

    return await responsePort.first as Map<int, bool>;
  }

  /// Worker function to process room availability in an isolate.
  ///
  /// [sendPort] - The port to send data back to the main isolate.
  static Future<void> _workerRoom(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      final room = (message as List)[0] as List<Booking>;
      final responsePort = message[1] as SendPort;

      final result = <int, bool>{};

      for (var minute = 0; minute < 1440; minute++) {
        final time = DateTime.now()
            .copyWith(hour: 0, minute: 0)
            .add(Duration(minutes: minute));
        result[minute] = _isAvailableAt(room, time);
      }

      responsePort.send(result);
    }
  }
}
