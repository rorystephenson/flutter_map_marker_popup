import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/controller/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/controller/popup_controller_event.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';

class PopupControllerImpl implements PopupController {
  final StreamController<PopupControllerEvent> _streamController =
      StreamController<PopupControllerEvent>.broadcast();

  Stream<PopupControllerEvent> get stream => _streamController.stream;

  PopupControllerImpl();

  @override
  void showPopupsAlsoForSpecs(
    List<PopupSpec> popupSpecs, {
    bool disableAnimation = false,
  }) {
    _streamController.add(
      ShowPopupsAlsoForControllerEvent(
        popupSpecs,
        disableAnimation: disableAnimation,
      ),
    );
  }

  @override
  void showPopupsOnlyForSpecs(
    List<PopupSpec> popupSpecs, {
    bool disableAnimation = false,
  }) {
    _streamController.add(
      ShowPopupsOnlyForControllerEvent(
        popupSpecs,
        disableAnimation: disableAnimation,
      ),
    );
  }

  @override
  void hideAllPopups({bool disableAnimation = false}) {
    _streamController.add(
      HideAllPopupsControllerEvent(disableAnimation: disableAnimation),
    );
  }

  @override
  void hidePopupsWhereSpec(
    bool Function(PopupSpec popupSpec) test, {
    bool disableAnimation = false,
  }) {
    _streamController.add(
      HidePopupsWhereControllerEvent(test, disableAnimation: disableAnimation),
    );
  }

  @override
  void hidePopupsOnlyForSpecs(
    List<PopupSpec> popupSpecs, {
    bool disableAnimation = false,
  }) {
    _streamController.add(
      HidePopupsOnlyForControllerEvent(
        popupSpecs,
        disableAnimation: disableAnimation,
      ),
    );
  }

  @override
  void togglePopupSpec(PopupSpec popupSpec, {bool disableAnimation = false}) {
    _streamController.add(
      TogglePopupControllerEvent(
        popupSpec,
        disableAnimation: disableAnimation,
      ),
    );
  }

  @override
  void hidePopupsOnlyFor(
    List<Marker> markers, {
    bool disableAnimation = false,
  }) =>
      hidePopupsOnlyForSpecs(
        markers.map(PopupSpec.wrap).toList(),
        disableAnimation: disableAnimation,
      );

  @override
  void hidePopupsWhere(
    bool Function(Marker marker) test, {
    bool disableAnimation = false,
  }) =>
      hidePopupsWhereSpec(
        (popupSpec) => test(popupSpec.marker),
        disableAnimation: disableAnimation,
      );

  @override
  void showPopupsAlsoFor(
    List<Marker> markers, {
    bool disableAnimation = false,
  }) =>
      showPopupsAlsoForSpecs(
        markers.map(PopupSpec.wrap).toList(),
        disableAnimation: disableAnimation,
      );

  @override
  void showPopupsOnlyFor(
    List<Marker> markers, {
    bool disableAnimation = false,
  }) =>
      showPopupsOnlyForSpecs(
        markers.map(PopupSpec.wrap).toList(),
        disableAnimation: disableAnimation,
      );

  @override
  void togglePopup(
    Marker marker, {
    bool disableAnimation = false,
  }) =>
      togglePopupSpec(
        PopupSpec.wrap(marker),
        disableAnimation: disableAnimation,
      );

  @override
  void dispose() {
    _streamController.close();
  }
}
