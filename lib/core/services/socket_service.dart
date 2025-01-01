import 'dart:convert';
import 'dart:developer';

import 'package:available/core/common/app/state/availability_controller.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:available/src/booking/data/models/booking_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  SocketService({
    required String url,
    required AvailabilityController availabilityController,
  })  : _channel = WebSocketChannel.connect(Uri.parse(url)),
        _availabilityController = availabilityController {
    log('Attempting to connect to socket server', name: 'SocketService');
    _channel.ready.then(
      (_) {
        log(
          'Connected to socket server',
          name: 'SocketService',
          time: DateTime.now(),
        );
      },
      onError: (Object error) {
        log(
          'Error connecting to socket server: $error',
          name: 'SocketService',
          time: DateTime.now(),
        );
      },
    );
    _channel.stream.listen((data) {
      final jsonData = jsonDecode(data as String) as DataMap;
      final event = jsonData['event'] as String?;
      if (event == 'bookingUpdate') {
        _availabilityController.updateRoomAvailabilityCache(
          roomId: jsonData['classId'] as String,
          updatedBookings: List<DataMap>.from(jsonData['bookings'] as List)
              .map(BookingModel.fromMap)
              .toList(),
        );
      } else if (event == 'subscribed') {
        log(
          'Subscribed to classes',
          name: 'SocketService',
          time: DateTime.now(),
        );
      } else if (event == 'unsubscribed') {
        log(
          'Unsubscribed from classes',
          name: 'SocketService',
          time: DateTime.now(),
        );
      }
    });
  }

  final WebSocketChannel _channel;
  final AvailabilityController _availabilityController;

  void subscribeToClasses() {
    _channel.sink.add(jsonEncode({'action': 'subscribe'}));
  }

  void unsubscribeFromClasses() {
    _channel.sink.add(jsonEncode({'action': 'unsubscribe'}));
  }

  void dispose() {
    unsubscribeFromClasses();
    _channel.stream.listen((_) {}).cancel();
    _channel.sink.close();
  }
}
