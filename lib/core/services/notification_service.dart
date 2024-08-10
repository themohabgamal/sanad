import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sanad/core/theme/my_colors.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('ic_launcher_monochrome');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> saveScheduledPrayerTime(
      DateTime prayerTime, String prayerName) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('scheduled_prayers') ?? [];

    final formattedTime = DateFormat('h:mm a').format(prayerTime);
    final notificationData = '$prayerName - $formattedTime';

    notifications.add(notificationData);
    await prefs.setStringList('scheduled_prayers', notifications);
  }

  Future<List<String>> getScheduledPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('scheduled_prayers') ?? [];
  }

  Future<void> schedulePrayerTimeNotifications() async {
    final cairoCoordinates = Coordinates(30.0444, 31.2357);
    final cairoParams = CalculationMethod.egyptian.getParameters();
    cairoParams.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(cairoCoordinates, cairoParams);

    final adjustedPrayerTimes = {
      'الفجر': prayerTimes.fajr,
      'الشروق': prayerTimes.sunrise,
      'الظهر': prayerTimes.dhuhr,
      'العصر': prayerTimes.asr,
      'المغرب': prayerTimes.maghrib,
      'العشاء': prayerTimes.isha,
    };

    for (final entry in adjustedPrayerTimes.entries) {
      final prayerName = entry.key;
      final prayerTime = entry.value;
      final notificationTime = prayerTime.subtract(const Duration(minutes: 15));

      if (notificationTime.isAfter(DateTime.now())) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          prayerName.hashCode,
          'صلاة $prayerName',
          'بعد 15 دقيقة',
          tz.TZDateTime.from(notificationTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_channel_id',
              'Prayer Time Alerts',
              channelDescription: 'Channel for prayer time notifications',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
              color: MyColors.primaryColor,
            ),
          ),
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  void backgroundTask() async {
    await schedulePrayerTimeNotifications();
  }
}
