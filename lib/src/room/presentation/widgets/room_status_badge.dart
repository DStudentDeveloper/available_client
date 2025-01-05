import 'package:available/core/common/app/state/availability_controller.dart';
import 'package:available/core/res/colours.dart';
import 'package:flutter/material.dart';

class RoomStatusBadge extends StatelessWidget {
  const RoomStatusBadge({
    required this.roomId,
    required this.availabilityController,
    super.key,
  });

  final String roomId;
  final AvailabilityController availabilityController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      builder: (context, snapshot) {
        final currentTime = snapshot.data ?? DateTime.now();
        final minuteOfDay = currentTime.hour * 60 + currentTime.minute;
        final isAvailable = availabilityController.availabilityCache[roomId]
                ?[minuteOfDay] ??
            true;

        return ColoredBox(
          color: isAvailable ? Colours.available : Colours.unavailable,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Center(
              child: Text(
                isAvailable ? 'Available' : 'Unavailable',
                style: const TextStyle(
                  color: Colours.availabilityText,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
