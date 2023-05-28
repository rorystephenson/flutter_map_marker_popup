import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'drawer.dart';
import 'example_popup.dart';

class MapWithSeparatePopups extends StatefulWidget {
  static const route = 'mapWithSeparatePopups';

  const MapWithSeparatePopups({Key? key}) : super(key: key);

  @override
  State<MapWithSeparatePopups> createState() => _MapWithSeparatePopupsState();
}

class _MapWithSeparatePopupsState extends State<MapWithSeparatePopups> {
  late final List<Marker> _markersA;
  late final List<Marker> _markersB;

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _markersA = [
      LatLng(44.421, 10.404),
      LatLng(45.683, 10.839),
      LatLng(45.246, 5.783),
    ].map((latLng) => _markerFrom(latLng, Colors.black)).toList();

    _markersB = [
      LatLng(39.421, 10.404),
      LatLng(40.683, 10.839),
      LatLng(40.246, 5.783),
    ].map((latLng) => _markerFrom(latLng, Colors.blue)).toList();
  }

  Marker _markerFrom(LatLng latLng, Color color) => Marker(
        point: latLng,
        width: 40,
        height: 40,
        builder: (_) => Icon(Icons.location_on, size: 40, color: color),
        anchorPos: AnchorPos.align(AnchorAlign.top),
        rotateAlignment: AnchorAlign.top.rotationAlignment,
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
        title: const Text('Map with separate popups'),
      ),
      drawer: buildDrawer(context, MapWithSeparatePopups.route),
      body: PopupScope(
        popupController: _popupLayerController,
        onPopupEvent: (event, selectedMarkers) {
          debugPrint('$event: $selectedMarkers');
        },
        child: FlutterMap(
          options: MapOptions(
            zoom: 5.0,
            center: LatLng(44.421, 10.404),
            onTap: (_, __) => _popupLayerController
                .hideAllPopups(), // Hide popup when the map is tapped.
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
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
            IgnorePointer(child: Container(color: Colors.red.withOpacity(0.2))),
            PopupLayer(
              popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext context, Marker marker) =>
                    ExamplePopup(marker),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
