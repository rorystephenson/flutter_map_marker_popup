import 'dart:async';

import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_event.dart';

class PopupController {
  StreamController<PopupEvent>? streamController;

  /// The [Marker] for which a popup is currently showing if there is one.
  Marker? markerWithPopupVisible;

  /// Hide the popup if it is showing.
  void hidePopup({bool disableAnimation = false}) {
    streamController?.add(PopupEvent.hideAny(
      disableAnimation: disableAnimation,
    ));
  }

  /// Hide the popup but only if it is showing for one of the given markers.
  void hidePopupIfShowingFor(List<Marker> markers) {
    streamController?.add(PopupEvent.hideInList(markers));
  }

  /// Hide the popup if it is showing for the given marker, otherwise show it
  /// for that marker.
  void togglePopup(Marker marker) {
    streamController?.add(PopupEvent.toggle(marker));
  }

  /// Show the popup for the given marker. If the popup is already showing for
  /// that marker nothing happens.
  void showPopupFor(Marker marker, {bool disableAnimation = false}) {
    streamController?.add(PopupEvent.show(
      marker,
      disableAnimation: disableAnimation,
    ));
  }
}
