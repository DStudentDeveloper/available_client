import 'package:flutter/widgets.dart';

sealed class CoreConstants {
  const CoreConstants();

  static const userTable = 'users';
  static const userPrimaryKey = 'studentEmail';
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final nestedNavigatorKey = GlobalKey<NavigatorState>();
}
