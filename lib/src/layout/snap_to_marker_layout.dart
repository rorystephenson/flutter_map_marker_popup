import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';

import 'popup_layout.dart';

/// The correct snapping is achieved whilst ensuring GestureDetectors inside the
/// popup work and that the popup is always oriented horizontally by:
///   - Translating the entire map container
///   - Applying an appropriate Alignment to the popup
///   - Un-rotating the popup so it is horizontal
///
/// For example PopupSnap.markerRight is achieved by:
///   - Translating the whole container to the left edge of the marker,
///     with the container vertically centered on the Marker.
///   - Aligning the popup to the center-left inside the transformed container.
abstract class SnapToMarkerLayout {
  static PopupLayout left(MapState mapState, Marker marker, bool markerRotate) {
    final markerPoint = _markerPoint(mapState, marker);

    return PopupLayout(
      contentAlignment: Alignment.centerRight,
      rotationAlignment: Alignment.centerRight,
      transformationMatrix: Matrix4.identity()
        ..translate(
          -(mapState.size.x - markerPoint.x).toDouble(),
          -(mapState.size.y / 2) + markerPoint.y,
        )
        ..rotateZ(marker.rotate ?? markerRotate ? -mapState.rotationRad : 0.0)
        ..translate(
          -(marker.width - marker.anchor.left),
          -(marker.height / 2) + marker.anchor.top,
        ),
    );
  }

  static PopupLayout top(MapState mapState, Marker marker, bool markerRotate) {
    final markerPoint = _markerPoint(mapState, marker);

    return PopupLayout(
      contentAlignment: Alignment.bottomCenter,
      rotationAlignment: Alignment.bottomCenter,
      transformationMatrix: Matrix4.identity()
        ..translate(
          -(mapState.size.x / 2) + markerPoint.x,
          -(mapState.size.y - markerPoint.y).toDouble(),
        )
        ..rotateZ(marker.rotate ?? markerRotate ? -mapState.rotationRad : 0.0)
        ..translate(
          -(marker.width / 2) + marker.anchor.left,
          -(marker.height - marker.anchor.top),
        ),
    );
  }

  static PopupLayout right(
      MapState mapState, Marker marker, bool markerRotate) {
    final markerPoint = _markerPoint(mapState, marker);

    return PopupLayout(
      contentAlignment: Alignment.centerLeft,
      rotationAlignment: Alignment.centerLeft,
      transformationMatrix: Matrix4.identity()
        ..translate(
          markerPoint.x,
          -(mapState.size.y / 2) + markerPoint.y,
        )
        ..rotateZ(marker.rotate ?? markerRotate ? -mapState.rotationRad : 0.0)
        ..translate(
          marker.anchor.left,
          -(marker.height / 2) + marker.anchor.top,
        ),
    );
  }

  static PopupLayout bottom(
      MapState mapState, Marker marker, bool markerRotate) {
    final markerPoint = _markerPoint(mapState, marker);

    return PopupLayout(
      contentAlignment: Alignment.topCenter,
      rotationAlignment: Alignment.topCenter,
      transformationMatrix: Matrix4.identity()
        ..translate(
          -(mapState.size.x / 2) + markerPoint.x,
          markerPoint.y.toDouble(),
        )
        ..rotateZ(marker.rotate ?? markerRotate ? -mapState.rotationRad : 0.0)
        ..translate(
          -(marker.width / 2) + marker.anchor.left,
          marker.anchor.top,
        ),
    );
  }

  static PopupLayout center(
      MapState mapState, Marker marker, bool markerRotate) {
    final markerPoint = _markerPoint(mapState, marker);

    return PopupLayout(
      contentAlignment: Alignment.center,
      rotationAlignment: Alignment.center,
      transformationMatrix: Matrix4.identity()
        ..translate(
          -(mapState.size.x / 2) + markerPoint.x,
          -(mapState.size.y / 2) + markerPoint.y,
        )
        ..rotateZ(marker.rotate ?? markerRotate ? -mapState.rotationRad : 0.0)
        ..translate(
          -(marker.width / 2) + marker.anchor.left,
          -(marker.height / 2) + marker.anchor.top,
        ),
    );
  }

  static CustomPoint<num> _markerPoint(MapState mapState, Marker marker) {
    return mapState
            .project(marker.point)
            .multiplyBy(mapState.getZoomScale(mapState.zoom, mapState.zoom)) -
        mapState.getPixelOrigin();
  }
}
