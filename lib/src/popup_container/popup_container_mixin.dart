import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/layout/popup_layout.dart';
import 'package:flutter_map_marker_popup/src/popup_container/marker_with_key.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import '../popup_controller.dart';
import '../popup_event.dart';

mixin PopupContainerMixin {
  MapState get mapState;

  PopupController get popupController;

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
      hide: wrapHideAny,
      toggle: toggle,
      show: wrapShowForMarker,
      hideInList: hideInList,
    );
  }

  @nonVirtual
  void toggle(Marker marker) {
    if (markerIsVisible(marker)) {
      wrapHideAny(disableAnimation: false);
    } else {
      wrapShowForMarker(marker, disableAnimation: false);
    }
  }

  @nonVirtual
  void hideInList(List<Marker> markers) {
    if (markers.any((marker) => markerIsVisible(marker))) {
      wrapHideAny(disableAnimation: false);
    }
  }

  @nonVirtual
  void wrapShowForMarker(Marker marker, {required bool disableAnimation}) {
    final markerWithKey = MarkerWithKey(marker);
    popupController.selectedMarkerWithKey = markerWithKey;
    showForMarker(markerWithKey, disableAnimation: disableAnimation);
  }

  @nonVirtual
  void wrapHideAny({required bool disableAnimation}) {
    popupController.selectedMarkerWithKey = null;
    hideAny(disableAnimation: disableAnimation);
  }

  bool markerIsVisible(Marker marker);

  void hideAny({required bool disableAnimation});

  void showForMarker(
    MarkerWithKey markerWithKey, {
    required bool disableAnimation,
  });
}
