import 'package:available/core/common/app/state/availability_controller.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/services/injection_container.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:available/src/room/presentation/views/room_confirmation_screen.dart';
import 'package:available/src/room/presentation/widgets/room_status_badge.dart';
import 'package:flutter/material.dart';

class RoomTile extends StatelessWidget {
  const RoomTile(this.room, {this.receiveGestures = true, super.key});

  final Room room;
  final bool receiveGestures;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: room.id,
      child: GestureDetector(
        onTap: receiveGestures
            ? () {
                Navigator.of(context).pushNamed(
                  RoomConfirmationScreen.path,
                  arguments: room,
                );
              }
            : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black45),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ).copyWith(bottom: 12),
                child: Row(
                  spacing: 40,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.meeting_room_outlined,
                      color: Colors.black,
                    ),
                    Text(
                      room.fullCode.toUpperCase(),
                      style: const TextStyle(
                        color: Colours.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -9,
              left: 0,
              right: 0,
              child: RoomStatusBadge(
                roomId: room.id,
                availabilityController: sl<AvailabilityController>(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
