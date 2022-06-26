import 'dart:async';

import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_event.dart';

import 'popup_controller.dart';

class PopupControllerImpl implements PopupController {
  StreamController<PopupEvent>? streamController;

  PopupControllerImpl();

  @override
  void showPopupsAlsoFor(
    List<Marker> markers, {
    bool disableAnimation = false,
  }) {
    streamController?.add(PopupEvent.showAlsoFor(
      markers,
      disableAnimation: disableAnimation,
    ));
  }

  @override
  void showPopupsOnlyFor(
    List<Marker> markers, {
    bool disableAnimation = false,
  }) {
    streamController?.add(
      PopupEvent.showOnlyFor(markers, disableAnimation: disableAnimation),
    );
  }

  @override
  void hideAllPopups({bool disableAnimation = false}) {
    streamController?.add(
      PopupEvent.hideAll(disableAnimation: disableAnimation),
    );
  }

  @override
  void hidePopupsOnlyFor(
    List<Marker> markers, {
    bool disableAnimation = false,
  }) {
    streamController?.add(
      PopupEvent.hideOnlyFor(markers, disableAnimation: disableAnimation),
    );
  }

  @override
  void togglePopup(Marker marker, {bool disableAnimation = false}) {
    streamController?.add(PopupEvent.toggle(marker, disableAnimation: false));
  }
}
