import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geofence_test/Models/GeofenceEvent.dart';

class NotificationHelper {
  static void handleGeofenceEvent(GeofenceTriggerEvent event) {
    WidgetsFlutterBinding.ensureInitialized();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings).then((value) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
          '092342345', 'Geolocation Channel', 'Used to notify about location changes',
          importance: Importance.max, priority: Priority.high, showWhen: false);
      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      flutterLocalNotificationsPlugin.show(0, 'Geofence', event.toString(), platformChannelSpecifics);
    });

    print("GEOLOCATION EVENT ENTRY");
  }
}