import 'package:flutter/material.dart';
import 'package:geofence_test/Models/GeofenceEvent.dart';

import 'EventDatabase.dart';

class GeofenceTriggerEventsPage extends StatefulWidget {
  @override
  _GeofenceTriggerEventsPageState createState() => _GeofenceTriggerEventsPageState();
}

class _GeofenceTriggerEventsPageState extends State<GeofenceTriggerEventsPage> {
  List<GeofenceTriggerEvent> _events = [];

  @override
  void initState() {
    _loadGeofenceTriggerEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geofence Events"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _getEventWidgets(),
            ),
          ),
          ElevatedButton(onPressed: _deleteAllEvents, child: Text("Alle Löschen")),
        ],
      ),
    );
  }

  List<Widget> _getEventWidgets() {
    return _events.map((e) => ListTile(
      title: Text(e.ids.toString()),
      subtitle: Text(_formatTimestamp(e) + " Event: " + e.event.toString()),
    )).toList();
  }

  void _loadGeofenceTriggerEvents() {
    EventDatabase.getAllEvents().then((events) => setState(() {
      _events = events;
    }));
  }

  String _formatTimestamp(GeofenceTriggerEvent e) {
    return e.timestamp.hour.toString() + ":" + e.timestamp.minute.toString() + ":" + e.timestamp.second.toString();
  }

  void _deleteAllEvents() async {
    await EventDatabase.clearAllEvents();
    _loadGeofenceTriggerEvents();
  }
}
