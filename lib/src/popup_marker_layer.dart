import 'package:flutter/material.dart';

import 'package:flutter_map/plugin_api.dart';

import 'package:flutter_map_marker_popup/src/map_popup.dart';
import 'package:flutter_map_marker_popup/src/popup_layer_controller.dart';
import 'package:flutter_map_marker_popup/src/popup_marker_layer_options.dart';

class PopupMarkerLayer<T> extends StatelessWidget {
  final PopupLayerController<T> _popupLayerController;
  final MapState map;
  final Stream<Null> stream;

  final Widget Function(BuildContext context, T uuid) popupBuilder;
  final double popupWidth;
  final double popupHeight;
  final Anchor anchor;

  PopupMarkerLayer(
      PopupMarkerLayerOptions<T> popupMarkerLayerOptions, this.map, this.stream)
      : this._popupLayerController =
            popupMarkerLayerOptions.popupLayerController,
        this.popupBuilder = popupMarkerLayerOptions.popupBuilder,
        this.popupWidth = popupMarkerLayerOptions.popupWidth,
        this.popupHeight = popupMarkerLayerOptions.popupHeight,
        this.anchor = popupMarkerLayerOptions.anchor;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: stream, // a Stream<int> or null
      builder: (_, __) {
        return StreamBuilder<MapPopup<T>>(
          stream: _popupLayerController.popupStream,
          builder: (context, snapshot) {
            Positioned popupWidget;

            MapPopup<T> popup = snapshot.hasData ? snapshot.data : null;

            if (popup != null) {
              var pos = map.project(popup.point);

              pos = pos.multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
                  map.getPixelOrigin();

              var pixelPosX = (pos.x - (popupWidth - anchor.left)).toDouble();
              var pixelPosY = (pos.y - (popupHeight - anchor.top)).toDouble();

              popupWidget = Positioned(
                width: popupWidth,
                height: popupHeight,
                left: pixelPosX,
                top: pixelPosY,
                child: popupBuilder(context, popup.uuid),
              );
            }

            return Container(
              child: Stack(
                children: popupWidget == null ? [] : [popupWidget],
              ),
            );
          },
        );
      },
    );
  }
}
