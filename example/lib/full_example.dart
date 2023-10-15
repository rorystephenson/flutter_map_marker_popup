import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'example_popup.dart';
import 'font/accurate_map_icons.dart';

class FullExample extends StatefulWidget {
  final PopupSnap snap;
  final bool rotate;
  final bool fade;
  final Alignment markerAlignment;
  final bool showMultiplePopups;
  final bool showPopups;
  // This is passed in rather than accessed via PopupState.of() to simplify the
  // moving of popups that occurs when certain options are changed in
  // didUpdateWidget. Usually it would be better to use PopupState.of() to
  // access the PopupState.
  final PopupState popupState;

  const FullExample({
    super.key,
    required this.snap,
    required this.rotate,
    required this.fade,
    required this.markerAlignment,
    required this.showMultiplePopups,
    required this.showPopups,
    required this.popupState,
  });

  @override
  State<FullExample> createState() => _FullExampleState();
}

class _FullExampleState extends State<FullExample> {
  late final PopupController _popupController;
  late List<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _popupController = PopupController();
    _markers = _buildMarkers();
  }

  @override
  void didUpdateWidget(FullExample oldWidget) {
    super.didUpdateWidget(oldWidget);

    final selectedMarkers = widget.popupState.selectedMarkers;
    if (widget.markerAlignment != oldWidget.markerAlignment ||
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
        debugPrint('We here');
        _popupController.showPopupsOnlyFor(
          matchingMarkers.toList(),
          disableAnimation: true,
        );
      } else {
        debugPrint('We ova here');
        _popupController.hideAllPopups(disableAnimation: true);
      }
    }

    /// If we change to show only one popup at a time we should hide all popups
    /// apart from the first one.
    if (!widget.showMultiplePopups && oldWidget.showMultiplePopups) {
      final matchingMarkers = _markers.where((marker) => selectedMarkers
          .any((selectedMarker) => marker.point == selectedMarker.point));

      if (matchingMarkers.length > 1) {
        _popupController.showPopupsOnlyFor([matchingMarkers.first]);
      }
    }
  }

  List<Marker> _buildMarkers() {
    return [
      Marker(
        point: const LatLng(44.421, 10.404),
        width: 40,
        height: 40,
        child: const Icon(
          AccurateMapIcons.locationOnBottomAligned,
          size: 40,
        ),
        alignment: widget.markerAlignment,
        rotate: widget.rotate,
      ),
      Marker(
        point: const LatLng(45.683, 10.839),
        width: 20,
        height: 40,
        alignment: widget.markerAlignment,
        rotate: widget.rotate,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(color: Colors.black, width: 0.0),
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 40)),
          ),
          width: 20,
          height: 40,
        ),
      ),
      Marker(
        point: const LatLng(45.246, 5.783),
        width: 40,
        height: 20,
        alignment: widget.markerAlignment,
        rotate: widget.rotate,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            border: Border.all(color: Colors.black, width: 0.0),
            borderRadius: const BorderRadius.all(Radius.elliptical(40, 20)),
          ),
          width: 40,
          height: 20,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialZoom: 5.0,
          initialCenter: const LatLng(44.421, 10.404),
          onTap: (_, __) => _popupController.hideAllPopups(),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              markerCenterAnimation: const MarkerCenterAnimation(),
              markers: _markers,
              popupController: _popupController,
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
