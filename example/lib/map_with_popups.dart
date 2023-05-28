import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'example_popup.dart';
import 'font/accurate_map_icons.dart';

class MapWithPopups extends StatefulWidget {
  final PopupState popupState;
  final PopupSnap snap;
  final bool rotate;
  final bool fade;
  final AnchorAlign markerAnchorAlign;
  final bool showMultiplePopups;
  final bool showPopups;
  final PopupController popupController;

  const MapWithPopups({
    super.key,
    required this.popupState,
    required this.snap,
    required this.rotate,
    required this.fade,
    required this.markerAnchorAlign,
    required this.showMultiplePopups,
    required this.showPopups,
    required this.popupController,
  });

  @override
  State<MapWithPopups> createState() => _MapWithPopupsState();
}

class _MapWithPopupsState extends State<MapWithPopups> {
  late List<Marker> _markers;

  @override
  void didUpdateWidget(covariant MapWithPopups oldWidget) {
    super.didUpdateWidget(oldWidget);

    final selectedMarkers = widget.popupState.selectedMarkers;
    if (widget.markerAnchorAlign != oldWidget.markerAnchorAlign ||
        widget.rotate != oldWidget.rotate) {
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
        widget.popupController.showPopupsOnlyFor(matchingMarkers.toList(),
            disableAnimation: true);
      } else {
        widget.popupController.hideAllPopups(disableAnimation: true);
      }
    }

    /// If we change to show only one popup at a time we should hide all popups
    /// apart from the first one.
    if (!widget.showMultiplePopups && oldWidget.showMultiplePopups) {
      final matchingMarkers = _markers.where((marker) => selectedMarkers
          .any((selectedMarker) => marker.point == selectedMarker.point));

      if (matchingMarkers.length > 1) {
        widget.popupController.showPopupsOnlyFor([matchingMarkers.first]);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _markers = _buildMarkers();
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
        rotate: widget.rotate,
        rotateAlignment: widget.markerAnchorAlign.rotationAlignment,
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
        rotate: widget.rotate,
        rotateAlignment: widget.markerAnchorAlign.rotationAlignment,
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
        rotate: widget.rotate,
        rotateAlignment: widget.markerAnchorAlign.rotationAlignment,
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
          onTap: (_, __) => widget.popupController
              .hideAllPopups(), // Hide popup when the map is tapped.
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              markerCenterAnimation: const MarkerCenterAnimation(),
              markers: _markers,
              popupDisplayOptions: !widget.showPopups
                  ? null
                  : PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) =>
                          ExamplePopup(marker),
                      snap: widget.snap,
                      animation: widget.fade
                          ? const PopupAnimation.fade(
                              duration: Duration(milliseconds: 700))
                          : null,
                    ),
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
