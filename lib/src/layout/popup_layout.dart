import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import 'snap_to_map_layout.dart';
import 'snap_to_marker_layout.dart';

/// The generated [PopupLayout] is intended to be applied to whole map
/// container. The map container is passed down by FlutterMap and it may have
/// rotation applied as well as being scaled up. The scaling up is to make sure
/// that the rotated map container covers the entire map widget in its
/// non-rotated form (as is seen by the user) otherwise hit testing does not
/// work on any Widgets which are visible inside the non-rotated widget but are
/// not within the rotated container's bounds.
///
class PopupLayout {
  final Alignment contentAlignment;
  final Alignment rotationAlignment;
  final Matrix4 transformationMatrix;

  PopupLayout({
    required this.rotationAlignment,
    required this.contentAlignment,
    required this.transformationMatrix,
  });

  static PopupLayout calculate({
    required MapState mapState,
    required Marker marker,
    required PopupSnap snap,
    required bool markerRotate,
  }) {
    if (snap is DefaultPopupSnap) {
      switch (snap.type) {
        case DefaultPopupSnapType.markerLeft:
          return SnapToMarkerLayout.left(mapState, marker, markerRotate);
        case DefaultPopupSnapType.markerTop:
          return SnapToMarkerLayout.top(mapState, marker, markerRotate);
        case DefaultPopupSnapType.markerRight:
          return SnapToMarkerLayout.right(mapState, marker, markerRotate);
        case DefaultPopupSnapType.markerBottom:
          return SnapToMarkerLayout.bottom(mapState, marker, markerRotate);
        case DefaultPopupSnapType.markerCenter:
          return SnapToMarkerLayout.center(mapState, marker, markerRotate);
        case DefaultPopupSnapType.mapLeft:
          return SnapToMapLayout.left(mapState);
        case DefaultPopupSnapType.mapTop:
          return SnapToMapLayout.top(mapState);
        case DefaultPopupSnapType.mapRight:
          return SnapToMapLayout.right(mapState);
        case DefaultPopupSnapType.mapBottom:
          return SnapToMapLayout.bottom(mapState);
        case DefaultPopupSnapType.mapCenter:
          return SnapToMapLayout.center(mapState);
        default:
          return SnapToMarkerLayout.top(mapState, marker, markerRotate);
      }
    }
    if (snap is CustomPopupSnap) {
      return SnapToMarkerLayout.custom(mapState, marker, markerRotate,
          snap.contentAlignment, snap.rotationAlignment);
    }

    return SnapToMarkerLayout.top(mapState, marker, markerRotate);
  }
}
