import 'package:flutter/foundation.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';

@immutable
sealed class PopupControllerEvent {
  const PopupControllerEvent();
}

class ShowPopupsAlsoForControllerEvent extends PopupControllerEvent {
  final List<PopupSpec> popupSpecs;
  final bool disableAnimation;

  const ShowPopupsAlsoForControllerEvent(
    this.popupSpecs, {
    required this.disableAnimation,
  });
}

class ShowPopupsOnlyForControllerEvent extends PopupControllerEvent {
  final List<PopupSpec> popupSpecs;
  final bool disableAnimation;

  const ShowPopupsOnlyForControllerEvent(
    this.popupSpecs, {
    required this.disableAnimation,
  });
}

class HideAllPopupsControllerEvent extends PopupControllerEvent {
  final bool disableAnimation;

  const HideAllPopupsControllerEvent({required this.disableAnimation});
}

class HidePopupsWhereControllerEvent extends PopupControllerEvent {
  final bool Function(PopupSpec popupSpec) test;
  final bool disableAnimation;

  const HidePopupsWhereControllerEvent(
    this.test, {
    required this.disableAnimation,
  });
}

class HidePopupsOnlyForControllerEvent extends PopupControllerEvent {
  final List<PopupSpec> popupSpecs;

  final bool disableAnimation;

  const HidePopupsOnlyForControllerEvent(
    this.popupSpecs, {
    required this.disableAnimation,
  });
}

class TogglePopupControllerEvent extends PopupControllerEvent {
  final PopupSpec popupSpec;
  final bool disableAnimation;

  const TogglePopupControllerEvent(
    this.popupSpec, {
    required this.disableAnimation,
  });
}
