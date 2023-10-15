import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_popup/src/controller/popup_controller_event.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event_impl.dart';

class PopupStateImpl with ChangeNotifier implements PopupState {
  final StreamController<PopupEvent> _streamController =
      StreamController<PopupEvent>.broadcast();

  Stream<PopupEvent> get stream => _streamController.stream;

  /// The [PopupSpec]s for which a popup is currently showing if there is
  /// one.
  final Set<PopupSpec> _selectedPopupSpecs;

  @override
  List<PopupSpec> get selectedPopupSpecs => _selectedPopupSpecs.toList();

  @override
  List<Marker> get selectedMarkers =>
      _selectedPopupSpecs.map((popupSpec) => popupSpec.marker).toList();

  PopupStateImpl({
    List<PopupSpec> initiallySelected = const [],
  }) : _selectedPopupSpecs = LinkedHashSet.from(initiallySelected);

  @override
  bool isSelected(Marker marker) => contains(PopupSpec.wrap(marker));

  bool contains(PopupSpec popupSpec) => _selectedPopupSpecs.contains(popupSpec);

  void applyEvent(PopupControllerEvent event) {
    switch (event) {
      case ShowPopupsAlsoForControllerEvent():
        _showAlsoFor(event);
      case ShowPopupsOnlyForControllerEvent():
        _showOnlyFor(event);
      case HideAllPopupsControllerEvent():
        _hideAll(event);
      case HidePopupsWhereControllerEvent():
        _hideWhere(event);
      case HidePopupsOnlyForControllerEvent():
        _hideOnlyFor(event);
      case TogglePopupControllerEvent():
        _toggle(event);
    }
  }

  void _showAlsoFor(ShowPopupsAlsoForControllerEvent event) {
    if (event.popupSpecs.isEmpty) return;

    _selectedPopupSpecs.addAll(event.popupSpecs);
    notifyListeners();

    _streamController.add(
      ShowedPopupsAlsoForImpl(
        event.popupSpecs,
        disableAnimation: event.disableAnimation,
      ),
    );
  }

  void _showOnlyFor(ShowPopupsOnlyForControllerEvent event) {
    _selectedPopupSpecs.clear();
    _selectedPopupSpecs.addAll(event.popupSpecs);
    notifyListeners();

    _streamController.add(
      ShowedPopupsOnlyForImpl(
        event.popupSpecs,
        disableAnimation: event.disableAnimation,
      ),
    );
  }

  void _hideAll(HideAllPopupsControllerEvent event) {
    _selectedPopupSpecs.clear();
    notifyListeners();

    _streamController.add(
      HidAllPopupsImpl(disableAnimation: event.disableAnimation),
    );
  }

  void _hideWhere(HidePopupsWhereControllerEvent event) {
    final List<PopupSpec> removed = [];
    _selectedPopupSpecs.removeWhere((popupSpec) {
      if (event.test(popupSpec)) {
        removed.add(popupSpec);
        return true;
      }
      return false;
    });
    if (removed.isEmpty) return;

    notifyListeners();

    _streamController.add(
      HidPopupsOnlyForImpl(
        removed,
        disableAnimation: event.disableAnimation,
      ),
    );
  }

  void _hideOnlyFor(HidePopupsOnlyForControllerEvent event) {
    _selectedPopupSpecs.removeAll(event.popupSpecs);
    notifyListeners();

    _streamController.add(
      HidPopupsOnlyForImpl(
        event.popupSpecs,
        disableAnimation: event.disableAnimation,
      ),
    );
  }

  void _toggle(TogglePopupControllerEvent event) {
    if (contains(event.popupSpec)) {
      _hideOnlyFor(HidePopupsOnlyForControllerEvent(
        [event.popupSpec],
        disableAnimation: event.disableAnimation,
      ));
    } else {
      _showAlsoFor(ShowPopupsAlsoForControllerEvent(
        [event.popupSpec],
        disableAnimation: event.disableAnimation,
      ));
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
