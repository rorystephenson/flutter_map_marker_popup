import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/layout/popup_container_translate.dart';

import 'popup_layout.dart';

/// The correct snapping is achieved whilst ensuring GestureDetectors inside the
/// popup work and that the popup is always oriented horizontally by:
///   - Translating the entire map container (full size)
///   - Applying an appropriate Alignment to the popup inside that container
///   - Un-rotating the popup so it is horizontal
///
/// For example PopupSnap.markerRight is achieved by:
///   - Translating the whole container so its left middle edge is touching the
///     marker's right edge.
///   - Aligning the popup to the center-left inside the transformed container.
///
/// Note that when the map is rotated flutter_map increases the width and height
/// of the map container such that it still contains the whole map view.
abstract class SnapToMarkerLayout {
  static PopupLayout left(FlutterMapState mapState, Marker marker, bool markerRotate) {
    return PopupLayout(
      contentAlignment: Alignment.centerRight,
      rotationAlignment: Alignment.centerRight,
      transformationMatrix: marker.rotate ?? markerRotate
          ? PopupContainerTransform.toLeftOfRotatedMarker(mapState, marker)
          : PopupContainerTransform.toLeftOfMarker(mapState, marker),
    );
  }

  static PopupLayout top(FlutterMapState mapState, Marker marker, bool markerRotate) {
    return PopupLayout(
      contentAlignment: Alignment.bottomCenter,
      rotationAlignment: Alignment.bottomCenter,
      transformationMatrix: marker.rotate ?? markerRotate
          ? PopupContainerTransform.toTopOfRotatedMarker(mapState, marker)
          : PopupContainerTransform.toTopOfMarker(mapState, marker),
    );
  }

  static PopupLayout right(
      FlutterMapState mapState, Marker marker, bool markerRotate) {
    return PopupLayout(
      contentAlignment: Alignment.centerLeft,
      rotationAlignment: Alignment.centerLeft,
      transformationMatrix: marker.rotate ?? markerRotate
          ? PopupContainerTransform.toRightOfRotatedMarker(mapState, marker)
          : PopupContainerTransform.toRightOfMarker(mapState, marker),
    );
  }

  static PopupLayout bottom(
      FlutterMapState mapState, Marker marker, bool markerRotate) {
    return PopupLayout(
      contentAlignment: Alignment.topCenter,
      rotationAlignment: Alignment.topCenter,
      transformationMatrix: marker.rotate ?? markerRotate
          ? PopupContainerTransform.toBottomOfRotatedMarker(mapState, marker)
          : PopupContainerTransform.toBottomOfMarker(mapState, marker),
    );
  }

  static PopupLayout center(
      FlutterMapState mapState, Marker marker, bool markerRotate) {
    return PopupLayout(
      contentAlignment: Alignment.center,
      rotationAlignment: Alignment.center,
      transformationMatrix: marker.rotate ?? markerRotate
          ? PopupContainerTransform.toCenterOfRotatedMarker(mapState, marker)
          : PopupContainerTransform.toCenterOfMarker(mapState, marker),
    );
  }
}
