import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

import 'example_popup.dart';
import 'font/accurate_map_icons.dart';

class MapWithPopups extends StatefulWidget {
  final PopupSnap snap;
  final bool rotate;
  final bool fade;
  final AnchorAlign markerAnchorAlign;

  MapWithPopups({
    required this.snap,
    required this.rotate,
    required this.fade,
    required this.markerAnchorAlign,
    Key? key,
  }) : super(key: key);

  @override
  _MapWithPopupsState createState() => _MapWithPopupsState();
}

class _MapWithPopupsState extends State<MapWithPopups> {
  static final List<LatLng> _points = [
    LatLng(44.421, 10.404),
    LatLng(45.683, 10.839),
    LatLng(45.246, 5.783),
  ];

  static const _markerSize = 40.0;
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
    if (widget.markerAnchorAlign != oldWidget.markerAnchorAlign) {
      final markerWithPopup = _popupLayerController.markerWithPopupVisible;

      setState(() {
        _markers = _buildMarkers();
      });

      /// When changing the markers we should hide the old popup since the
      /// marker might have changed in such a way that the popup should change
      /// (e.g. anchor point change). If we can match one of the new markers to
      /// the old marker that had the popup then we can show the popup for
      /// that marker.
      if (markerWithPopup != null) {
        final markerWithPopupIndex = _markers
            .indexWhere((marker) => marker.point == markerWithPopup.point);

        if (markerWithPopupIndex != -1) {
          _popupLayerController.showPopupFor(
            _markers[markerWithPopupIndex],
            disableAnimation: true,
          );
        } else {
          _popupLayerController.hidePopup(disableAnimation: true);
        }
      }
    }
  }

  List<Marker> _buildMarkers() {
    return _points
        .map(
          (LatLng point) => Marker(
            point: point,
            width: _markerSize,
            height: _markerSize,
            builder: (_) => Icon(
              AccurateMapIcons.location_on_bottom_aligned,
              size: _markerSize,
            ),
            anchorPos: AnchorPos.align(widget.markerAnchorAlign),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        zoom: 5.0,
        center: _points.first,
        onTap: (_) => _popupLayerController
            .hidePopup(), // Hide popup when the map is tapped.
      ),
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
        ),
        PopupMarkerLayerWidget(
          options: PopupMarkerLayerOptions(
            markers: _markers,
            popupSnap: widget.snap,
            popupController: _popupLayerController,
            popupBuilder: (BuildContext _, Marker marker) =>
                ExamplePopup(marker),
            markerAndPopupRotate: widget.rotate,
            markerRotateAlignment: PopupMarkerLayerOptions.rotationAlignmentFor(
                widget.markerAnchorAlign),
            popupAnimation: widget.fade
                ? PopupAnimation.fade(
                    duration: Duration(milliseconds: 700),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
