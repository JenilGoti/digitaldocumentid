import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationServises {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings _initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(_initializationSettings);
  }

  static void display(RemoteMessage message) async
  {
    try
    {
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("mychanel", "my chanal",
              importance: Importance.high, priority: Priority.max));
      print('abc');
      await _flutterLocalNotificationsPlugin.show(
          DateTime.now().microsecond,
          message.notification!.title,
          message.notification!.body,
          notificationDetails);
    } on Exception catch (e){
      print('error>>$e');
    }
  }

}