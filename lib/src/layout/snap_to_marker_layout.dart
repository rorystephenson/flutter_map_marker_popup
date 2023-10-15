import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
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
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.centerRight,
      rotationAlignment: Alignment.centerRight,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toLeftOfRotatedMarker(mapCamera, popupSpec)
          : PopupContainerTransform.toLeftOfMarker(mapCamera, popupSpec),
    );
  }

  static PopupLayout top(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.bottomCenter,
      rotationAlignment: Alignment.bottomCenter,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toTopOfRotatedMarker(mapCamera, popupSpec)
          : PopupContainerTransform.toTopOfMarker(mapCamera, popupSpec),
    );
  }

  static PopupLayout right(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.centerLeft,
      rotationAlignment: Alignment.centerLeft,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toRightOfRotatedMarker(mapCamera, popupSpec)
          : PopupContainerTransform.toRightOfMarker(mapCamera, popupSpec),
    );
  }

  static PopupLayout bottom(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.topCenter,
      rotationAlignment: Alignment.topCenter,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toBottomOfRotatedMarker(
              mapCamera, popupSpec)
          : PopupContainerTransform.toBottomOfMarker(mapCamera, popupSpec),
    );
  }

  static PopupLayout center(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    return PopupLayout(
      contentAlignment: Alignment.center,
      rotationAlignment: Alignment.center,
      transformationMatrix: popupSpec.markerRotate
          ? PopupContainerTransform.toCenterOfRotatedMarker(
              mapCamera, popupSpec)
          : PopupContainerTransform.toCenterOfMarker(mapCamera, popupSpec),
    );
  }
}
