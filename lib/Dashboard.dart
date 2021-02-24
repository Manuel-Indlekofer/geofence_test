import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geofence_test/GeofenceSetPage.dart';
import 'package:geofencing/geofencing.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Wrap(
      children: [
        RaisedButton(
            onPressed: () async {
              _handleGeofenceSetResult(await Navigator.push<GeoFenceSetResult>(
                  context,
                  MaterialPageRoute(builder: (_) => GeofenceSetPage())));
            },
            child: Text("Setup geofences"))
      ],
    )));
  }

  void _handleGeofenceSetResult(GeoFenceSetResult result) {
    if (result == null || result is! GeoFenceSetResult) {
      print("Got no result!");
    }
    GeofencingManager.registerGeofence(
        GeofenceRegion(DateTime.now().toString(), result.latitude,
            result.longitude, result.radius, [
          GeofenceEvent.enter,
        ]),
        handleGeofenceEvent);
  }
}

void handleGeofenceEvent(
    List<String> id, Location geolocation, GeofenceEvent event) {
  print("GEOLOCATION EVENT ENTRY");
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('092342345', 'Geolocation Channel',
          'Used to notify about location changes',
          importance: Importance.max, priority: Priority.high, showWhen: false);
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  FlutterLocalNotificationsPlugin()
      .show(0, 'Geofence', 'Geofence triggered!', platformChannelSpecifics);
}
