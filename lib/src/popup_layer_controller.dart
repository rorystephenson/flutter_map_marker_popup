import 'dart:async';

import 'package:flutter_map_marker_popup/src/map_popup.dart';
import 'package:latlong/latlong.dart';

class PopupLayerController<T> {
  final StreamController<MapPopup<T>> _popupSink;
  MapPopup<T> _visiblePopup;

  Stream<MapPopup<T>> get popupStream => _popupSink.stream;

  T get visiblePopupUUID => _visiblePopup?.uuid;
  LatLng get visiblePopupPoint => _visiblePopup?.point;

  PopupLayerController()
      : this._popupSink = StreamController<MapPopup<T>>.broadcast();

  void togglePopup(T uuid, LatLng point) {
    _visiblePopup = uuid != null && _visiblePopup?.uuid != uuid
        ? MapPopup<T>(uuid, point)
        : null;

    _popupSink.add(_visiblePopup);
  }

  void hidePopup() {
    if (_visiblePopup != null) {
      _visiblePopup = null;
      _popupSink.add(_visiblePopup);
    }
  }

  void dispose() {
    _popupSink.close();
  }
}
