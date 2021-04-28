import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_container.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

class PopupPosition {
  static PopupContainer container(
    MapState mapState,
    Marker marker,
    PopupSnap snap, {
    bool rotate = false,
  }) {
    assert(rotate != null);
    final markerPosition = _markerPosition(mapState, marker);

    final container = _containerFor(
      mapState.size,
      markerPosition,
      CustomPoint(marker.width, marker.height),
      snap,
    );
    if (!rotate) {
      return container;
    }

    final theta = mapState.rotationRad;

    final px = container.right ?? container.left;
    final py = container.top ?? container.bottom;

    double mx = 0.0;
    double my = 0.0;

    switch (snap) {
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.left:
      case PopupSnap.markerLeft:
        mx = -marker.width;
        my = marker.height / 2;
        break;
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.top:
      case PopupSnap.markerTop:
        my = -marker.height;
        break;
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.right:
      case PopupSnap.markerRight:
        my = marker.height / 2;
        break;
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.bottom:
      case PopupSnap.markerBottom:
        break;
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.center:
      case PopupSnap.markerCenter:
        mx = -marker.width / 2;
        my = -marker.height / 2;
        break;
      default:
        break;
    }

    final ox = px + mx;
    final oy = py + my;

    final x = cos(theta) * (px - ox) - sin(theta) * (py - oy) + ox;
    final y = sin(theta) * (px - ox) + cos(theta) * (py - oy) + oy;

    return PopupContainer(
      size: mapState.size,
      right: container.right == null ? null : x,
      left: container.left == null ? null : x,
      top: container.top == null ? null : y,
      bottom: container.bottom == null ? null : y,
      alignment: container.alignment,
    );
  }

  static PopupContainer _containerFor(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
    PopupSnap snap,
  ) {
    // Note: We always add the popup even if it might not be visible. This
    //       ensures the popup state is maintained even when it is not visible.
    switch (snap) {
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.left:
      case PopupSnap.markerLeft:
        return _snapToMarkerLeft(visibleSize, markerPosition, markerSize);
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.top:
      case PopupSnap.markerTop:
        return _snapToMarkerTop(visibleSize, markerPosition, markerSize);
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.right:
      case PopupSnap.markerRight:
        return _snapToMarkerRight(visibleSize, markerPosition, markerSize);
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.bottom:
      case PopupSnap.markerBottom:
        return _snapToMarkerBottom(visibleSize, markerPosition, markerSize);
      // ignore: deprecated_member_use_from_same_package
      case PopupSnap.center:
      case PopupSnap.markerCenter:
        return _snapToMarkerCenter(visibleSize, markerPosition, markerSize);
      case PopupSnap.mapLeft:
        return _snapToMap(visibleSize, Alignment.centerLeft);
      case PopupSnap.mapTop:
        return _snapToMap(visibleSize, Alignment.topCenter);
      case PopupSnap.mapRight:
        return _snapToMap(visibleSize, Alignment.centerRight);
      case PopupSnap.mapBottom:
        return _snapToMap(visibleSize, Alignment.bottomCenter);
      case PopupSnap.mapCenter:
        return _snapToMap(visibleSize, Alignment.center);
      default:
        return _snapToMarkerTop(visibleSize, markerPosition, markerSize);
    }
  }

  static PopupContainer _snapToMarkerLeft(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupContainer(
      size: visibleSize,
      right: visibleSize.x - markerPosition.x,
      top: markerPosition.y - (visibleSize.y / 2) + (markerSize.y / 2),
      alignment: Alignment.centerRight,
    );
  }

  static PopupContainer _snapToMarkerTop(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupContainer(
      size: visibleSize,
      alignment: Alignment.bottomCenter,
      left: markerPosition.x - (visibleSize.x / 2) + (markerSize.x / 2),
      bottom: visibleSize.y - markerPosition.y,
    );
  }

  static PopupContainer _snapToMarkerRight(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupContainer(
      size: visibleSize,
      alignment: Alignment.centerLeft,
      left: markerPosition.x + markerSize.x,
      top: markerPosition.y - (visibleSize.y / 2) + (markerSize.y / 2),
    );
  }

  static PopupContainer _snapToMarkerBottom(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupContainer(
      size: visibleSize,
      alignment: Alignment.topCenter,
      left: markerPosition.x - (visibleSize.x / 2) + (markerSize.x / 2),
      top: markerPosition.y + markerSize.y,
    );
  }

  static PopupContainer _snapToMarkerCenter(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupContainer(
      size: visibleSize,
      alignment: Alignment.center,
      left: markerPosition.x - (visibleSize.x / 2) + (markerSize.x / 2),
      top: markerPosition.y - (visibleSize.y / 2) + (markerSize.y / 2),
    );
  }

  static PopupContainer _snapToMap(
    CustomPoint visibleSize,
    Alignment alignment,
  ) {
    return PopupContainer(
      alignment: alignment,
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
    );
  }

  static CustomPoint _markerPosition(MapState mapState, Marker marker) {
    var pos = mapState.project(marker.point);
    pos = pos.multiplyBy(mapState.getZoomScale(mapState.zoom, mapState.zoom)) -
        mapState.getPixelOrigin();

    return CustomPoint((pos.x - (marker.width - marker.anchor.left)).toDouble(),
        (pos.y - (marker.height - marker.anchor.top)).toDouble());
  }
}
