import 'package:flutter_map_marker_popup/src/popup_spec.dart';

sealed class PopupEvent {
  const PopupEvent();
}

abstract class ShowedPopupsAlsoForEvent extends PopupEvent {
  List<PopupSpec> get popupSpecs;
  bool get disableAnimation;

  const ShowedPopupsAlsoForEvent();
}

abstract class ShowedPopupsOnlyForEvent extends PopupEvent {
  List<PopupSpec> get popupSpecs;
  bool get disableAnimation;

  const ShowedPopupsOnlyForEvent();
}

abstract class HidAllPopupsEvent extends PopupEvent {
  bool get disableAnimation;

  const HidAllPopupsEvent();
}

abstract class HidPopupsOnlyForEvent extends PopupEvent {
  List<PopupSpec> get popupSpecs;
  bool get disableAnimation;

  const HidPopupsOnlyForEvent();
}
