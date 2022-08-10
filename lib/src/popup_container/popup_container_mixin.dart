import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/layout/popup_layout.dart';
import 'package:flutter_map_marker_popup/src/popup_container/marker_with_key.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import '../popup_event.dart';
import '../popup_state_impl.dart';

mixin PopupContainerMixin {
  FlutterMapState get mapState;

  PopupStateImpl get popupStateImpl;

  PopupSnap get snap;

  bool get markerRotate;

  Function(PopupEvent event, List<Marker> selectedMarkers)? get onPopupEvent;

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
    onPopupEvent?.call(event, popupStateImpl.selectedMarkers);

    return event.handle(
      showAlsoFor: wrapShowPopupsAlsoFor,
      showOnlyFor: wrapShowPopupsOnlyFor,
      hideAll: wrapHideAllPopups,
      hideOnlyFor: wrapHidePopupsOnlyFor,
      toggle: toggle,
    );
  }

  @nonVirtual
  void wrapShowPopupsAlsoFor(
    List<Marker> markers, {
    required bool disableAnimation,
  }) {
    final markersWithKeys =
        markers.map((marker) => MarkerWithKey(marker)).toList();
    popupStateImpl.addAll(markersWithKeys);

    showPopupsAlsoFor(markersWithKeys, disableAnimation: disableAnimation);
  }

  @nonVirtual
  void wrapShowPopupsOnlyFor(
    List<Marker> markers, {
    required bool disableAnimation,
  }) {
    final markersWithKeys =
        markers.map((marker) => MarkerWithKey(marker)).toList();

    popupStateImpl.clear();
    popupStateImpl.addAll(markersWithKeys);

    showPopupsOnlyFor(markersWithKeys, disableAnimation: disableAnimation);
  }

  @nonVirtual
  void wrapHideAllPopups({required bool disableAnimation}) {
    popupStateImpl.clear();
    hideAllPopups(disableAnimation: disableAnimation);
  }

  @nonVirtual
  void wrapHidePopupsOnlyFor(
    List<Marker> markers, {
    required bool disableAnimation,
  }) {
    popupStateImpl
        .removeWhere((markerWithKey) => markers.contains(markerWithKey.marker));
    hidePopupsOnlyFor(markers, disableAnimation: disableAnimation);
  }

  @nonVirtual
  void toggle(Marker marker, {bool disableAnimation = false}) {
    if (popupStateImpl.contains(MarkerWithKey.wrap(marker))) {
      wrapHidePopupsOnlyFor([marker], disableAnimation: disableAnimation);
    } else {
      wrapShowPopupsAlsoFor([marker], disableAnimation: disableAnimation);
    }
  }

  void showPopupsAlsoFor(
    List<MarkerWithKey> markersWithKeys, {
    required bool disableAnimation,
  });

  void showPopupsOnlyFor(
    List<MarkerWithKey> markersWithKeys, {
    required bool disableAnimation,
  });

  void hideAllPopups({required bool disableAnimation});

  void hidePopupsOnlyFor(List<Marker> markers,
      {required bool disableAnimation});
}
