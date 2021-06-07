import 'dart:async';

import 'package:animated_stack_widget/animated_stack_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_animation.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_container/popup_container_mixin.dart';
import 'package:flutter_map_marker_popup/src/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/popup_event.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import 'marker_with_key.dart';

class AnimatedPopupContainer extends StatefulWidget {
  final PopupController popupController;
  final PopupBuilder popupBuilder;
  final PopupSnap snap;
  final MapState mapState;
  final PopupAnimation popupAnimation;
  final bool markerRotate;

  AnimatedPopupContainer({
    required this.mapState,
    required this.popupController,
    required this.snap,
    required this.popupBuilder,
    required this.popupAnimation,
    required this.markerRotate,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedPopupContainerState();
}

class _AnimatedPopupContainerState extends State<AnimatedPopupContainer>
    with PopupContainerMixin {
  @override
  MapState get mapState => widget.mapState;

  @override
  PopupController get popupController => widget.popupController;

  @override
  PopupSnap get snap => widget.snap;

  @override
  bool get markerRotate => widget.markerRotate;

  final GlobalKey<AnimatedStackState> _animatedStackKey =
      GlobalKey<AnimatedStackState>();

  late AnimatedStackManager<MarkerWithKey> _animatedStackManager;
  late StreamSubscription<PopupEvent> _popupEventSubscription;

  _AnimatedPopupContainerState();

  @override
  void initState() {
    super.initState();

    final selectedMarkerWithKey = popupController.selectedMarkerWithKey;

    _animatedStackManager = AnimatedStackManager<MarkerWithKey>(
      animatedStackKey: _animatedStackKey,
      removedItemBuilder: (marker, _, animation) =>
          _buildPopup(marker, animation, allowTap: false),
      duration: widget.popupAnimation.duration,
      initialItems:
          selectedMarkerWithKey == null ? [] : [selectedMarkerWithKey],
    );
    _popupEventSubscription = widget.popupController.streamController!.stream
        .listen((PopupEvent popupEvent) => handleAction(popupEvent));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedStack(
        initialItemCount: _animatedStackManager.length,
        key: _animatedStackKey,
        itemBuilder: (context, index, animation) => _buildPopup(
          _animatedStackManager[index],
          animation,
        ),
      ),
    );
  }

  Widget _buildPopup(
    MarkerWithKey markerWithKey,
    Animation<double> animation, {
    bool allowTap = true,
  }) {
    Widget animatedPopup = FadeTransition(
      opacity: animation.drive(CurveTween(curve: widget.popupAnimation.curve)),
      child: popupWithStateKeepAlive(markerWithKey, widget.popupBuilder),
    );

    if (!allowTap) animatedPopup = IgnorePointer(child: animatedPopup);

    return inPosition(markerWithKey.marker, animatedPopup);
  }

  @override
  void hideAny({required bool disableAnimation}) {
    if (_animatedStackManager.isNotEmpty) {
      _animatedStackManager.clear(
          duration: disableAnimation ? Duration.zero : null);
    }
  }

  @override
  void showForMarker(
    MarkerWithKey markerWithKey, {
    required bool disableAnimation,
  }) {
    if (!markerIsVisible(markerWithKey.marker)) {
      hideAny(disableAnimation: disableAnimation);
      _animatedStackManager.insert(
        0,
        markerWithKey,
        duration: disableAnimation ? Duration.zero : null,
      );
    }
  }

  @override
  bool markerIsVisible(Marker marker) =>
      _animatedStackManager.length > 0 &&
      _animatedStackManager[0].marker == marker;

  @override
  void dispose() {
    _popupEventSubscription.cancel();
    super.dispose();
  }
}
