import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/layout/popup_container_translate.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';

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
  static PopupLayout left(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.centerRight,
      rotationAlignment: Alignment.centerRight,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toLeftOfRotatedMarker(mapState, popupSpec)
          : PopupContainerTransform.toLeftOfMarker(mapState, popupSpec),
    );
  }

  static PopupLayout top(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.bottomCenter,
      rotationAlignment: Alignment.bottomCenter,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toTopOfRotatedMarker(mapState, popupSpec)
          : PopupContainerTransform.toTopOfMarker(mapState, popupSpec),
    );
  }

  static PopupLayout right(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.centerLeft,
      rotationAlignment: Alignment.centerLeft,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toRightOfRotatedMarker(mapState, popupSpec)
          : PopupContainerTransform.toRightOfMarker(mapState, popupSpec),
    );
  }

  static PopupLayout bottom(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.topCenter,
      rotationAlignment: Alignment.topCenter,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toBottomOfRotatedMarker(mapState, popupSpec)
          : PopupContainerTransform.toBottomOfMarker(mapState, popupSpec),
    );
  }

  static PopupLayout center(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.center,
      rotationAlignment: Alignment.center,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toCenterOfRotatedMarker(mapState, popupSpec)
          : PopupContainerTransform.toCenterOfMarker(mapState, popupSpec),
    );
  }
}
