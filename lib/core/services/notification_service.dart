import 'dart:convert';

import 'package:available/core/utils/core_constants.dart';
import 'package:available/src/booking/data/models/booking_model.dart';
import 'package:available/src/booking/presentation/views/bookings_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationService {
  NotificationService() {
    init();
  }

  final _notificationDispatcher = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_name');
    const initializationSettingsDarwin = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    final androidImplementation =
        _notificationDispatcher.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!;
    final permissionGranted =
        await androidImplementation.requestNotificationsPermission();
    final schedulePermissionGranted =
        await androidImplementation.requestExactAlarmsPermission();

    if ((permissionGranted ?? false) && (schedulePermissionGranted ?? false)) {
      await _notificationDispatcher.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );
      await _initTimeZone();
    }
  }

  Future<void> _initTimeZone() async {
    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    setLocalLocation(getLocation(currentTimeZone));
  }

  Future<void> _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    return CoreConstants.nestedNavigatorKey.currentState!.pushNamed<void>(
      BookingsScreen.path,
      arguments: notificationResponse.payload,
    );
  }

  int _generateNotificationId(BookingModel booking) {
    final bookingJson = booking.toJson();

    // SHA-256 hash
    final bytes = utf8.encode(bookingJson);
    final digest = sha256.convert(bytes);

    // Take the first 8 bytes of the hash and convert it to an integer
    final hashValue = digest.bytes.sublist(0, 8);
    // return hashValue.fold(0, (total, byte) => total * 256 + byte);

    // Might as well use 32-bit prime to avoid android int constraints
    return hashValue.fold(0, (total, byte) => total * 256 + byte) % 2147483647;
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'co.available.app_notifications',
        'Bookings',
        channelDescription: 'Notifications for bookings',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showNotification() async {
    final androidImplementation =
        _notificationDispatcher.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation == null) return;

    final canProceed = await androidImplementation.areNotificationsEnabled();

    if (canProceed ?? false) {
      final platformChannelSpecifics = _notificationDetails();
      await _notificationDispatcher.show(
        0,
        'Booking Confirmed',
        'You will receive a notification before the class ends.',
        platformChannelSpecifics,
      );
    }
  }

  Future<void> scheduleNotification(BookingModel booking) async {
    final androidImplementation =
        _notificationDispatcher.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation == null) {
      return;
    }
    final canProceed =
        await androidImplementation.canScheduleExactNotifications();
    if (canProceed ?? false) {
      final notificationTime = booking.endTime.subtract(
        const Duration(minutes: 5),
      );

      final timeFromTZ = TZDateTime.from(notificationTime, local);
      if (timeFromTZ.isBefore(
        TZDateTime.now(local).add(const Duration(minutes: 1)),
      )) {
        return;
      }
      final platformChannelSpecifics = _notificationDetails();

      await _notificationDispatcher.zonedSchedule(
        _generateNotificationId(booking),
        'Class Ending Soon',
        'Your class is about to end. Which means your booking is about to end.',
        timeFromTZ,
        platformChannelSpecifics,
        payload: booking.toJson(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelNotification(BookingModel booking) async {
    await _notificationDispatcher.cancel(_generateNotificationId(booking));
  }

  Future<void> editNotification(BookingModel booking) async {
    await cancelNotification(booking);
    await scheduleNotification(booking);
  }
}
