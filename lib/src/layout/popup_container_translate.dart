import 'package:flutter/rendering.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';

import 'popup_calculations.dart';

/// Calculates a [Matrix4] that will un-rotate the map container and translate
/// it such that the opposite point of the map container sits next to edge of
/// the [Marker] indicated by the popup snap, e.g.:
///   - left: Translates the map container so that it's right middle edge
///     touches the [Marker]'s left edge after the rotation is applied to the
///     marker (or no rotation if it is disabled).
///   - toCenterOfMarker: Translates the map container so that it's center
///     touches the [Marker]'s center.
abstract class PopupContainerTransform {
  static Matrix4 toLeftOfRotatedMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapRightToPointX(mapState, markerPoint),
      PopupCalculations.mapCenterToPointY(mapState, markerPoint),
      0.0,
    )
      ..rotateZ(-mapState.rotationRad)
      ..translate(
        PopupCalculations.leftOffsetX(popupSpec),
        PopupCalculations.centerOffsetY(popupSpec),
      );
  }

  static Matrix4 toLeftOfMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapRightToPointX(mapState, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapCenterToPointY(mapState, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )
      ..rotateZ(-mapState.rotationRad)
      ..translate(
        -PopupCalculations.boundXAtRotation(popupSpec, -mapState.rotationRad),
      );
  }

  static Matrix4 toTopOfRotatedMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapState, markerPoint),
      PopupCalculations.mapBottomToPointY(mapState, markerPoint),
      0.0,
    )
      ..rotateZ(-mapState.rotationRad)
      ..translate(
        PopupCalculations.centerOffsetX(popupSpec),
        PopupCalculations.topOffsetY(popupSpec),
      );
  }

  static Matrix4 toTopOfMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapState, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapBottomToPointY(mapState, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )
      ..rotateZ(-mapState.rotationRad)
      ..translate(
        0.0,
        -PopupCalculations.boundYAtRotation(popupSpec, -mapState.rotationRad),
      );
  }

  static Matrix4 toRightOfRotatedMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapLeftToPointX(mapState, markerPoint),
      PopupCalculations.mapCenterToPointY(mapState, markerPoint),
      0.0,
    )
      ..rotateZ(-mapState.rotationRad)
      ..translate(
        PopupCalculations.rightOffsetX(popupSpec),
        PopupCalculations.centerOffsetY(popupSpec),
      );
  }

  static Matrix4 toRightOfMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapLeftToPointX(mapState, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapCenterToPointY(mapState, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )
      ..rotateZ(-mapState.rotationRad)
      ..translate(
        PopupCalculations.boundXAtRotation(popupSpec, -mapState.rotationRad),
      );
  }

  static Matrix4 toBottomOfRotatedMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapState, markerPoint),
      PopupCalculations.mapTopToPointY(mapState, markerPoint),
      0.0,
    )
      ..rotateZ(-mapState.rotationRad)
      ..translate(
        PopupCalculations.centerOffsetX(popupSpec),
        PopupCalculations.bottomOffsetY(popupSpec),
      );
  }

  static Matrix4 toBottomOfMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapState, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapTopToPointY(mapState, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )
      ..rotateZ(-mapState.rotationRad)
      ..translate(
        0.0,
        PopupCalculations.boundYAtRotation(popupSpec, -mapState.rotationRad),
      );
  }

  static Matrix4 toCenterOfRotatedMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapState, markerPoint),
      PopupCalculations.mapCenterToPointY(mapState, markerPoint),
      0.0,
    )
      ..rotateZ(-mapState.rotationRad)
      ..translate(
        PopupCalculations.centerOffsetX(popupSpec),
        PopupCalculations.centerOffsetY(popupSpec),
      );
  }

  static Matrix4 toCenterOfMarker(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapState, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapState, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapCenterToPointY(mapState, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )..rotateZ(-mapState.rotationRad);
  }

  static CustomPoint<num> _markerPoint(
    FlutterMapState mapState,
    PopupSpec popupSpec,
  ) {
    return mapState
            .project(popupSpec.markerPoint)
            .multiplyBy(mapState.getZoomScale(mapState.zoom, mapState.zoom)) -
        mapState.pixelOrigin;
  }
}
