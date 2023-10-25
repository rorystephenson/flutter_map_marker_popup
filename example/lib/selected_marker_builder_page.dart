import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'drawer.dart';
import 'example_popup.dart';

class SelectedMarkerBuilderPage extends StatefulWidget {
  static const route = 'selectedMarkerBuilderPage';

  const SelectedMarkerBuilderPage({super.key});

  @override
  State<SelectedMarkerBuilderPage> createState() =>
      _SelectedMarkerBuilderPageState();
}

class _SelectedMarkerBuilderPageState extends State<SelectedMarkerBuilderPage> {
  late final List<Marker> _markers;

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _markers = [
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Marker Builder'),
      ),
      drawer: buildDrawer(context, SelectedMarkerBuilderPage.route),
      body: FlutterMap(
        options: MapOptions(
          initialZoom: 5.0,
          initialCenter: const LatLng(44.421, 10.404),
          onTap: (_, __) => _popupLayerController.hideAllPopups(),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              popupController: _popupLayerController,
              markers: _markers,
              popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext context, Marker marker) =>
                    ExamplePopup(marker),
              ),
              selectedMarkerBuilder: (context, marker) => const Icon(
                Icons.location_on,
                size: 40,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
