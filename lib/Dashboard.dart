import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geofence_test/Config.dart';
import 'package:geofence_test/EventDatabase.dart';
import 'package:geofence_test/GeofenceSetPage.dart';
import 'package:geofence_test/GeofenceTriggerEventsPage.dart';
import 'package:geofence_test/Models/DefaultGeofence.dart';
import 'package:geofence_test/Models/GeofenceEvent.dart';
import 'package:geofence_test/NotificationHelper.dart';
import 'package:geofencing/geofencing.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<String> _registeredGeofences = [];
  int _radius = 15;

  @override
  void initState() {
    _updateGeofenceList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geofence Test"),
      ),
      body: Column(
        children: [
          RaisedButton(
              onPressed: () async {
                _handleGeofenceSetResult(
                    await Navigator.push<GeoFenceSetResult>(context, MaterialPageRoute(builder: (_) => GeofenceSetPage())));
              },
              child: Text("Setup geofences")),
          RaisedButton(
            onPressed: _sendTestEvent,
            child: Text("Test Geofence Event"),
          ),
          RaisedButton(
            onPressed: _setDefaultGeofences,
            child: Text("Set default Geofences"),
          ),
          Row(children: [
            Slider(
                min: 1.0,
                max: 100.0,
                value: _radius.toDouble(),
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    _radius = value.toInt();
                  });
                }),
            Text("$_radius Meter")
          ]),
          RaisedButton(
            onPressed: _removeAllGeofences,
            child: Text("Remove all Geofences"),
          ),
          RaisedButton(
            onPressed: _showAllEventsPage,
            child: Text("Show all Events"),
          ),
          Expanded(
            child: ListView(
              children: _getGeofenceWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getGeofenceWidgets() {
    return _registeredGeofences.map((g) {
      return ListTile(
        title: Text(g),
        trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => _removeGeofence(g)),
      );
    }).toList();
  }

  void _handleGeofenceSetResult(GeoFenceSetResult result) {
    if (result == null || result is! GeoFenceSetResult) {
      print("Got no result!");
      return;
    }
    _registerGeofence(result);
  }

  void _registerGeofence(GeoFenceSetResult geoFenceSetResult) async {
    GeofenceRegion fenceRegion = GeofenceRegion(
      DateTime.now().toString(),
      geoFenceSetResult.latitude,
      geoFenceSetResult.longitude,
      geoFenceSetResult.radius,
      Config.triggers,
      androidSettings: Config.androidSettings,
    );

    await GeofencingManager.registerGeofence(fenceRegion, _handleGeofenceEvent);

    _updateGeofenceList();
  }

  void _sendTestEvent() {
    _handleGeofenceEvent(["Zuhause"], Location(100.0, 100.0), GeofenceEvent.enter);
  }

  void _updateGeofenceList() {
    GeofencingManager.getRegisteredGeofenceIds().then((fences) => setState(() {
      _registeredGeofences = fences;
    }));
  }

  void _setDefaultGeofences() async {
    for (DefaultGeofence geofence in Config.defaultFenceList) {
      await GeofencingManager.registerGeofence(_getGeofenceRegion(geofence), _handleGeofenceEvent);
    }

    _updateGeofenceList();
  }

  GeofenceRegion _getGeofenceRegion(DefaultGeofence geofence) {
    return GeofenceRegion(
      geofence.id,
      geofence.location.latitude,
      geofence.location.longitude,
      _radius.toDouble(),
      Config.triggers,
      androidSettings: Config.androidSettings,
    );
  }

  void _removeGeofence(String id) async {
    await GeofencingManager.removeGeofenceById(id);
    _updateGeofenceList();
  }

  void _removeAllGeofences() async {
    for (String geofenceId in _registeredGeofences) {
      await GeofencingManager.removeGeofenceById(geofenceId);
    }
    _updateGeofenceList();
  }

  void _showAllEventsPage() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => GeofenceTriggerEventsPage()));
  }
}

void _handleGeofenceEvent (List<String> id, Location geolocation, GeofenceEvent event) {
  print("event");
  final geofenceTriggerEvent = GeofenceTriggerEvent(id, DateTime.now(), geolocation, event);
  NotificationHelper.handleGeofenceEvent(geofenceTriggerEvent);
  EventDatabase.addEvent(geofenceTriggerEvent);
}


