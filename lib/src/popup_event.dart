import 'package:flutter/foundation.dart';
import 'package:flutter_map/plugin_api.dart';

@immutable
abstract class PopupEvent {
  PopupEvent._();

  factory PopupEvent.hideAny() => HideAnyPopupEvent._();

  factory PopupEvent.toggle(Marker marker) => TogglePopupEvent._(marker);

  factory PopupEvent.show(Marker marker) => ShowPopupEvent._(marker);

  factory PopupEvent.hideInList(List<Marker> markers) =>
      HideInListPopupEvent._(markers);

  void handle({
    required void Function() hide,
    required void Function(Marker marker) toggle,
    required void Function(Marker marker) show,
    required void Function(List<Marker> markers) hideInList,
  }) {
    final thisEvent = this;
    if (thisEvent is HideAnyPopupEvent) {
      return hide();
    } else if (thisEvent is TogglePopupEvent) {
      return toggle(thisEvent.marker);
    } else if (thisEvent is ShowPopupEvent) {
      return show(thisEvent.marker);
    } else if (thisEvent is HideInListPopupEvent) {
      return hideInList(thisEvent.markers);
    } else {
      throw 'Unknown PopupEvent type: ${thisEvent.runtimeType}';
    }
  }
}

class HideAnyPopupEvent extends PopupEvent {
  HideAnyPopupEvent._() : super._();
}

class TogglePopupEvent extends PopupEvent {
  final Marker marker;

  TogglePopupEvent._(this.marker) : super._();
}

class ShowPopupEvent extends PopupEvent {
  final Marker marker;

  ShowPopupEvent._(this.marker) : super._();
}

class HideInListPopupEvent extends PopupEvent {
  final List<Marker> markers;

  HideInListPopupEvent._(this.markers) : super._();
}
