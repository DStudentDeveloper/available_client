import 'package:available/core/res/colours.dart';
import 'package:available/src/booking/presentation/views/book_room_screen.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:available/src/room/presentation/widgets/room_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RoomConfirmationScreen extends StatelessWidget {
  const RoomConfirmationScreen(this.room, {super.key});

  final Room room;

  static const path = '/confirm-room';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text: 'Would you like to select ',
              children: [
                TextSpan(
                  text: 'Block ${room.fullCode}'.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' for your lecture?'),
              ],
            ),
            style: const TextStyle(color: Colours.primary, fontSize: 16),
          ),
          const Gap(30),
          RoomTile(room, receiveGestures: false),
          const Gap(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 41),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    BookRoomScreen.path,
                    arguments: room,
                  );
                },
                child: const Text('YES'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 41),
                ),
                onPressed: Navigator.of(context).pop,
                child: const Text('NO'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
