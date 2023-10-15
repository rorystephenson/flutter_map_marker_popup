import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/layout/popup_layout.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event.dart';
import 'package:flutter_map_marker_popup/src/state/popup_state_impl.dart';

mixin PopupContainerMixin {
  MapCamera get mapCamera;

  PopupStateImpl get popupStateImpl;

  PopupSnap get snap;

  @nonVirtual
  Widget inPosition(PopupSpec popupSpec, Widget popup) {
    final layout = popupLayout(popupSpec);

    return Positioned.fill(
      child: Transform(
        alignment: layout.rotationAlignment,
        transform: layout.transformationMatrix,
        child: Align(
          alignment: layout.contentAlignment,
          child: popup,
        ),
      ),
    );
  }

  @nonVirtual
  PopupLayout popupLayout(PopupSpec popupSpec) {
    return PopupLayout.calculate(
      mapCamera: mapCamera,
      popupSpec: popupSpec,
      snap: snap,
    );
  }

  /// This makes sure that the state of the popup stays with the popup even if
  /// it goes off screen or changes position in the widget tree.
  @nonVirtual
  Widget popupWithStateKeepAlive(
    PopupSpec popupSpec,
    Widget Function(BuildContext, Marker) popupBuilder,
  ) {
    return Builder(
      key: popupSpec.key,
      builder: (context) => popupBuilder(
        context,
        popupSpec.marker,
      ),
    );
  }

  @nonVirtual
  void handleEvent(PopupEvent event) {
    switch (event) {
      case ShowedPopupsAlsoForEvent():
        showPopupsAlsoFor(event);
      case ShowedPopupsOnlyForEvent():
        showPopupsOnlyFor(event);
      case HidAllPopupsEvent():
        hideAllPopups(event);
      case HidPopupsOnlyForEvent():
        hidePopupsOnlyFor(event);
    }
  }

  void showPopupsAlsoFor(ShowedPopupsAlsoForEvent event);

  void showPopupsOnlyFor(ShowedPopupsOnlyForEvent event);

  void hideAllPopups(HidAllPopupsEvent event);

  void hidePopupsOnlyFor(HidPopupsOnlyForEvent event);
}
