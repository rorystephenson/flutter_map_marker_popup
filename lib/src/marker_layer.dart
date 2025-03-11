// marker_layer.dart
// BSD-3-Clause License
//
// (Include or keep the complete BSD-3-Clause license text here.)

import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/controller/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/options/popup_marker_layer_options.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:flutter_map_marker_popup/src/state/popup_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

/// A [StatefulWidget] that:
/// • Draws [Marker]s on the map.
/// • Intercepts Marker taps and passes them to [PopupController].
/// • Optionally draws a “selectedMarkerBuilder” if the marker is selected.
@immutable
class MarkerLayer extends StatefulWidget {
  final PopupMarkerLayerOptions layerOptions;
  final MapCamera mapCamera;
  final MapController mapController;
  final PopupState popupState;
  final PopupController popupController;

  const MarkerLayer({
    super.key,
    required this.layerOptions,
    required this.mapCamera,
    required this.mapController,
    required this.popupState,
    required this.popupController,
  });

  @override
  State<MarkerLayer> createState() => _MarkerLayerState();
}

class _MarkerLayerState extends State<MarkerLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _centerMarkerController;
  void Function()? _animationListener;

  @override
  void initState() {
    super.initState();
    // For animating map panning/zoom when tapping a marker (if configured).
    _centerMarkerController = AnimationController(
      vsync: this,
      duration: widget.layerOptions.markerCenterAnimation?.duration,
    );
  }

  @override
  void dispose() {
    _centerMarkerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If there’s a special builder for the “selected” marker, rebuild when selection changes:
    if (widget.layerOptions.selectedMarkerBuilder != null) {
      context.watch<PopupState>();
    }

    final markers = widget.layerOptions.markers;
    final markerWidgets = <Widget>[];

    for (final marker in markers) {
      // Calculate alignment offsets.
      final alignment = marker.alignment ?? Alignment.center;
      final left = 0.5 * marker.width * (alignment.x + 1);
      final top = 0.5 * marker.height * (alignment.y + 1);
      final right = marker.width - left;
      final bottom = marker.height - top;

      // Project marker’s LatLng into map's pixel coordinates at the current zoom.
      final pxPoint = widget.mapCamera.projectAtZoom(
        marker.point,
        widget.mapCamera.zoom,
      );

      // Convert the marker bounding box into a Rect for culling.
      final markerRect = Rect.fromLTWH(
        pxPoint.dx - left,
        pxPoint.dy - bottom,
        marker.width,
        marker.height,
      );

      // If the markerRect is completely off-screen, skip building this marker.
      if (!widget.mapCamera.pixelBounds.overlaps(markerRect)) {
        continue;
      }

      // Convert map pixel coordinates to screen coordinates by subtracting pixelOrigin.
      final screenX = pxPoint.dx - widget.mapCamera.pixelOrigin.dx;
      final screenY = pxPoint.dy - widget.mapCamera.pixelOrigin.dy;

      // If marker is selected, use the custom “selectedMarkerBuilder.”
      Widget markerChild = marker.child;
      if (widget.layerOptions.selectedMarkerBuilder != null &&
          widget.popupState.isSelected(marker)) {
        markerChild =
            widget.layerOptions.selectedMarkerBuilder!(context, marker);
      }

      // Wrap the marker in a GestureDetector for tap handling.
      final tappableMarker = GestureDetector(
        onTap: () {
          // Optionally re-center the map on this marker if it’s newly selected.
          if (!widget.popupState.selectedMarkers.contains(marker)) {
            _centerMarker(marker);
          }
          // Then show/hide the popup via PopupController.
          widget.layerOptions.markerTapBehavior.apply(
            PopupSpec.wrap(marker),
            widget.popupState,
            widget.popupController,
          );
        },
        child: markerChild,
      );

      // Place the marker widget in the Stack at the appropriate position.
      final markerWidget = Positioned(
        key: marker.key,
        width: marker.width,
        height: marker.height,
        left: screenX - right,
        top: screenY - bottom,
        child: marker.rotate == true
            ? Transform.rotate(
          angle: -widget.mapCamera.rotationRad,
          alignment: alignment * -1,
          child: tappableMarker,
        )
            : tappableMarker,
      );

      markerWidgets.add(markerWidget);
    }

    return Stack(children: markerWidgets);
  }

  /// Animate the map to center on [marker], if [markerCenterAnimation] is set.
  void _centerMarker(Marker marker) {
    final animationCfg = widget.layerOptions.markerCenterAnimation;
    if (animationCfg == null) return;

    // Keep our existing center, zoom as starting points.
    final startCenter = widget.mapCamera.center;
    final startZoom = widget.mapCamera.zoom;

    // Marker’s destination center.
    final destCenter = marker.point;

    // Cancel any previous animation in progress.
    _animationListener?.call();
    _animationListener = null;
    _centerMarkerController.reset();

    // Create a tween for the center only.
    final centerTween = _LatLngTween(
      begin: startCenter,
      end: destCenter,
    );

    // If your animation does not need to change zoom, just keep it the same.
    final zoomTween = Tween<double>(
      begin: startZoom,
      end: startZoom,
    );

    // Update the map’s center/zoom each animation frame.
    _animationListener = () {
      final t = _centerMarkerController.value;
      final newCenter = centerTween.lerp(t);
      final newZoom = zoomTween.lerp(t);
      widget.mapController.move(newCenter, newZoom);
    };

    // Start the animation.
    _centerMarkerController.addListener(_animationListener!);
    _centerMarkerController.forward();
  }
}

/// Helper for interpolating between two LatLng points.
class _LatLngTween {
  final LatLng begin;
  final LatLng end;

  _LatLngTween({required this.begin, required this.end});

  LatLng lerp(double t) {
    final lat = _lerpDouble(begin.latitude, end.latitude, t);
    final lng = _lerpDouble(begin.longitude, end.longitude, t);
    return LatLng(lat, lng);
  }

  double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
