import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';

import 'oval_bounds.dart';

abstract class PopupCalculations {
  /// The X offset to the center of the marker from the marker's point.
  static double centerOffsetX(PopupSpec popupSpec) {
    return -(popupSpec.markerWidth / 2 - popupSpec.markerAnchor.left);
  }

  /// The X offset to the left edge of the marker from the marker's point.
  static double leftOffsetX(PopupSpec popupSpec) {
    return -(popupSpec.markerWidth - popupSpec.markerAnchor.left);
  }

  /// The X offset to the right edge of the marker from the marker's point.
  static double rightOffsetX(PopupSpec popupSpec) {
    return popupSpec.markerAnchor.left;
  }

  /// The Y offset to the center of the marker from the marker's point.
  static double centerOffsetY(PopupSpec popupSpec) {
    return -(popupSpec.markerHeight / 2 - popupSpec.markerAnchor.top);
  }

  /// The Y offset to the top edge of the marker from the marker's point.
  static double topOffsetY(PopupSpec popupSpec) {
    return -(popupSpec.markerHeight - popupSpec.markerAnchor.top);
  }

  /// The Y offset to the bottom edge of the marker from the marker's point.
  static double bottomOffsetY(PopupSpec popupSpec) {
    return popupSpec.markerAnchor.top;
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
    FlutterMapState mapState,
    CustomPoint<num> point,
  ) {
    return point.x.toDouble();
  }

  static double mapRightToPointX(
    FlutterMapState mapState,
    CustomPoint<num> point,
  ) {
    return -(mapState.size.x - point.x).toDouble();
  }

  static double mapCenterToPointX(
    FlutterMapState mapState,
    CustomPoint<num> point,
  ) {
    return -(mapState.size.x / 2 - point.x).toDouble();
  }

  static double mapTopToPointY(
    FlutterMapState mapState,
    CustomPoint<num> point,
  ) {
    return point.y.toDouble();
  }

  static double mapBottomToPointY(
    FlutterMapState mapState,
    CustomPoint<num> point,
  ) {
    return -(mapState.size.y - point.y).toDouble();
  }

  static double mapCenterToPointY(
    FlutterMapState mapState,
    CustomPoint<num> point,
  ) {
    return -(mapState.size.y / 2 - point.y).toDouble();
  }
}
