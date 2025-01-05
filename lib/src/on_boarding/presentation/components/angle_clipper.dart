import 'package:flutter/widgets.dart';

class AngleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Calculate the curve starting and ending points
    final curveStartHeight = size.height * (5.5 / 7.5); // 0.733
    final bottomHeight = size.height;

    // Start at the top-left corner
    path
      ..moveTo(0, 0)
      ..lineTo(0, curveStartHeight)

      // // Draw a straight line to the curve's starting height at the right edge
      // path.lineTo(size.width, curveStartHeight);

      // The outward curve
      ..quadraticBezierTo(
        size.width * 0.5, // Control point at the center horizontally
        bottomHeight, // Control point at the bottom vertically
        size.width, // End point back to the bottom-left corner
        curveStartHeight,
      )
      ..lineTo(size.width, 0)

      // Close the path back to the starting point
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
