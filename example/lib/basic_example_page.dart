import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'drawer.dart';
import 'example_popup.dart';

class BasicExamplePage extends StatelessWidget {
  static const route = 'basicExamplePage';

  const BasicExamplePage({super.key});

  static final List<Marker> _markers = [
    const LatLng(44.421, 10.404),
    const LatLng(45.683, 10.839),
    const LatLng(45.246, 5.783),
  ]
      .map(
        (markerPosition) => Marker(
          point: markerPosition,
          width: 40,
          height: 40,
          alignment: Alignment.topCenter,
          child: const Icon(Icons.location_on, size: 40),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Example'),
      ),
      drawer: buildDrawer(context, route),
      body: FlutterMap(
        options: const MapOptions(
          initialZoom: 5.0,
          initialCenter: LatLng(44.421, 10.404),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              markers: _markers,
              popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext context, Marker marker) =>
                    ExamplePopup(marker),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
