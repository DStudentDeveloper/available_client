import 'package:available/core/common/widgets/shimmer_image.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/res/images.dart';
import 'package:available/src/feedback/domain/entities/feedback.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:gap/gap.dart';

class FeedbackConfirmedScreen extends StatelessWidget {
  const FeedbackConfirmedScreen({required this.feedback, super.key});

  final Feedback feedback;

  static const path = '/feedback-confirmed';

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SUCCESS!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colours.primary,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(20),
            Center(
              child: ShimmerImage(Images.check, width: 171, height: 171),
            ),
            Gap(20),
            Text(
              'Your feedback has been submitted successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colours.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(20),
            Text(
              'We appreciate your feedback!',
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
