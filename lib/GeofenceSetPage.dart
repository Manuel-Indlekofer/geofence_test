import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

class GeofenceSetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GeofenceSetPage();
  }
}

class _GeofenceSetPage extends State<GeofenceSetPage> {
  LatLng position;

  int radius = 1;

  List<Marker> markers = [];

  MapOptions options;

  @override
  void initState() {
    options = MapOptions(
      plugins: [UserLocationPlugin()],
      center: LatLng(49.0160, 12.1051),
      onTap: (latlng) {
        setState(() {
          position = latlng;
          markers = [
            Marker(
                width: 25,
                height: 25,
                point: latlng,
                builder: (_) => Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                    ))
          ];
        });
      },
      zoom: 13.0,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Geofence Setup")),
        body: Column(children: [
          Text("Tap to add new Geofence zone"),
          Row(children: [
            Slider(
                min: 1.0,
                max: 100.0,
                value: radius.toDouble(),
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    radius = value.toInt();
                  });
                }),
            Text("$radius Meter")
          ]),
          Expanded(
              child: FlutterMap(
            options: options,
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(markers: markers),
            ],
          )),
          MaterialButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    GeoFenceSetResult(position.latitude, position.longitude,
                        radius.toDouble()));
              },
              child: Text("Confirm"))
        ]));
  }
}

class GeoFenceSetResult {
  final double latitude;
  final double longitude;
  final double radius;

  GeoFenceSetResult(this.latitude, this.longitude, this.radius);
}
