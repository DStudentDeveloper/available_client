import 'package:flutter/material.dart';

enum SnackBarType {
  success(colour: Color(0xFF4CAF50), icon: Icons.check_circle),
  error(colour: Color(0xFFF44336), icon: Icons.error),
  warning(colour: Color(0xFFFFCC00), icon: Icons.warning),
  info(colour: Color(0xFF2196F3), icon: Icons.info),
  ;

  const SnackBarType({required this.colour, required this.icon});

  final Color colour;
  final IconData icon;
}
