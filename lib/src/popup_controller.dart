import 'dart:async';

import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_event.dart';

class PopupController {
  StreamController<PopupEvent> streamController;

  void hidePopup() {
    streamController?.add(PopupEvent.hideAny());
  }

  void hidePopupIfShowingFor(List<Marker> markers) {
    streamController?.add(PopupEvent.hideInList(markers));
  }

  void togglePopup(Marker marker) {
    streamController?.add(PopupEvent.toggle(marker));
  }
}
