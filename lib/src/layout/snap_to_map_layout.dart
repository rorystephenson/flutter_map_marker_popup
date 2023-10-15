import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

import 'popup_layout.dart';

abstract class SnapToMapLayout {
  static PopupLayout left(MapCamera mapCamera) {
    return _layoutWith(
      contentAlignment: Alignment.centerLeft,
      mapRotationRad: mapCamera.rotationRad,
      translateX: _sizeChangeDueToRotation(mapCamera).x / 2,
    );
  }

  static PopupLayout top(MapCamera mapCamera) {
    return _layoutWith(
      contentAlignment: Alignment.topCenter,
      mapRotationRad: mapCamera.rotationRad,
      translateY: _sizeChangeDueToRotation(mapCamera).y / 2,
    );
  }

  static PopupLayout right(MapCamera mapCamera) {
    return _layoutWith(
      contentAlignment: Alignment.centerRight,
      mapRotationRad: mapCamera.rotationRad,
      translateX: -_sizeChangeDueToRotation(mapCamera).x / 2,
    );
  }

  static PopupLayout bottom(MapCamera mapCamera) {
    return _layoutWith(
      contentAlignment: Alignment.bottomCenter,
      mapRotationRad: mapCamera.rotationRad,
      translateY: -_sizeChangeDueToRotation(mapCamera).y / 2,
    );
  }

  static PopupLayout center(MapCamera mapCamera) {
    return _layoutWith(
      contentAlignment: Alignment.center,
      mapRotationRad: mapCamera.rotationRad,
    );
  }

  static Point<double> _sizeChangeDueToRotation(MapCamera mapCamera) =>
      mapCamera.size - mapCamera.nonRotatedSize;

  static PopupLayout _layoutWith({
    required Alignment contentAlignment,
    required double mapRotationRad,
    double translateX = 0.0,
    double translateY = 0.0,
  }) {
    return PopupLayout(
      contentAlignment: contentAlignment,
      rotationAlignment: Alignment.center,
      transformationMatrix: Matrix4.identity()
        ..rotateZ(-mapRotationRad)
        ..translate(translateX, translateY),
    );
  }
}
