import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'drawer.dart';
import 'example_popup.dart';

class WidgetBetweenPopupsAndMarkersPage extends StatefulWidget {
  static const route = 'widgetBetweenPopupsAndMarkersPage';

  const WidgetBetweenPopupsAndMarkersPage({super.key});

  @override
  State<WidgetBetweenPopupsAndMarkersPage> createState() =>
      _WidgetBetweenPopupsAndMarkersPageState();
}

class _WidgetBetweenPopupsAndMarkersPageState
    extends State<WidgetBetweenPopupsAndMarkersPage> {
  late final List<Marker> _markersA;
  late final List<Marker> _markersB;

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _markersA = [
      const LatLng(44.421, 10.404),
      const LatLng(45.683, 10.839),
      const LatLng(45.246, 5.783),
    ].map((latLng) => _markerFrom(latLng, Colors.black)).toList();

    _markersB = [
      const LatLng(39.421, 10.404),
      const LatLng(40.683, 10.839),
      const LatLng(40.246, 5.783),
    ].map((latLng) => _markerFrom(latLng, Colors.blue)).toList();
  }

  Marker _markerFrom(LatLng latLng, Color color) => Marker(
        point: latLng,
        width: 40,
        height: 40,
        alignment: Alignment.topCenter,
        child: Icon(Icons.location_on, size: 40, color: color),
      );

  @override
  void dispose() {
    _popupLayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Between Popups and Markers'),
      ),
      drawer: buildDrawer(context, WidgetBetweenPopupsAndMarkersPage.route),
      body: Column(
        children: [
          Expanded(
            child: PopupScope(
              popupController: _popupLayerController,
              onPopupEvent: (event, selectedMarkers) {
                debugPrint('$event: $selectedMarkers');
              },
              child: FlutterMap(
                options: MapOptions(
                  initialZoom: 5.0,
                  initialCenter: const LatLng(44.421, 10.404),
                  onTap: (_, __) => _popupLayerController
                      .hideAllPopups(), // Hide popup when the map is tapped.
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  PopupMarkerLayer(
                    options: PopupMarkerLayerOptions(
                      markers: _markersA,
                    ),
                  ),
                  PopupMarkerLayer(
                    options: PopupMarkerLayerOptions(
                      markers: _markersB,
                    ),
                  ),
                  IgnorePointer(
                      child: Container(color: Colors.red.withOpacity(0.2))),
                  PopupLayer(
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) =>
                          ExamplePopup(marker),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'This demonstrates popups being displayed with a transparent red '
              'layer between the markers and the popups.',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
