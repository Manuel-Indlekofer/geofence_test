import 'package:geofence_test/Models/DefaultGeofence.dart';
import 'package:geofencing/geofencing.dart';

class Config {
  static final List<GeofenceEvent> triggers = <GeofenceEvent>[
    GeofenceEvent.enter,
    GeofenceEvent.dwell,
    GeofenceEvent.exit
  ];

  static final AndroidGeofencingSettings androidSettings = AndroidGeofencingSettings(
      initialTrigger: <GeofenceEvent>[
        GeofenceEvent.enter,
        GeofenceEvent.exit,
        GeofenceEvent.dwell
      ],
      loiteringDelay: 1000 * 60);

  static final List<DefaultGeofence> defaultFenceList = [
    DefaultGeofence("Daheim", Location(49.135545072556376, 12.127724396391411)),
    DefaultGeofence("Franz-Schubert", Location(49.13570652249754, 12.125836121238226)),
    DefaultGeofence("Mozartstraße", Location(49.135513484454194, 12.12419460930765)),
    DefaultGeofence("Telemannstraße", Location(49.13667170144476, 12.123271929392828)),
  ];
}