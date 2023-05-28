import 'package:flutter/foundation.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';

@immutable
abstract class PopupControllerEvent {
  const PopupControllerEvent();

  void handle({
    required void Function(
      List<PopupSpec> popupSpecs, {
      required bool disableAnimation,
    })
        showAlsoFor,
    required void Function(
      List<PopupSpec> popupSpecs, {
      required bool disableAnimation,
    })
        showOnlyFor,
    required void Function({
      required bool disableAnimation,
    })
        hideAll,
    required void Function(
      bool Function(PopupSpec popupSpec) test, {
      required bool disableAnimation,
    })
        hideWhere,
    required void Function(
      List<PopupSpec> popupSpecs, {
      required bool disableAnimation,
    })
        hideOnlyFor,
    required void Function(
      PopupSpec popupSpec, {
      required bool disableAnimation,
    })
        toggle,
  }) {
    final thisEvent = this;
    if (thisEvent is ShowPopupsAlsoForControllerEvent) {
      return showAlsoFor(
        thisEvent.popupSpecs,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is ShowPopupsOnlyForControllerEvent) {
      return showOnlyFor(
        thisEvent.popupSpecs,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is HideAllPopupsControllerEvent) {
      return hideAll(disableAnimation: thisEvent.disableAnimation);
    } else if (thisEvent is HidePopupsWhereControllerEvent) {
      return hideWhere(
        thisEvent.test,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is HidePopupsOnlyForControllerEvent) {
      return hideOnlyFor(
        thisEvent.popupSpecs,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is TogglePopupControllerEvent) {
      return toggle(
        thisEvent.popupSpec,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else {
      throw 'Unknown PopupControllerEvent type: ${thisEvent.runtimeType}';
    }
  }
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
