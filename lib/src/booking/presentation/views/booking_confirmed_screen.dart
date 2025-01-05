import 'package:available/core/common/widgets/shimmer_image.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/res/images.dart';
import 'package:available/src/room/domain/entities/room.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({
    required this.room,
    required this.startTime,
    required this.endTime,
    super.key,
  });

  final Room room;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  static const path = '/booking-confirmed';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SUCCESS!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colours.primary,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
            const Center(
              child: ShimmerImage(Images.check, width: 171, height: 171),
            ),
            const Gap(20),
            Text.rich(
              TextSpan(
                text: 'Block ${room.fullCode}'.toUpperCase(),
                children: [
                  const TextSpan(
                    text: ' BOOKED FOR LECTURE from ',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: '${startTime.format(context)} '
                            'to ${endTime.format(context)} today'
                        .toLowerCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                style: const TextStyle(color: Colours.primary, fontSize: 16),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colours.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
            const Text(
              'You will be notified when your time is up',
              style: TextStyle(
                color: Colours.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
