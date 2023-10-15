import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_popup/src/state/popup_state_impl.dart';

/// PopupLayer displays the visible popups in the context's PopupState. It is
/// useful when you wish to display other widgets on top of markers but below
/// their popups or for plugins which manage markers themselves and only need
/// to display popups. This layer is a FlutterMap layer and therefore requires
/// MapController to be present in the build context.
///
/// If you just wish to show markers and popups with no widgets between them
/// use [PopupMarkerLayer].
///
/// Note that when using PopupLayer the PopupState must be available in the
/// BuildContext. See [PopupScope] for providing the state or
/// [PopupScope] if you are developing a package.
class PopupLayer extends StatelessWidget {
  final PopupDisplayOptions popupDisplayOptions;

  const PopupLayer({
    super.key,
    required this.popupDisplayOptions,
  });

  @override
  Widget build(BuildContext context) {
    final popupAnimation = popupDisplayOptions.animation;

    if (popupAnimation == null) {
      return SimplePopupContainer(
        mapCamera: MapCamera.of(context),
        popupStateImpl: PopupState.of(context) as PopupStateImpl,
        snap: popupDisplayOptions.snap,
        popupBuilder: popupDisplayOptions.builder,
      );
    } else {
      return AnimatedPopupContainer(
        mapCamera: MapCamera.of(context),
        popupStateImpl: PopupState.of(context) as PopupStateImpl,
        snap: popupDisplayOptions.snap,
        popupBuilder: popupDisplayOptions.builder,
        popupAnimation: popupAnimation,
      );
    }
  }
}
