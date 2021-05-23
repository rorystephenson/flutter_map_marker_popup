import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/marker_with_key.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import 'popup_event.dart';
import 'popup_position.dart';

mixin PopupContainerMixin {
  MapState get mapState;

  PopupSnap get snap;

  Widget inPosition(Marker marker, Widget popup) {
    final popupContainer = PopupPosition.layout(
      mapState,
      marker,
      snap,
    );

    return Positioned(
      width: popupContainer.width,
      height: popupContainer.height,
      left: popupContainer.left,
      top: popupContainer.top,
      right: popupContainer.right,
      bottom: popupContainer.bottom,
      child: Align(
        alignment: popupContainer.alignment,
        child: popup,
      ),
    );
  }

  /// This makes sure that the state of the popup stays with the popup even if
  /// it goes off screen or changes position in the widget tree.
  Widget popupWithStateKeepAlive(MarkerWithKey markerWithKey,
      Widget Function(BuildContext, Marker) popupBuilder) {
    return Builder(
      key: markerWithKey.key,
      builder: (context) => popupBuilder(
        context,
        markerWithKey.marker,
      ),
    );
  }

  void handleAction(PopupEvent event) {
    event.handle(
      hide: hideAny,
      toggle: toggle,
      show: showForMarker,
      hideInList: hideInList,
    );
  }

  bool markerIsVisible(Marker marker);

  void hideAny();

  void showForMarker(Marker marker);

  @nonVirtual
  void toggle(Marker marker) {
    if (markerIsVisible(marker)) {
      hideAny();
    } else {
      showForMarker(marker);
    }
  }

  @nonVirtual
  void hideInList(List<Marker> markers) {
    if (markers.any((marker) => markerIsVisible(marker))) {
      hideAny();
    }
  }
}
