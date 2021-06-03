import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_popup_example/font/accurate_map_icons.dart';
import 'package:latlong2/latlong.dart';

import 'example_popup.dart';

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
      final markerWithPopup = _popupLayerController.selectedMarker;

      setState(() {
        _markers = _buildMarkers();
      });

      /// When changing the Markers we should hide the old popup if the Markers
      /// might have changed in such a way that the popup should change (e.g.
      /// anchor point change). If we can match one of the new Markers to the
      /// old Marker that had the popup then we can show the popup for that
      /// Marker.
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
    return [
      Marker(
        point: LatLng(44.421, 10.404),
        width: 40,
        height: 40,
        builder: (_) => Icon(
          AccurateMapIcons.location_on_bottom_aligned,
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
            borderRadius: BorderRadius.all(Radius.elliptical(20, 40)),
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
            borderRadius: BorderRadius.all(Radius.elliptical(40, 20)),
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
    return FlutterMap(
      options: MapOptions(
        zoom: 5.0,
        center: LatLng(44.421, 10.404),
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
            popupBuilder: (BuildContext context, Marker marker) =>
                ExamplePopup(marker),
            markerRotate: widget.rotate,
            markerRotateAlignment: PopupMarkerLayerOptions.rotationAlignmentFor(
              widget.markerAnchorAlign,
            ),
            popupAnimation: widget.fade
                ? PopupAnimation.fade(duration: Duration(milliseconds: 700))
                : null,
          ),
        ),
      ],
    );
  }
}
