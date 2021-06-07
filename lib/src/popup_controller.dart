import 'dart:async';

import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_container/marker_with_key.dart';
import 'package:flutter_map_marker_popup/src/popup_event.dart';

class PopupController {
  StreamController<PopupEvent>? streamController;

  /// The [MarkerWithKey] for which a popup is currently showing if there is
  /// one. This is for internal use.
  MarkerWithKey? selectedMarkerWithKey;

  /// The [Marker] for which a popup is currently showing if there is one.
  Marker? get selectedMarker => selectedMarkerWithKey?.marker;

  /// Used to programmatically add/remove the popup.
  ///
  /// The [selectedMarker] getter can be used to find the [Marker] for which
  /// the popup is currently showing if there is a popup showing.
  ///
  /// To show a popup immediately set the [initiallySelectedMarker].
  PopupController({Marker? initiallySelectedMarker})
      : selectedMarkerWithKey = initiallySelectedMarker == null
            ? null
            : MarkerWithKey(initiallySelectedMarker);

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
