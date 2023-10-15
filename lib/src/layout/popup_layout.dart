import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';

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
    required MapCamera mapCamera,
    required PopupSpec popupSpec,
    required PopupSnap snap,
  }) {
    switch (snap) {
      case PopupSnap.markerLeft:
        return SnapToMarkerLayout.left(mapCamera, popupSpec);
      case PopupSnap.markerTop:
        return SnapToMarkerLayout.top(mapCamera, popupSpec);
      case PopupSnap.markerRight:
        return SnapToMarkerLayout.right(mapCamera, popupSpec);
      case PopupSnap.markerBottom:
        return SnapToMarkerLayout.bottom(mapCamera, popupSpec);
      case PopupSnap.markerCenter:
        return SnapToMarkerLayout.center(mapCamera, popupSpec);
      case PopupSnap.mapLeft:
        return SnapToMapLayout.left(mapCamera);
      case PopupSnap.mapTop:
        return SnapToMapLayout.top(mapCamera);
      case PopupSnap.mapRight:
        return SnapToMapLayout.right(mapCamera);
      case PopupSnap.mapBottom:
        return SnapToMapLayout.bottom(mapCamera);
      case PopupSnap.mapCenter:
        return SnapToMapLayout.center(mapCamera);
      default:
        return SnapToMarkerLayout.top(mapCamera, popupSpec);
    }
  }
}
