import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_popup_example/drawer.dart';
import 'package:latlong2/latlong.dart';

class PopupOutsideOfMap extends StatefulWidget {
  static const route = 'popupOutsideOfMapExample';

  const PopupOutsideOfMap({Key? key}) : super(key: key);

  @override
  State<PopupOutsideOfMap> createState() => _PopupOutsideOfMapState();
}

class _PopupOutsideOfMapState extends State<PopupOutsideOfMap> {
  late final List<Marker> _markers;

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _markers = [
      LatLng(44.421, 10.404),
      LatLng(45.683, 10.839),
      LatLng(45.246, 5.783),
    ]
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
  Widget build(BuildContext context) {
    return PopupScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Popup outside of map')),
        drawer: buildDrawer(context, PopupOutsideOfMap.route),
        body: Column(
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
                  TileLayerWidget(
                    options: TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                  ),
                  PopupMarkerLayerWidget(
                    options: PopupMarkerLayerOptions(
                      popupController: _popupLayerController,
                      markers: _markers,
                      markerTapBehavior: MarkerTapBehavior.togglePopup(),
                    ),
                  ),
                ],
              ),
            ),
            const CustomPopupsDisplay(),
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
    final markersWithPopupsDescription =
        markersWithPopups.map((marker) => marker.point.toString()).join('\n');

    if (markersWithPopups.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(markersWithPopupsDescription),
    );
  }
}
