import 'package:available/core/common/widgets/shimmer_image.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/res/images.dart';
import 'package:available/core/services/injection_container.dart';
import 'package:available/core/services/router.dart';
import 'package:available/core/utils/core_constants.dart';
import 'package:available/src/auth/domain/entities/course_representative.dart';
import 'package:available/src/block/presentation/app/adapter/block_cubit.dart';
import 'package:available/src/block/presentation/views/blocks_screen.dart';
import 'package:available/src/home/presentation/utils/home_constants.dart';
import 'package:available/src/home/presentation/widgets/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.user, super.key});

  final CourseRepresentative user;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = CoreConstants.nestedNavigatorKey.currentState!;
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          CoreConstants.rootNavigatorKey.currentState?.pop();
        }
      },
      child: Scaffold(
        body: Column(
          spacing: 30,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 12,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      color: Colours.primary,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const ShimmerImage(
                          Images.user,
                          height: HomeConstants.avatarSize,
                          width: HomeConstants.avatarSize,
                        ),
                        const Gap(10),
                        Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          '${user.courseName} ${user.levelName}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(2),
                        const Flexible(
                          child: Text(
                            'Course Rep',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SafeArea(
                    child: BackButton(
                      color: Colors.white,
                      onPressed: () {
                        final navigator =
                            CoreConstants.nestedNavigatorKey.currentState!;
                        if (navigator.canPop()) navigator.pop();
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Builder(
                    builder: (context) {
                      return SafeArea(
                        child: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Navigator(
                key: CoreConstants.nestedNavigatorKey,
                initialRoute: BlocksScreen.path,
                onGenerateInitialRoutes: (
                  NavigatorState navigator,
                  String initialRoute,
                ) {
                  return [
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => sl<BlockCubit>(),
                        child: const BlocksScreen(),
                      ),
                      settings: const RouteSettings(name: BlocksScreen.path),
                    ),
                  ];
                },
                onGenerateRoute: routerConfig,
              ),
            ),
          ],
        ),
        endDrawer: const HomeDrawer(),
      ),
    );
  }
}
