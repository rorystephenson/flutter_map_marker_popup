import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/layout/popup_layout.dart';
import 'package:flutter_map_marker_popup/src/popup_container/marker_with_key.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import '../popup_event.dart';

mixin PopupContainerMixin {
  MapState get mapState;

  PopupSnap get snap;

  bool get markerRotate;

  @nonVirtual
  Widget inPosition(Marker marker, Widget popup) {
    final layout = popupLayout(marker);

    return Positioned.fill(
      child: Transform(
        alignment: layout.rotationAlignment,
        transform: layout.transformationMatrix,
        child: Align(
          alignment: layout.contentAlignment,
          child: popup,
        ),
      ),
    );
  }

  @nonVirtual
  PopupLayout popupLayout(Marker marker) {
    return PopupLayout.calculate(
      mapState: mapState,
      marker: marker,
      snap: snap,
      markerRotate: markerRotate,
    );
  }

  /// This makes sure that the state of the popup stays with the popup even if
  /// it goes off screen or changes position in the widget tree.
  @nonVirtual
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

  @nonVirtual
  void handleAction(PopupEvent event) {
    return event.handle(
      hide: hideAny,
      toggle: toggle,
      show: showForMarker,
      hideInList: hideInList,
    );
  }

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

  bool markerIsVisible(Marker marker);

  void hideAny();

  void showForMarker(Marker marker);
}
