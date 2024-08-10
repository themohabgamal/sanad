import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sanad/core/theme/my_colors.dart';
import 'package:sanad/main.dart';
import 'package:timezone/timezone.dart' as tz;

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  @override
  void initState() {
    super.initState();
    _schedulePrayerNotifications();
  }

  Future<void> _schedulePrayerNotifications() async {
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

    final now = DateTime.now();
    DateTime? nextPrayerTime;
    String? nextPrayerName;

    for (final entry in adjustedPrayerTimes.entries) {
      if (entry.value.isAfter(now)) {
        nextPrayerTime = entry.value;
        nextPrayerName = entry.key;
        break;
      }
    }

    if (nextPrayerTime == null) {
      return; // No more prayers today
    }

    final notificationTime =
        nextPrayerTime.subtract(const Duration(minutes: 15));
    await _showNotification(
        nextPrayerName, _formatTime(nextPrayerTime), notificationTime);
  }

  Future<void> _showNotification(
      String? prayerName, String prayerTime, DateTime scheduledTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'prayer_channel_id',
      'Prayer Reminders',
      channelDescription: 'Notification channel for prayer reminders',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'أستعد للصلاة',
      'صلاة $prayerName بعد 15 دقيقة',
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  Widget _buildPrayerTimeContainer(String label, DateTime time) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: MyColors.secondaryColor,
              fontSize: 14.0,
              fontFamily: "Cairo",
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.watch_later_outlined,
                color: Colors.white,
                size: 14.0,
              ),
              const SizedBox(width: 4.0),
              Text(
                _formatTime(time),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final now = DateTime.now();
    DateTime? nextPrayerTime;
    String? nextPrayerName;

    for (final entry in adjustedPrayerTimes.entries) {
      if (entry.value.isAfter(now)) {
        nextPrayerTime = entry.value;
        nextPrayerName = entry.key;
        break;
      }
    }

    if (nextPrayerTime == null) {
      nextPrayerTime = DateTime.now();
      nextPrayerName = 'No more prayers today';
    }

    return Scaffold(
      backgroundColor: MyColors.primaryHeavyColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryHeavyColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: MyColors.primaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/mosque.png',
                  width: 100,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'الصلاة القادمة',
                      style: TextStyle(
                        fontFamily: "Cairo",
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      nextPrayerName!,
                      style: const TextStyle(
                        color: MyColors.secondaryColor,
                        fontFamily: "Cairo",
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.watch_later_outlined,
                          color: Colors.white,
                          size: 14.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          _formatTime(nextPrayerTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Cairo",
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 7 / 6,
              ),
              itemCount: adjustedPrayerTimes.length,
              itemBuilder: (context, index) {
                final key = adjustedPrayerTimes.keys.elementAt(index);
                final time = adjustedPrayerTimes[key]!;
                return _buildPrayerTimeContainer(key, time);
              },
            ),
          ),
        ],
      ),
    );
  }
}
