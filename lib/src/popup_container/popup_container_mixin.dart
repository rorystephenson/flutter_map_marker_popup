import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/layout/popup_layout.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event_impl.dart';
import 'package:flutter_map_marker_popup/src/state/popup_state_impl.dart';

mixin PopupContainerMixin {
  FlutterMapState get mapState;

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
      mapState: mapState,
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
    return event.handle(
      showedAlsoFor: showPopupsAlsoFor,
      showedOnlyFor: showPopupsOnlyFor,
      hidAll: hideAllPopups,
      hidOnlyFor: hidePopupsOnlyFor,
    );
  }

  void showPopupsAlsoFor(
    List<PopupSpec> popupSpecs, {
    required bool disableAnimation,
  });

  void showPopupsOnlyFor(
    List<PopupSpec> popupSpecs, {
    required bool disableAnimation,
  });

  void hideAllPopups({required bool disableAnimation});

  void hidePopupsOnlyFor(
    List<PopupSpec> popupSpecs, {
    required bool disableAnimation,
  });
}
