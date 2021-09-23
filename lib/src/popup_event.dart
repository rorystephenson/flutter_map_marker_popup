import 'package:flutter/foundation.dart';
import 'package:flutter_map/plugin_api.dart';

@immutable
abstract class PopupEvent {
  const PopupEvent._();

  factory PopupEvent.showAlsoFor(
    List<Marker> markers, {
    required bool disableAnimation,
  }) =>
      ShowPopupsAlsoFor._(
        markers,
        disableAnimation: disableAnimation,
      );

  factory PopupEvent.showOnlyFor(
    List<Marker> markers, {
    required bool disableAnimation,
  }) =>
      ShowPopupsOnlyFor._(
        markers,
        disableAnimation: disableAnimation,
      );

  factory PopupEvent.hideAll({required bool disableAnimation}) =>
      HideAllPopupsEvent._(
        disableAnimation: disableAnimation,
      );

  factory PopupEvent.hideOnlyFor(
    List<Marker> markers, {
    required bool disableAnimation,
  }) =>
      HidePopupsOnlyFor._(markers, disableAnimation: disableAnimation);

  factory PopupEvent.toggle(Marker marker, {required bool disableAnimation}) =>
      TogglePopupEvent._(marker, disableAnimation: disableAnimation);

  void handle({
    required void Function(List<Marker> markers,
            {required bool disableAnimation})
        showAlsoFor,
    required void Function(List<Marker> markers,
            {required bool disableAnimation})
        showOnlyFor,
    required void Function({required bool disableAnimation}) hideAll,
    required void Function(List<Marker> markers,
            {required bool disableAnimation})
        hideOnlyFor,
    required void Function(Marker marker, {required bool disableAnimation})
        toggle,
  }) {
    final thisEvent = this;
    if (thisEvent is ShowPopupsAlsoFor) {
      return showAlsoFor(
        thisEvent.markers,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is ShowPopupsOnlyFor) {
      return showOnlyFor(
        thisEvent.markers,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is HideAllPopupsEvent) {
      return hideAll(disableAnimation: thisEvent.disableAnimation);
    } else if (thisEvent is HidePopupsOnlyFor) {
      return hideOnlyFor(
        thisEvent.markers,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is TogglePopupEvent) {
      return toggle(
        thisEvent.marker,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else {
      throw 'Unknown PopupEvent type: ${thisEvent.runtimeType}';
    }
  }
}

class ShowPopupsAlsoFor extends PopupEvent {
  final List<Marker> markers;
  final bool disableAnimation;

  const ShowPopupsAlsoFor._(
    this.markers, {
    required this.disableAnimation,
  }) : super._();
}

class ShowPopupsOnlyFor extends PopupEvent {
  final List<Marker> markers;
  final bool disableAnimation;

  const ShowPopupsOnlyFor._(
    this.markers, {
    required this.disableAnimation,
  }) : super._();
}

class HideAllPopupsEvent extends PopupEvent {
  final bool disableAnimation;

  const HideAllPopupsEvent._({required this.disableAnimation}) : super._();
}

class HidePopupsOnlyFor extends PopupEvent {
  final List<Marker> markers;
  final bool disableAnimation;

  const HidePopupsOnlyFor._(
    this.markers, {
    required this.disableAnimation,
  }) : super._();
}

class TogglePopupEvent extends PopupEvent {
  final Marker marker;
  final bool disableAnimation;

  const TogglePopupEvent._(this.marker, {required this.disableAnimation})
      : super._();
}
