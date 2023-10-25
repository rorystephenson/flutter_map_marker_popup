import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'drawer.dart';

class PopupOutsideOfMapPage extends StatefulWidget {
  static const route = 'popupOutsideOfMapPage';

  const PopupOutsideOfMapPage({super.key});

  @override
  State<PopupOutsideOfMapPage> createState() => _PopupOutsideOfMapPageState();
}

class _PopupOutsideOfMapPageState extends State<PopupOutsideOfMapPage> {
  static final positions = [
    const LatLng(45.246, 5.783),
    const LatLng(45.683, 10.839),
    const LatLng(44.421, 10.404),
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
              alignment: Alignment.topCenter,
              child: const Icon(Icons.location_on, size: 40),
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
        appBar: AppBar(title: const Text('Popup Outside of Map')),
        drawer: buildDrawer(context, PopupOutsideOfMapPage.route),
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        initialZoom: 5.0,
                        initialCenter: const LatLng(44.421, 10.404),
                        onTap: (_, __) => _popupLayerController.hideAllPopups(),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                    padding: const EdgeInsets.all(16.0),
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
  const CustomPopupsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final markersWithPopups = PopupState.maybeOf(context)!.selectedMarkers;
    final selectedMarkerNumbers = markersWithPopups
        .map((marker) =>
            _PopupOutsideOfMapPageState.positions.indexOf(marker.point) + 1)
        .toList()
      ..sort();
    final selectedMarkersText = selectedMarkerNumbers.join(', ');

    if (markersWithPopups.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: GestureDetector(
        onTap: () {
          debugPrint('Tap');
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
