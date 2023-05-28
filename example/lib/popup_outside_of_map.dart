import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'drawer.dart';

class PopupOutsideOfMap extends StatefulWidget {
  static const route = 'popupOutsideOfMapExample';

  const PopupOutsideOfMap({Key? key}) : super(key: key);

  @override
  State<PopupOutsideOfMap> createState() => _PopupOutsideOfMapState();
}

class _PopupOutsideOfMapState extends State<PopupOutsideOfMap> {
  static final positions = [
    LatLng(45.246, 5.783),
    LatLng(45.683, 10.839),
    LatLng(44.421, 10.404),
  ];
  late final List<Marker> _markers;

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _markers = positions
        .map((markerPosition) => Marker(
              point: markerPosition,
              width: 40,
              height: 40,
              builder: (_) => const Icon(Icons.location_on, size: 40),
              anchorPos: AnchorPos.align(AnchorAlign.top),
            ))
        .toList();
  }

  @override
  void dispose() {
    _popupLayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Popup outside of map')),
        drawer: buildDrawer(context, PopupOutsideOfMap.route),
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        zoom: 5.0,
                        center: LatLng(44.421, 10.404),
                        onTap: (_, __) => _popupLayerController
                            .hideAllPopups(), // Hide popup when the map is tapped.
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        PopupMarkerLayer(
                          options: PopupMarkerLayerOptions(
                            popupController: _popupLayerController,
                            markers: _markers,
                            markerTapBehavior: MarkerTapBehavior.togglePopup(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    color: Colors.white,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'This example demonstrates how you can place popups '
                      'wherever you want. In this case they will appear above '
                      'the map and this message.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: CustomPopupsDisplay(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPopupsDisplay extends StatelessWidget {
  const CustomPopupsDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final markersWithPopups = PopupState.maybeOf(context)!.selectedMarkers;
    final selectedMarkerNumbers = markersWithPopups
        .map((marker) =>
            _PopupOutsideOfMapState.positions.indexOf(marker.point) + 1)
        .toList()
      ..sort();
    final selectedMarkersText = selectedMarkerNumbers.join(', ');

    if (markersWithPopups.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: GestureDetector(
        onTap: () {
          debugPrint('tap');
        },
        child: Card(
          elevation: 5,
          child: Container(
            height: 100,
            width: 200,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            child: Text(
              'Selected markers: $selectedMarkersText',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
