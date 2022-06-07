import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';

import 'popup_controller_impl.dart';
import 'popup_event.dart';

class PopupLayer extends StatefulWidget {
  final MapState mapState;
  final Stream<void>? stream;
  final PopupBuilder popupBuilder;
  final PopupSnap popupSnap;
  final PopupControllerImpl popupController;
  final PopupAnimation? popupAnimation;
  final bool markerRotate;
  final Function(PopupEvent event, List<Marker> selectedMarkers)? onPopupEvent;

  const PopupLayer({
    required this.mapState,
    this.stream,
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
  _PopupLayerState createState() => _PopupLayerState();
}

class _PopupLayerState extends State<PopupLayer> {
  @override
  void initState() {
    super.initState();

    widget.popupController.streamController =
        StreamController<PopupEvent>.broadcast();
  }

  @override
  void didUpdateWidget(covariant PopupLayer oldWidget) {
    if (oldWidget.popupController != widget.popupController) {
      widget.popupController.streamController =
          StreamController<PopupEvent>.broadcast();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.popupController.streamController?.close();
    widget.popupController.streamController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: widget.stream,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        final popupAnimation = widget.popupAnimation;

        if (popupAnimation == null) {
          return SimplePopupContainer(
            mapState: widget.mapState,
            popupController: widget.popupController,
            snap: widget.popupSnap,
            popupBuilder: widget.popupBuilder,
            markerRotate: widget.markerRotate,
            onPopupEvent: widget.onPopupEvent,
          );
        } else {
          return AnimatedPopupContainer(
            mapState: widget.mapState,
            popupController: widget.popupController,
            snap: widget.popupSnap,
            popupBuilder: widget.popupBuilder,
            popupAnimation: popupAnimation,
            markerRotate: widget.markerRotate,
            onPopupEvent: widget.onPopupEvent,
          );
        }
      },
    );
  }
}
