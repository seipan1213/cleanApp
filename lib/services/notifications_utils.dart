import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsUtils {
  // 通知をスケジュール
  static Future<void> scheduleNotifications(int id, DateTime dateTime,
      {DateTimeComponents? dateTimeComponents}) async {
    final Map<int, String?> cleanSpotList = <int, String?>{
      1: '風呂',
      2: 'リビング',
      3: 'トイレ',
    };

    // 日時をTimeZoneを考慮した日時に変換する
    final scheduleTime = tz.TZDateTime.from(dateTime, tz.local);

    // 通知をスケジュールする
    final flnp = FlutterLocalNotificationsPlugin();
    await flnp.zonedSchedule(
      id,
      '${cleanSpotList[id]}掃除通知',
      '${cleanSpotList[id]}を掃除する時間になりました',
      scheduleTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '1',
          '掃除通知',
          channelDescription: '設定した時刻に通知されます',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: IOSNotificationDetails(
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: dateTimeComponents,
    );
  }

  // 通知をキャンセル
  static Future<void> cancelNotificationsSchedule(int id) async {
    final flnp = FlutterLocalNotificationsPlugin();
    await flnp.cancel(id);
  }
}
