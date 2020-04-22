import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_container.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

class PopupPosition {
  static PopupContainer container(
    MapState mapState,
    Marker marker,
    PopupSnap snap,
  ) {
    final CustomPoint markerPosition = _markerPosition(mapState, marker);

    return _containerFor(
      mapState.size,
      markerPosition,
      CustomPoint(marker.width, marker.height),
      snap,
    );
  }

  static PopupContainer _containerFor(CustomPoint visibleSize,
      CustomPoint markerPosition, CustomPoint markerSize, PopupSnap snap) {
    // Note: We always add the popup even if it might not be visible. This
    //       ensures the popup state is maintained even when it is not visible.
    switch (snap) {
      case PopupSnap.left:
        return _snapLeft(visibleSize, markerPosition, markerSize);
      case PopupSnap.top:
        return _snapTop(visibleSize, markerPosition, markerSize);
      case PopupSnap.right:
        return _snapRight(visibleSize, markerPosition, markerSize);
      case PopupSnap.bottom:
        return _snapBottom(visibleSize, markerPosition, markerSize);
      case PopupSnap.center:
        return _snapCenter(visibleSize, markerPosition, markerSize);
      default:
        return _snapTop(visibleSize, markerPosition, markerSize);
    }
  }

  static PopupContainer _snapLeft(CustomPoint visibleSize,
      CustomPoint markerPosition, CustomPoint markerSize) {
    return PopupContainer(
      size: visibleSize,
      right: visibleSize.x - markerPosition.x,
      top: markerPosition.y - (visibleSize.y / 2) + (markerSize.y / 2),
      alignment: Alignment.centerRight,
    );
  }

  static PopupContainer _snapTop(CustomPoint visibleSize,
      CustomPoint markerPosition, CustomPoint markerSize) {
    return PopupContainer(
      size: visibleSize,
      alignment: Alignment.bottomCenter,
      left: markerPosition.x - (visibleSize.x / 2) + (markerSize.x / 2),
      bottom: visibleSize.y - markerPosition.y,
    );
  }

  static PopupContainer _snapRight(CustomPoint visibleSize,
      CustomPoint markerPosition, CustomPoint markerSize) {
    return PopupContainer(
      size: visibleSize,
      alignment: Alignment.centerLeft,
      left: markerPosition.x + markerSize.x,
      top: markerPosition.y - (visibleSize.y / 2) + (markerSize.y / 2),
    );
  }

  static PopupContainer _snapBottom(CustomPoint visibleSize,
      CustomPoint markerPosition, CustomPoint markerSize) {
    return PopupContainer(
      size: visibleSize,
      alignment: Alignment.topCenter,
      left: markerPosition.x - (visibleSize.x / 2) + (markerSize.x / 2),
      top: markerPosition.y + markerSize.y,
    );
  }

  static PopupContainer _snapCenter(CustomPoint visibleSize,
      CustomPoint markerPosition, CustomPoint markerSize) {
    return PopupContainer(
      size: visibleSize,
      alignment: Alignment.center,
      left: markerPosition.x - (visibleSize.x / 2) + (markerSize.x / 2),
      top: markerPosition.y - (visibleSize.y / 2) + (markerSize.y / 2),
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
