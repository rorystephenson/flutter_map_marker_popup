import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';

import 'popup_container/do_not_display_popup_container.dart';
import 'popup_controller_impl.dart';
import 'popup_event.dart';
import 'popup_state.dart';
import 'popup_state_impl.dart';

class PopupLayer extends StatefulWidget {
  final PopupState popupState;
  final PopupBuilder? popupBuilder;
  final PopupSnap popupSnap;
  final PopupController popupController;
  final PopupAnimation? popupAnimation;
  final bool markerRotate;
  final Function(PopupEvent event, List<Marker> selectedMarkers)? onPopupEvent;

  const PopupLayer({
    required this.popupState,
    required this.popupBuilder,
    required this.popupSnap,
    required PopupController popupController,
    this.popupAnimation,
    required this.markerRotate,
    this.onPopupEvent,
    Key? key,
  })  : popupController = popupController as PopupControllerImpl,
        super(key: key);

  @override
  State<PopupLayer> createState() => _PopupLayerState();
}

class _PopupLayerState extends State<PopupLayer> {
  PopupControllerImpl get _popupControllerImpl =>
      widget.popupController as PopupControllerImpl;

  PopupStateImpl get _popupStateImpl => widget.popupState as PopupStateImpl;

  @override
  void initState() {
    super.initState();

    _popupControllerImpl.streamController =
        StreamController<PopupEvent>.broadcast();
  }

  @override
  void didUpdateWidget(covariant PopupLayer oldWidget) {
    if (oldWidget.popupController != widget.popupController) {
      _popupControllerImpl.streamController =
          StreamController<PopupEvent>.broadcast();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _popupControllerImpl.streamController?.close();
    _popupControllerImpl.streamController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = FlutterMapState.maybeOf(context)!;
    final popupAnimation = widget.popupAnimation;

    if (widget.popupBuilder == null) {
      return DoNotDisplayPopupContainer(
        mapState: mapState,
        popupStateImpl: _popupStateImpl,
        popupControllerImpl: _popupControllerImpl,
        onPopupEvent: widget.onPopupEvent,
      );
    }

    if (popupAnimation == null) {
      return SimplePopupContainer(
        mapState: mapState,
        popupStateImpl: _popupStateImpl,
        popupControllerImpl: _popupControllerImpl,
        snap: widget.popupSnap,
        popupBuilder: widget.popupBuilder!,
        markerRotate: widget.markerRotate,
        onPopupEvent: widget.onPopupEvent,
      );
    } else {
      return AnimatedPopupContainer(
        mapState: mapState,
        popupStateImpl: _popupStateImpl,
        popupControllerImpl: _popupControllerImpl,
        snap: widget.popupSnap,
        popupBuilder: widget.popupBuilder!,
        popupAnimation: popupAnimation,
        markerRotate: widget.markerRotate,
        onPopupEvent: widget.onPopupEvent,
      );
    }
  }
}
