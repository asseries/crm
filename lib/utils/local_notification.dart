import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notiPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initialSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/notif',
      ),
    );
    _notiPlugin.initialize(initialSettings, onDidReceiveNotificationResponse: (NotificationResponse details) {
      if (kDebugMode) {
        print('onDidReceiveNotificationResponse Function');
        print(details.payload);
        print(details.payload != null);
      }
    });
  }

  static void showNotification(String title, String body,bool? single,) {
    const NotificationDetails notiDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'uz.asser.push_notification',
        'push_notification',
        importance: Importance.max,
        priority: Priority.high,
        playSound: false
      ),
    );
    _notiPlugin.show(
      single==true?888:
      DateTime.now().microsecond,
      title,
      body,
      notiDetails,
      payload: "AAAAA",
    );
  }
}
