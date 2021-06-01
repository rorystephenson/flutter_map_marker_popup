import 'package:flutter_map/plugin_api.dart';

import 'oval_bounds.dart';

abstract class PopupCalculations {
  /// The X offset to the center of the marker from the marker's point.
  static double centerOffsetX(Marker marker) {
    return -(marker.width / 2 - marker.anchor.left);
  }

  /// The X offset to the left edge of the marker from the marker's point.
  static double leftOffsetX(Marker marker) {
    return -(marker.width - marker.anchor.left);
  }

  /// The X offset to the right edge of the marker from the marker's point.
  static double rightOffsetX(Marker marker) {
    return marker.anchor.left;
  }

  /// The Y offset to the center of the marker from the marker's point.
  static double centerOffsetY(Marker marker) {
    return -(marker.height / 2 - marker.anchor.top);
  }

  /// The Y offset to the top edge of the marker from the marker's point.
  static double topOffsetY(Marker marker) {
    return -(marker.height - marker.anchor.top);
  }

  /// The Y offset to the bottom edge of the marker from the marker's point.
  static double bottomOffsetY(Marker marker) {
    return marker.anchor.top;
  }

  /// The distance from the [marker] center to the horizontal bounds at a given
  /// rotation.
  static double boundXAtRotation(Marker marker, double radians) {
    return OvalBounds.boundX(marker.width, marker.height, radians);
  }

  /// The distance from the [marker] center to the vertical bounds at a given
  /// rotation.
  static double boundYAtRotation(Marker marker, double radians) {
    return OvalBounds.boundY(marker.width, marker.height, radians);
  }

  static double mapLeftToPointX(MapState mapState, CustomPoint<num> point) {
    return point.x.toDouble();
  }

  static double mapRightToPointX(MapState mapState, CustomPoint<num> point) {
    return -(mapState.size.x - point.x).toDouble();
  }

  static double mapCenterToPointX(MapState mapState, CustomPoint<num> point) {
    return -(mapState.size.x / 2 - point.x).toDouble();
  }

  static double mapTopToPointY(MapState mapState, CustomPoint<num> point) {
    return point.y.toDouble();
  }

  static double mapBottomToPointY(MapState mapState, CustomPoint<num> point) {
    return -(mapState.size.y - point.y).toDouble();
  }

  static double mapCenterToPointY(MapState mapState, CustomPoint<num> point) {
    return -(mapState.size.y / 2 - point.y).toDouble();
  }
}
