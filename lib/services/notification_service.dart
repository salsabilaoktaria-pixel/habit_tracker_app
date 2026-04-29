import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart'; 
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    
    try {
      dynamic timezoneResult = await FlutterTimezone.getLocalTimezone();
      String timeZoneName;
      
      if (timezoneResult is String) {
        timeZoneName = timezoneResult;
      } else {
        timeZoneName = timezoneResult.toString();
      }

      if (timeZoneName.contains('TimezoneInfo') || timeZoneName.isEmpty) {
        timeZoneName = 'Asia/Jakarta';
      }
      
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint("Timezone berhasil disetel ke: $timeZoneName");
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      debugPrint("Gagal deteksi, menggunakan default: $e");
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    try {
      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint("Notifikasi diklik: ${details.payload}");
        },
      );

      // Minta izin notifikasi (hanya untuk memunculkan pesan, bukan alarm presisi)
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
          
      debugPrint("Notification Service Berhasil Diinisialisasi");
    } catch (e) {
      debugPrint("Gagal Inisialisasi Notifikasi: $e");
    }
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    
    try {
      tz.local;
    } catch (e) {
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    }

    var now = DateTime.now();
    var scheduledDateTime = DateTime(
      now.year, now.month, now.day, scheduledDate.hour, scheduledDate.minute,
    );

    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_tracker_channel',
            'Habit Reminders',
            channelDescription: 'Pengingat untuk habit harian kamu',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        // --- PERBAIKAN KRUSIAL ---
        // Gunakan inexact agar tidak memicu pengecekan izin 'Exact Alarm' di Android 13/14
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, 
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, 
      );
      debugPrint("BERHASIL: Notifikasi dijadwalkan (Mode Inexact)");
    } catch (e) {
      debugPrint("Gagal menjadwalkan: $e");
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    debugPrint("Semua notifikasi dibatalkan");
  }
}