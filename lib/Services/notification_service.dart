import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifs = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidChannel = AndroidNotificationDetails(
    'daily_channel_id',
    'Recordatorios diarios',
    channelDescription: 'Avisos a horas determinadas',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const NotificationDetails _platformDetails = NotificationDetails(
    android: _androidChannel,
  );

  Future<void> init() async {
    tz.initializeTimeZones();
   
    final androidInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidInit);
    await _notifs.initialize(initSettings);

    await _notifs.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
    await _notifs.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestExactAlarmsPermission();
  }

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));
    return scheduled;
  }

  Future<void> scheduleDaily(
    int id, {
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _notifs.zonedSchedule(
      id,
      title,
      body,
      _nextInstance(hour, minute),
      _platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleMultipleDaily(List<(int,int)> hhmm, {String title = 'Recordatorio'}) async {
    var id = 100;
    for (final (h, m) in hhmm) {
      await scheduleDaily(
        id++,
        hour: h,
        minute: m,
        title: title,
        body: 'Aviso de las ${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}',
      );
    }
  }

  Future<void> cancelOne(int id) => _notifs.cancel(id);
  Future<void> cancelAll() => _notifs.cancelAll();
}