import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_layout.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

class PopupPosition {
  static PopupLayout layout(
    MapState mapState,
    Marker marker,
    PopupSnap snap,
  ) {
    final markerPosition = _markerPosition(mapState, marker);

    return _layoutFor(
      mapState.size,
      markerPosition,
      CustomPoint(marker.width, marker.height),
      snap,
    );
  }

  static PopupLayout _layoutFor(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
    PopupSnap snap,
  ) {
    // Note: We always add the popup even if it might not be visible. This
    //       ensures the popup state is maintained even when it is not visible.
    switch (snap) {
      case PopupSnap.markerLeft:
        return _snapToMarkerLeft(visibleSize, markerPosition, markerSize);
      case PopupSnap.markerTop:
        return _snapToMarkerTop(visibleSize, markerPosition, markerSize);
      case PopupSnap.markerRight:
        return _snapToMarkerRight(visibleSize, markerPosition, markerSize);
      case PopupSnap.markerBottom:
        return _snapToMarkerBottom(visibleSize, markerPosition, markerSize);
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

  static PopupLayout _snapToMarkerLeft(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupLayout(
      size: visibleSize,
      right: (visibleSize.x - markerPosition.x).toDouble(),
      top: markerPosition.y - (visibleSize.y / 2) + (markerSize.y / 2),
      alignment: Alignment.centerRight,
    );
  }

  static PopupLayout _snapToMarkerTop(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupLayout(
      size: visibleSize,
      alignment: Alignment.bottomCenter,
      left: markerPosition.x - (visibleSize.x / 2) + (markerSize.x / 2),
      bottom: (visibleSize.y - markerPosition.y).toDouble(),
    );
  }

  static PopupLayout _snapToMarkerRight(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupLayout(
      size: visibleSize,
      alignment: Alignment.centerLeft,
      left: (markerPosition.x + markerSize.x).toDouble(),
      top: markerPosition.y - (visibleSize.y / 2) + (markerSize.y / 2),
    );
  }

  static PopupLayout _snapToMarkerBottom(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupLayout(
      size: visibleSize,
      alignment: Alignment.topCenter,
      left: markerPosition.x - (visibleSize.x / 2) + (markerSize.x / 2),
      top: (markerPosition.y + markerSize.y).toDouble(),
    );
  }

  static PopupLayout _snapToMarkerCenter(
    CustomPoint visibleSize,
    CustomPoint markerPosition,
    CustomPoint markerSize,
  ) {
    return PopupLayout(
      size: visibleSize,
      alignment: Alignment.center,
      left: markerPosition.x - (visibleSize.x / 2) + (markerSize.x / 2),
      top: markerPosition.y - (visibleSize.y / 2) + (markerSize.y / 2),
    );
  }

  static PopupLayout _snapToMap(
    CustomPoint visibleSize,
    Alignment alignment,
  ) {
    return PopupLayout(
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
