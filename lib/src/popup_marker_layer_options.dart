import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/popup_layer_controller.dart';

class PopupMarkerLayerOptions<T> extends LayerOptions {
  final PopupLayerController<T> popupLayerController;

  final Widget Function(BuildContext context, T uuid) popupBuilder;
  final double popupWidth;
  final double popupHeight;

  final Anchor anchor;

  PopupMarkerLayerOptions({
    rebuild,
    @required this.popupLayerController,
    @required this.popupBuilder,
    @required this.popupWidth,
    @required this.popupHeight,
    Anchor anchor,
    popupVerticalOffset: 0.0,
    popupHorizontalOffset: 0.0,
  })  : this.anchor = Anchor.forPos(
          AnchorPos.exactly(
            Anchor(
              popupHorizontalOffset + (popupWidth / 2),
              popupVerticalOffset,
            ),
          ),
          popupWidth,
          popupHeight,
        ),
        super(rebuild: rebuild);
}
