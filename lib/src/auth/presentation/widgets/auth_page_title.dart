import 'package:available/core/res/colours.dart';
import 'package:flutter/material.dart';

class AuthPageTitle extends StatelessWidget {
  const AuthPageTitle(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(
        fontSize: 27,
        color: Colours.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
