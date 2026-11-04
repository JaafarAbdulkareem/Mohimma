import 'dart:typed_data';
import 'dart:ui' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Schedules the alarm with Android's AlarmManager, so it rings with sound
/// even if the app is in the background or has been closed.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  // Android keeps a channel's sound forever once created, so if you ever change
  // the sound file, change this id too.
  static const _channelId = 'task_alarm_v1';
  static const _channelName = 'تنبيهات المهام';
  static const _channelDesc = 'منبه يعمل عند انتهاء وقت المهمة';
  static const _sound = RawResourceAndroidNotificationSound('alarm');
  // White-on-transparent vector in android/app/src/main/res/drawable.
  static const _statusIcon = 'ic_stat_alarm';
  static const _accent = Color(0xFF673AB7);

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  Future<void> init() async {
    tzdata.initializeTimeZones();

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(_statusIcon),
      ),
    );

    await _android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDesc,
        importance: Importance.max,
        playSound: true,
        sound: _sound,
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
    );
  }

  Future<void> requestPermissions() async {
    final android = _android;
    if (android == null) return;
    await android.requestNotificationsPermission();
    final canExact = await android.canScheduleExactNotifications() ?? true;
    if (!canExact) {
      await android.requestExactAlarmsPermission();
    }
    await android.requestFullScreenIntentPermission();
  }

  NotificationDetails _details() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        fullScreenIntent: true,
        playSound: true,
        sound: _sound,
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        icon: _statusIcon,
        // largeIcon: const DrawableResourceAndroidBitmap('ic_notification_large'),
        color: _accent,
        autoCancel: true,
        // 4 = FLAG_INSISTENT: the sound keeps repeating until the user taps
        // or dismisses the notification.
        additionalFlags: Int32List.fromList(<int>[4]),
      ),
    );
  }

  /// Schedules (or replaces) the alarm for task [id] at [when].
  Future<void> scheduleAlarm({
    required int id,
    required String taskTitle,
    required DateTime when,
  }) async {
    if (!when.isAfter(DateTime.now())) return;
    // Only the absolute moment matters for a one-shot alarm, so UTC is fine.
    final date = tz.TZDateTime.fromMillisecondsSinceEpoch(
      tz.UTC,
      when.millisecondsSinceEpoch,
    );

    Future<void> schedule(AndroidScheduleMode mode) {
      return _plugin.zonedSchedule(
        id,
        'انتهى الوقت ⏰',
        taskTitle,
        date,
        _details(),
        androidScheduleMode: mode,
      );
    }

    try {
      await schedule(AndroidScheduleMode.exactAllowWhileIdle);
    } catch (_) {
      // Exact alarms not permitted: fall back to the closest allowed mode.
      await schedule(AndroidScheduleMode.inexactAllowWhileIdle);
    }
  }

  Future<void> cancel(int id) => _plugin.cancel(id);

  /// Stops any alarm that is currently ringing / showing.
  Future<void> dismissShown() async {
    final active = await _android?.getActiveNotifications() ?? [];
    for (final n in active) {
      final id = n.id;
      if (id != null) await _plugin.cancel(id);
    }
  }
}
