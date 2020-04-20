import 'dart:async';

import 'package:flutter_map/plugin_api.dart';

class PopupController {
  StreamController<Marker> streamController;

  void hidePopup() {
    streamController?.add(null);
  }

  void togglePopup(Marker marker) {
    streamController?.add(marker);
  }
}