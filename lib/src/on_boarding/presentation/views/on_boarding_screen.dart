import 'dart:async';

import 'package:available/core/common/widgets/shimmer_image.dart';
import 'package:available/core/helpers/cache_helper.dart';
import 'package:available/core/res/colours.dart';
import 'package:available/core/res/images.dart';
import 'package:available/src/on_boarding/presentation/components/angle_clipper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: AngleClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .48,
                  color: Colours.primary,
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      final bottom = constraints.maxHeight * .27;
                      return Container(
                        margin: EdgeInsets.only(bottom: bottom),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: double.infinity,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ShimmerImage(Images.logo, width: 56, height: 64),
                            Gap(6),
                            Text(
                              'Welcome to',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                            Gap(2),
                            Text(
                              'CU Lecture Hall System',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ).copyWith(bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ShimmerImage(Images.lectureHall),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(275, 50),
                    ),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await CacheHelper.instance.cacheFirstTimer();
                      unawaited(navigator.pushReplacementNamed('/'));
                    },
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
