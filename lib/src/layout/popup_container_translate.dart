import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
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
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapRightToPointX(mapCamera, markerPoint),
      PopupCalculations.mapCenterToPointY(mapCamera, markerPoint),
      0.0,
    )
      ..rotateZ(-mapCamera.rotationRad)
      ..translate(
        PopupCalculations.leftOffsetX(popupSpec),
        PopupCalculations.centerOffsetY(popupSpec),
      );
  }

  static Matrix4 toLeftOfMarker(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapRightToPointX(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapCenterToPointY(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )
      ..rotateZ(-mapCamera.rotationRad)
      ..translate(
        -PopupCalculations.boundXAtRotation(popupSpec, -mapCamera.rotationRad),
      );
  }

  static Matrix4 toTopOfRotatedMarker(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapCamera, markerPoint),
      PopupCalculations.mapBottomToPointY(mapCamera, markerPoint),
      0.0,
    )
      ..rotateZ(-mapCamera.rotationRad)
      ..translate(
        PopupCalculations.centerOffsetX(popupSpec),
        PopupCalculations.topOffsetY(popupSpec),
      );
  }

  static Matrix4 toTopOfMarker(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapBottomToPointY(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )
      ..rotateZ(-mapCamera.rotationRad)
      ..translate(
        0.0,
        -PopupCalculations.boundYAtRotation(popupSpec, -mapCamera.rotationRad),
      );
  }

  static Matrix4 toRightOfRotatedMarker(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapLeftToPointX(mapCamera, markerPoint),
      PopupCalculations.mapCenterToPointY(mapCamera, markerPoint),
      0.0,
    )
      ..rotateZ(-mapCamera.rotationRad)
      ..translate(
        PopupCalculations.rightOffsetX(popupSpec),
        PopupCalculations.centerOffsetY(popupSpec),
      );
  }

  static Matrix4 toRightOfMarker(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapLeftToPointX(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapCenterToPointY(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )
      ..rotateZ(-mapCamera.rotationRad)
      ..translate(
        PopupCalculations.boundXAtRotation(popupSpec, -mapCamera.rotationRad),
      );
  }

  static Matrix4 toBottomOfRotatedMarker(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapCamera, markerPoint),
      PopupCalculations.mapTopToPointY(mapCamera, markerPoint),
      0.0,
    )
      ..rotateZ(-mapCamera.rotationRad)
      ..translate(
        PopupCalculations.centerOffsetX(popupSpec),
        PopupCalculations.bottomOffsetY(popupSpec),
      );
  }

  static Matrix4 toBottomOfMarker(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapTopToPointY(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )
      ..rotateZ(-mapCamera.rotationRad)
      ..translate(
        0.0,
        PopupCalculations.boundYAtRotation(popupSpec, -mapCamera.rotationRad),
      );
  }

  static Matrix4 toCenterOfRotatedMarker(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapCamera, markerPoint),
      PopupCalculations.mapCenterToPointY(mapCamera, markerPoint),
      0.0,
    )
      ..rotateZ(-mapCamera.rotationRad)
      ..translate(
        PopupCalculations.centerOffsetX(popupSpec),
        PopupCalculations.centerOffsetY(popupSpec),
      );
  }

  static Matrix4 toCenterOfMarker(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    final markerPoint = _markerPoint(mapCamera, popupSpec);

    return Matrix4.translationValues(
      PopupCalculations.mapCenterToPointX(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetX(popupSpec),
      PopupCalculations.mapCenterToPointY(mapCamera, markerPoint) +
          PopupCalculations.centerOffsetY(popupSpec),
      0.0,
    )..rotateZ(-mapCamera.rotationRad);
  }

  static Point<num> _markerPoint(
    MapCamera mapCamera,
    PopupSpec popupSpec,
  ) {
    return mapCamera.project(popupSpec.markerPoint) -
        mapCamera.pixelOrigin.toDoublePoint();
  }
}
