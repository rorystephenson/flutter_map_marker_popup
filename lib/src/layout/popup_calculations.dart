import 'dart:math';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';

import 'oval_bounds.dart';

abstract class PopupCalculations {
  /// The X offset to the center of the marker from the marker's point.
  static double centerOffsetX(PopupSpec popupSpec) {
    return (popupSpec.markerWidth / 2) * popupSpec.markerAlignment.x;
  }

  /// The X offset to the left edge of the marker from the marker's point.
  static double leftOffsetX(PopupSpec popupSpec) {
    return centerOffsetX(popupSpec) - (popupSpec.markerWidth / 2);
  }

  /// The X offset to the right edge of the marker from the marker's point.
  static double rightOffsetX(PopupSpec popupSpec) {
    return centerOffsetX(popupSpec) + (popupSpec.markerWidth / 2);
  }

  /// The Y offset to the center of the marker from the marker's point.
  static double centerOffsetY(PopupSpec popupSpec) {
    return (popupSpec.markerHeight / 2) * popupSpec.markerAlignment.y;
  }

  /// The Y offset to the top edge of the marker from the marker's point.
  static double topOffsetY(PopupSpec popupSpec) {
    return centerOffsetY(popupSpec) - (popupSpec.markerHeight / 2);
  }

  /// The Y offset to the bottom edge of the marker from the marker's point.
  static double bottomOffsetY(PopupSpec popupSpec) {
    return centerOffsetY(popupSpec) + (popupSpec.markerHeight / 2);
  }

  /// The distance from the [marker] center to the horizontal bounds at a given
  /// rotation.
  static double boundXAtRotation(PopupSpec popupSpec, double radians) {
    return OvalBounds.boundX(
      popupSpec.markerWidth,
      popupSpec.markerHeight,
      radians,
    );
  }

  /// The distance from the [marker] center to the vertical bounds at a given
  /// rotation.
  static double boundYAtRotation(PopupSpec popupSpec, double radians) {
    return OvalBounds.boundY(
      popupSpec.markerWidth,
      popupSpec.markerHeight,
      radians,
    );
  }

  static double mapLeftToPointX(
    MapCamera mapCamera,
    Point<num> point,
  ) {
    return point.x.toDouble();
  }

  static double mapRightToPointX(
    MapCamera mapCamera,
    Point<num> point,
  ) {
    return -(mapCamera.size.x - point.x).toDouble();
  }

  static double mapCenterToPointX(
    MapCamera mapCamera,
    Point<num> point,
  ) {
    return -(mapCamera.size.x / 2 - point.x).toDouble();
  }

  static double mapTopToPointY(
    MapCamera mapCamera,
    Point<num> point,
  ) {
    return point.y.toDouble();
  }

  static double mapBottomToPointY(
    MapCamera mapCamera,
    Point<num> point,
  ) {
    return -(mapCamera.size.y - point.y).toDouble();
  }

  static double mapCenterToPointY(
    MapCamera mapCamera,
    Point<num> point,
  ) {
    return -(mapCamera.size.y / 2 - point.y).toDouble();
  }
}
