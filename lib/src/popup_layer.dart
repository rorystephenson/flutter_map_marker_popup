import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:flutter_map_marker_popup/src/popup_container/simple_popup_container.dart';

import 'popup_container/animated_popup_container.dart';
import 'popup_event.dart';

class PopupLayer extends StatefulWidget {
  final MapState mapState;

  // Forced by flutter_map
  // ignore: prefer_void_to_null
  final Stream<Null>? stream;
  final PopupBuilder popupBuilder;
  final PopupSnap popupSnap;
  final PopupController popupController;
  final PopupAnimation? popupAnimation;
  final bool markerRotate;

  const PopupLayer({
    required this.mapState,
    this.stream,
    required this.popupBuilder,
    required this.popupSnap,
    required this.popupController,
    this.popupAnimation,
    required this.markerRotate,
    Key? key,
  }) : super(key: key);

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
  void dispose() {
    widget.popupController.streamController?.close();
    widget.popupController.streamController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
      stream: widget.stream, // a Stream<int> or null
      builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
        final popupAnimation = widget.popupAnimation;

        if (popupAnimation == null) {
          return SimplePopupContainer(
            mapState: widget.mapState,
            popupController: widget.popupController,
            snap: widget.popupSnap,
            popupBuilder: widget.popupBuilder,
            markerRotate: widget.markerRotate,
          );
        } else {
          return AnimatedPopupContainer(
            mapState: widget.mapState,
            popupController: widget.popupController,
            snap: widget.popupSnap,
            popupBuilder: widget.popupBuilder,
            popupAnimation: popupAnimation,
            markerRotate: widget.markerRotate,
          );
        }
      },
    );
  }
}
