import 'dart:async';
import 'dart:isolate';

import 'package:available/src/booking/domain/entities/booking.dart';
import 'package:available/src/room/domain/entities/room.dart';

sealed class AvailabilityWorker {
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

  static Future<void> _worker(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      final rooms = message[0] as List<Room>;
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

  static bool _isAvailableAt(List<Booking> bookings, DateTime time) {
    for (final booking in bookings) {
      if (time.isAfter(booking.startTime) && time.isBefore(booking.endTime)) {
        return false;
      }
    }
    return true;
  }

  static Future<Map<int, bool>> preprocessRoom(List<Booking> bookings) async {
    if (bookings.length > 50) {
      // Use an isolate for large data
      return _preprocessRoomInIsolate(bookings);
    } else {
      // Process directly on the main thread for smaller data
      return _preprocessRoomOnMain(bookings);
    }
  }

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

  static Future<void> _workerRoom(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      final room = message[0] as List<Booking>;
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
