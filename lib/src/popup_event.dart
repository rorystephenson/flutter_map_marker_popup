import 'package:flutter/foundation.dart';
import 'package:flutter_map/plugin_api.dart';

@immutable
abstract class PopupEvent {
  PopupEvent._();

  factory PopupEvent.hideAny({required bool disableAnimation}) =>
      HideAnyPopupEvent._(
        disableAnimation: disableAnimation,
      );

  factory PopupEvent.toggle(Marker marker) => TogglePopupEvent._(marker);

  factory PopupEvent.show(Marker marker, {required bool disableAnimation}) =>
      ShowPopupEvent._(
        marker,
        disableAnimation: disableAnimation,
      );

  factory PopupEvent.hideInList(List<Marker> markers) =>
      HideInListPopupEvent._(markers);

  void handle({
    required void Function({required bool disableAnimation}) hide,
    required void Function(Marker marker) toggle,
    required void Function(Marker marker, {required bool disableAnimation})
        show,
    required void Function(List<Marker> markers) hideInList,
  }) {
    final thisEvent = this;
    if (thisEvent is HideAnyPopupEvent) {
      return hide(disableAnimation: thisEvent.disableAnimation);
    } else if (thisEvent is TogglePopupEvent) {
      return toggle(thisEvent.marker);
    } else if (thisEvent is ShowPopupEvent) {
      return show(
        thisEvent.marker,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is HideInListPopupEvent) {
      return hideInList(thisEvent.markers);
    } else {
      throw 'Unknown PopupEvent type: ${thisEvent.runtimeType}';
    }
  }
}

class HideAnyPopupEvent extends PopupEvent {
  final bool disableAnimation;

  HideAnyPopupEvent._({required this.disableAnimation}) : super._();
}

class TogglePopupEvent extends PopupEvent {
  final Marker marker;

  TogglePopupEvent._(this.marker) : super._();
}

class ShowPopupEvent extends PopupEvent {
  final Marker marker;
  final bool disableAnimation;

  ShowPopupEvent._(this.marker, {required this.disableAnimation}) : super._();
}

class HideInListPopupEvent extends PopupEvent {
  final List<Marker> markers;

  HideInListPopupEvent._(this.markers) : super._();
}
