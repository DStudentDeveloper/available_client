import 'dart:async';

import 'package:available/core/common/app/state/user_provider.dart';
import 'package:available/core/common/widgets/shimmer_image.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/res/images.dart';
import 'package:available/core/utils/core_constants.dart';
import 'package:available/core/utils/core_utils.dart';
import 'package:available/src/booking/presentation/views/bookings_screen.dart';
import 'package:available/src/feedback/presentation/views/feedback_confirmed_screen.dart';
import 'package:available/src/feedback/presentation/views/leave_feedback_screen.dart';
import 'package:available/src/home/presentation/utils/home_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.instance.user!;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colours.primary),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerImage(
                    Images.user,
                    height: HomeConstants.avatarSize,
                    width: HomeConstants.avatarSize,
                  ),
                  const Gap(8),
                  Flexible(
                    child: Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book_online_outlined),
            title: const Text('My Bookings'),
            onTap: () {
              Navigator.of(context).pop();
              CoreConstants.nestedNavigatorKey.currentState!
                  .pushNamedAndRemoveUntil(
                BookingsScreen.path,
                (route) => route.settings.name != BookingsScreen.path,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Leave Feedback'),
            onTap: () {
              Navigator.of(context).pop();
              CoreConstants.nestedNavigatorKey.currentState!
                  .pushNamedAndRemoveUntil(
                LeaveFeedbackScreen.path,
                (route) =>
                    route.settings.name != LeaveFeedbackScreen.path &&
                    route.settings.name != FeedbackConfirmedScreen.path,
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colours.unavailable),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.of(context).pop();
              final result = await CoreUtils.showConfirmationDialog(
                context,
                title: 'Logout',
                message: 'Are you sure you want to logout?',
              );
              if (result) {
                await FirebaseAuth.instance.signOut();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  unawaited(
                    CoreConstants.rootNavigatorKey.currentState!
                        .pushNamedAndRemoveUntil(
                      '/',
                      (_) => false,
                    ),
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
