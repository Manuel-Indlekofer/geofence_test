import 'package:geofencing/geofencing.dart';
import 'package:collection/collection.dart';

class GeofenceTriggerEvent {
  List<String> ids;
  DateTime timestamp;
  Location geolocation;
  GeofenceEvent event;

  GeofenceTriggerEvent(this.ids, this.timestamp, this.geolocation, this.event);

  GeofenceTriggerEvent.fromMap(Map map) {
    this.ids = map["ids"].cast<String>();
    this.timestamp = DateTime.parse(map["timestamp"]);
    this.geolocation = Location(map["lat"], map["long"]);
    this.event = enumFromString(map["event"], GeofenceEvent.values);
  }

  Map toMap() => {
    "ids": ids,
    "timestamp": timestamp.toIso8601String(),
    "geolocation": {
      "lat": geolocation.latitude,
      "long": geolocation.longitude,
    },
    "event": enumToString(event),
  };

  @override
  String toString() {
    return "Trigger for: " + ids.toString() + " Event: " + event.toString();
  }

  String enumToString(Object o) => o.toString().split('.').last;

  T enumFromString<T>(String key, List<T> values) => values.firstWhereOrNull((v) => key == enumToString(v));
}