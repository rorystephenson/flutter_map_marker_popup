import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/plugin_api.dart';
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

  void applyEvent(PopupControllerEvent popupEvent) {
    return popupEvent.handle(
      showAlsoFor: _showAlsoFor,
      showOnlyFor: _showOnlyFor,
      hideAll: _hideAll,
      hideWhere: _hideWhere,
      hideOnlyFor: _hideOnlyFor,
      toggle: _toggle,
    );
  }

  void _showAlsoFor(
    List<PopupSpec> popupSpecs, {
    required bool disableAnimation,
  }) {
    if (popupSpecs.isEmpty) return;

    _selectedPopupSpecs.addAll(popupSpecs);
    notifyListeners();

    _streamController.add(
      ShowedPopupsAlsoForImpl(
        popupSpecs,
        disableAnimation: disableAnimation,
      ),
    );
  }

  void _showOnlyFor(
    List<PopupSpec> popupSpecs, {
    required bool disableAnimation,
  }) {
    _selectedPopupSpecs.clear();
    _selectedPopupSpecs.addAll(popupSpecs);
    notifyListeners();

    _streamController.add(
      ShowedPopupsOnlyForImpl(
        popupSpecs,
        disableAnimation: disableAnimation,
      ),
    );
  }

  void _hideAll({required bool disableAnimation}) {
    _selectedPopupSpecs.clear();
    notifyListeners();

    _streamController.add(
      HidAllPopupsImpl(disableAnimation: disableAnimation),
    );
  }

  void _hideWhere(
    bool Function(PopupSpec popupSpec) test, {
    required bool disableAnimation,
  }) {
    final List<PopupSpec> removed = [];
    _selectedPopupSpecs.removeWhere((popupSpec) {
      if (test(popupSpec)) {
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
        disableAnimation: disableAnimation,
      ),
    );
  }

  void _hideOnlyFor(
    List<PopupSpec> popupSpecs, {
    required bool disableAnimation,
  }) {
    _selectedPopupSpecs.removeAll(popupSpecs);
    notifyListeners();

    _streamController.add(
      HidPopupsOnlyForImpl(
        popupSpecs,
        disableAnimation: disableAnimation,
      ),
    );
  }

  void _toggle(PopupSpec popupSpec, {bool disableAnimation = false}) {
    if (contains(popupSpec)) {
      _hideOnlyFor([popupSpec], disableAnimation: disableAnimation);
    } else {
      _showAlsoFor([popupSpec], disableAnimation: disableAnimation);
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
