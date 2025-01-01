import 'dart:developer';

import 'package:available/core/common/app/state/availability_controller.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/data/models/booking_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  SocketService({
    required String url,
    required AvailabilityController availabilityController,
  })  : _socket = io(url, OptionBuilder().setTransports(['websocket']).build()),
        _availabilityController = availabilityController {
    log('Attempting to connect to socket server', name: 'SocketService');

    _socket
      ..on('connect', (_) {
        log('Connected to socket server', name: 'SocketService');
        subscribeToClasses();
      })
      ..onDisconnect((_) {
        log('Disconnected from socket server', name: 'SocketService');
      })
      ..on('subscribed', (_) {
        log('Subscribed to classes', name: 'SocketService');
      })
      ..on('unsubscribed', (_) {
        log('Unsubscribed from classes', name: 'SocketService');
      })
      ..on('bookingUpdate', (data) {
        data as DataMap;
        log(data.toString(), name: 'SocketService');
        _availabilityController.updateRoomAvailabilityCache(
          roomId: data['classId'] as String,
          updatedBookings: List<DataMap>.from(data['bookings'] as List)
              .map(BookingModel.fromMap)
              .toList(),
        );
      });
  }

  final Socket _socket;
  final AvailabilityController _availabilityController;

  void subscribeToClasses() {
    _socket.emit('subscribe');
  }

  void unsubscribeFromClasses() {
    _socket.emit('unsubscribe');
  }

  void dispose() {
    unsubscribeFromClasses();
    _socket.dispose();
  }
}
