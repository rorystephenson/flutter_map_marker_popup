import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/plugin_api.dart';

import 'popup_container/marker_with_key.dart';
import 'popup_state.dart';

class PopupStateImpl with ChangeNotifier implements PopupState {
  /// The [MarkerWithKey]s for which a popup is currently showing if there is
  /// one. This is for internal use and any modifications to this Set should be
  /// performed with the provided methods below in order to ensure that
  /// listeners are notified.
  final Set<MarkerWithKey> selectedMarkersWithKeys;

  PopupStateImpl({
    List<Marker> initiallySelectedMarkers = const [],
  }) : selectedMarkersWithKeys = LinkedHashSet.from(
          initiallySelectedMarkers.map(
            (marker) => MarkerWithKey(marker),
          ),
        );

  @override
  List<Marker> get selectedMarkers => selectedMarkersWithKeys
      .map((markerWithKey) => markerWithKey.marker)
      .toList();

  @override
  bool isSelected(Marker marker) => contains(MarkerWithKey.wrap(marker));

  bool contains(MarkerWithKey markerWithKey) =>
      selectedMarkersWithKeys.contains(markerWithKey);

  void addAll(Iterable<MarkerWithKey> markersWithKeys) {
    selectedMarkersWithKeys.addAll(markersWithKeys);
    notifyListeners();
  }

  void clear() {
    selectedMarkersWithKeys.clear();
    notifyListeners();
  }

  void removeWhere(bool Function(MarkerWithKey markerWithKey) test) {
    selectedMarkersWithKeys.removeWhere(test);
    notifyListeners();
  }
}
