import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event.dart';

extension PopupEventExtension on PopupEvent {
  void handle({
    required void Function(
      List<PopupSpec> popupSpecs, {
      required bool disableAnimation,
    })
        showedAlsoFor,
    required void Function(
      List<PopupSpec> popupSpecs, {
      required bool disableAnimation,
    })
        showedOnlyFor,
    required void Function({
      required bool disableAnimation,
    })
        hidAll,
    required void Function(
      List<PopupSpec> popupSpecs, {
      required bool disableAnimation,
    })
        hidOnlyFor,
  }) {
    final thisEvent = this;
    if (thisEvent is ShowedPopupsAlsoForImpl) {
      return showedAlsoFor(
        thisEvent.popupSpecs,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is ShowedPopupsOnlyForImpl) {
      return showedOnlyFor(
        thisEvent.popupSpecs,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else if (thisEvent is HidAllPopupsImpl) {
      return hidAll(disableAnimation: thisEvent.disableAnimation);
    } else if (thisEvent is HidPopupsOnlyForImpl) {
      return hidOnlyFor(
        thisEvent.popupSpecs,
        disableAnimation: thisEvent.disableAnimation,
      );
    } else {
      throw 'Unknown PopupEvent type: ${thisEvent.runtimeType}';
    }
  }
}

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
