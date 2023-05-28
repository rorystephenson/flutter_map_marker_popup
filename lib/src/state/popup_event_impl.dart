import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event.dart';

class ShowedPopupsAlsoForImpl implements ShowedPopupsAlsoForEvent {
  @override
  final List<PopupSpec> popupSpecs;
  @override
  final bool disableAnimation;

  const ShowedPopupsAlsoForImpl(
    this.popupSpecs, {
    required this.disableAnimation,
  });
}

class ShowedPopupsOnlyForImpl implements ShowedPopupsOnlyForEvent {
  @override
  final List<PopupSpec> popupSpecs;
  @override
  final bool disableAnimation;

  const ShowedPopupsOnlyForImpl(
    this.popupSpecs, {
    required this.disableAnimation,
  });
}

class HidAllPopupsImpl implements HidAllPopupsEvent {
  @override
  final bool disableAnimation;

  const HidAllPopupsImpl({required this.disableAnimation});
}

class HidPopupsOnlyForImpl extends HidPopupsOnlyForEvent {
  @override
  final List<PopupSpec> popupSpecs;
  @override
  final bool disableAnimation;

  const HidPopupsOnlyForImpl(
    this.popupSpecs, {
    required this.disableAnimation,
  });
}
