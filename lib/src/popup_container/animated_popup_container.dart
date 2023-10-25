import 'dart:async';

import 'package:animated_stack_widget/animated_stack_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/popup_animation.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_container/popup_container_mixin.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event.dart';
import 'package:flutter_map_marker_popup/src/state/popup_state_impl.dart';

class AnimatedPopupContainer extends StatefulWidget {
  final MapCamera mapCamera;
  final PopupStateImpl popupStateImpl;
  final PopupBuilder popupBuilder;
  final PopupSnap snap;
  final PopupAnimation popupAnimation;

  const AnimatedPopupContainer({
    required this.mapCamera,
    required this.popupStateImpl,
    required this.snap,
    required this.popupBuilder,
    required this.popupAnimation,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AnimatedPopupContainerState();
}

class _AnimatedPopupContainerState extends State<AnimatedPopupContainer>
    with PopupContainerMixin {
  @override
  MapCamera get mapCamera => widget.mapCamera;

  @override
  PopupStateImpl get popupStateImpl => widget.popupStateImpl;

  @override
  PopupSnap get snap => widget.snap;

  final GlobalKey<AnimatedStackState> _animatedStackKey =
      GlobalKey<AnimatedStackState>();

  late AnimatedStackManager<PopupSpec> _animatedStackManager;
  late StreamSubscription<PopupEvent> _popupStateEventSubscription;

  _AnimatedPopupContainerState();

  @override
  void initState() {
    super.initState();

    _animatedStackManager = AnimatedStackManager<PopupSpec>(
      animatedStackKey: _animatedStackKey,
      removedItemBuilder: (marker, _, animation) =>
          _buildPopup(marker, animation, allowTap: false),
      duration: widget.popupAnimation.duration,
      initialItems: widget.popupStateImpl.selectedMarkers.map(PopupSpec.wrap),
    );
    _popupStateEventSubscription =
        widget.popupStateImpl.stream.listen(handleEvent);
  }

  @override
  void didUpdateWidget(covariant AnimatedPopupContainer oldWidget) {
    if (oldWidget.popupStateImpl != widget.popupStateImpl) {
      _popupStateEventSubscription.cancel();
      _popupStateEventSubscription =
          widget.popupStateImpl.stream.listen(handleEvent);

      _animatedStackManager.clear(duration: Duration.zero);
      for (final selectedPopupSpec
          in widget.popupStateImpl.selectedPopupSpecs) {
        _animatedStackManager.insert(
          _animatedStackManager.length - 1,
          selectedPopupSpec,
          duration: Duration.zero,
        );
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _popupStateEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: MobileLayerTransformer(
        child: AnimatedStack(
          initialItemCount: _animatedStackManager.length,
          key: _animatedStackKey,
          itemBuilder: (context, index, animation) => _buildPopup(
            _animatedStackManager[index],
            animation,
          ),
        ),
      ),
    );
  }

  Widget _buildPopup(
    PopupSpec popupSpec,
    Animation<double> animation, {
    bool allowTap = true,
  }) {
    Widget animatedPopup = AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
      child: popupWithStateKeepAlive(popupSpec, widget.popupBuilder),
    );

    if (!allowTap) animatedPopup = IgnorePointer(child: animatedPopup);

    return inPosition(popupSpec, animatedPopup);
  }

  @override
  void showPopupsAlsoFor(ShowedPopupsAlsoForEvent event) {
    for (final popupSpec in event.popupSpecs) {
      if (!_animatedStackManager.contains(popupSpec)) {
        _animatedStackManager.insert(
          _animatedStackManager.length,
          popupSpec,
          duration: event.disableAnimation ? Duration.zero : null,
        );
      }
    }
  }

  @override
  void showPopupsOnlyFor(ShowedPopupsOnlyForEvent event) {
    _animatedStackManager.removeWhere(
      (popupSpec) => !event.popupSpecs.contains(popupSpec),
      duration: event.disableAnimation ? Duration.zero : null,
    );
    for (final popupSpec in event.popupSpecs) {
      if (!_animatedStackManager.contains(popupSpec)) {
        _animatedStackManager.insert(
          _animatedStackManager.length,
          popupSpec,
          duration: event.disableAnimation ? Duration.zero : null,
        );
      }
    }
  }

  @override
  void hideAllPopups(HidAllPopupsEvent event) {
    if (_animatedStackManager.isNotEmpty) {
      _animatedStackManager.clear(
        duration: event.disableAnimation ? Duration.zero : null,
      );
    }
  }

  @override
  void hidePopupsOnlyFor(HidPopupsOnlyForEvent event) {
    _animatedStackManager.removeWhere(
      (popupSpec) => event.popupSpecs.contains(popupSpec),
      duration: event.disableAnimation ? Duration.zero : null,
    );
  }
}
