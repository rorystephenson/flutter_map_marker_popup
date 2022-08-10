import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_popup_example/font/accurate_map_icons.dart';
import 'package:latlong2/latlong.dart';

import 'example_popup.dart';

class MapWithPopups extends StatefulWidget {
  final PopupState popupState;
  final PopupSnap snap;
  final bool rotate;
  final bool fade;
  final AnchorAlign markerAnchorAlign;
  final bool showMultiplePopups;

  const MapWithPopups({
    required this.popupState,
    required this.snap,
    required this.rotate,
    required this.fade,
    required this.markerAnchorAlign,
    required this.showMultiplePopups,
    Key? key,
  }) : super(key: key);

  @override
  State<MapWithPopups> createState() => _MapWithPopupsState();
}

class _MapWithPopupsState extends State<MapWithPopups> {
  late List<Marker> _markers;

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();

    _markers = _buildMarkers();
  }

  @override
  void didUpdateWidget(covariant MapWithPopups oldWidget) {
    super.didUpdateWidget(oldWidget);

    final selectedMarkers = widget.popupState.selectedMarkers;
    if (widget.markerAnchorAlign != oldWidget.markerAnchorAlign) {
      setState(() {
        _markers = _buildMarkers();
      });

      /// When changing the Markers we should hide the old popup if the Markers
      /// might have changed in such a way that the popup should change (e.g.
      /// anchor point change). If we can match one of the new Markers to the
      /// old Marker that had the popup then we can show the popup for that
      /// Marker.
      final matchingMarkers = _markers.where((marker) => selectedMarkers
          .any((selectedMarker) => marker.point == selectedMarker.point));

      if (matchingMarkers.isNotEmpty) {
        _popupLayerController.showPopupsOnlyFor(matchingMarkers.toList(),
            disableAnimation: true);
      } else {
        _popupLayerController.hideAllPopups(disableAnimation: true);
      }
    }

    /// If we change to show only one popup at a time we should hide all popups
    /// apart from the first one.
    if (!widget.showMultiplePopups && oldWidget.showMultiplePopups) {
      final matchingMarkers = _markers.where((marker) => selectedMarkers
          .any((selectedMarker) => marker.point == selectedMarker.point));

      if (matchingMarkers.length > 1) {
        _popupLayerController.showPopupsOnlyFor([matchingMarkers.first]);
      }
    }
  }

  List<Marker> _buildMarkers() {
    return [
      Marker(
        point: LatLng(44.421, 10.404),
        width: 40,
        height: 40,
        builder: (_) => const Icon(
          AccurateMapIcons.locationOnBottomAligned,
          size: 40,
        ),
        anchorPos: AnchorPos.align(widget.markerAnchorAlign),
      ),
      Marker(
        point: LatLng(45.683, 10.839),
        width: 20,
        height: 40,
        builder: (_) => Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(color: Colors.black, width: 0.0),
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 40)),
          ),
          width: 20,
          height: 40,
        ),
        anchorPos: AnchorPos.align(widget.markerAnchorAlign),
      ),
      Marker(
        point: LatLng(45.246, 5.783),
        width: 40,
        height: 20,
        builder: (_) => Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            border: Border.all(color: Colors.black, width: 0.0),
            borderRadius: const BorderRadius.all(Radius.elliptical(40, 20)),
          ),
          width: 40,
          height: 20,
        ),
        anchorPos: AnchorPos.align(widget.markerAnchorAlign),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          zoom: 5.0,
          center: LatLng(44.421, 10.404),
          onTap: (_, __) => _popupLayerController
              .hideAllPopups(), // Hide popup when the map is tapped.
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PopupMarkerLayerWidget(
            options: PopupMarkerLayerOptions(
              markerCenterAnimation: const MarkerCenterAnimation(),
              markers: _markers,
              popupSnap: widget.snap,
              popupController: _popupLayerController,
              popupBuilder: (BuildContext context, Marker marker) =>
                  ExamplePopup(marker),
              markerRotate: widget.rotate,
              markerRotateAlignment:
                  PopupMarkerLayerOptions.rotationAlignmentFor(
                widget.markerAnchorAlign,
              ),
              popupAnimation: widget.fade
                  ? const PopupAnimation.fade(
                      duration: Duration(milliseconds: 700))
                  : null,
              markerTapBehavior: widget.showMultiplePopups
                  ? MarkerTapBehavior.togglePopup()
                  : MarkerTapBehavior.togglePopupAndHideRest(),
              onPopupEvent: (event, selectedMarkers) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(event.runtimeType.toString()),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
