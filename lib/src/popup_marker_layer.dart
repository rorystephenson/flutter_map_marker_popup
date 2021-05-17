import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_marker_layer_options.dart';
import 'package:flutter_map_marker_popup/src/simple_popup_container.dart';

import 'animated_popup_container.dart';

class PopupMarkerLayerWidget extends StatelessWidget {
  final PopupMarkerLayerOptions options;

  PopupMarkerLayerWidget({Key key, @required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.of(context);
    return PopupMarkerLayer(options, mapState, mapState.onMoved);
  }
}

class PopupMarkerLayer extends StatelessWidget {
  /// For normal layer behaviour
  final PopupMarkerLayerOptions layerOpts;
  final MapState map;
  final Stream<Null> stream;

  PopupMarkerLayer(this.layerOpts, this.map, this.stream);

  bool _boundsContainsMarker(Marker marker) {
    final pixelPoint = map.project(marker.point);

    final width = marker.width - marker.anchor.left;
    final height = marker.height - marker.anchor.top;

    final sw = CustomPoint(pixelPoint.x + width, pixelPoint.y - height);
    final ne = CustomPoint(pixelPoint.x - width, pixelPoint.y + height);
    return map.pixelBounds.containsPartialBounds(Bounds(sw, ne));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: stream, // a Stream<int> or null
      builder: (BuildContext _, AsyncSnapshot<int> __) {
        var markers = <Widget>[];

        for (var markerOpt in layerOpts.markers) {
          if (!_boundsContainsMarker(markerOpt)) continue;

          final pos = map
                  .project(markerOpt.point)
                  .multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
              map.getPixelOrigin();

          final pixelPosX =
              (pos.x - (markerOpt.width - markerOpt.anchor.left)).toDouble();
          final pixelPosY =
              (pos.y - (markerOpt.height - markerOpt.anchor.top)).toDouble();

          markers.add(
            Positioned(
              width: markerOpt.width,
              height: markerOpt.height,
              left: pixelPosX,
              top: pixelPosY,
              child: GestureDetector(
                onTap: () => layerOpts.popupController.togglePopup(markerOpt),
                child: markerOpt.builder(context),
              ),
            ),
          );
        }

        markers.add(_popupContainer());

        return Container(
          child: Stack(
            children: markers,
          ),
        );
      },
    );
  }

  Widget _popupContainer() {
    if (layerOpts.popupAnimation.enabled) {
      return AnimatedPopupContainer(
        mapState: map,
        popupController: layerOpts.popupController,
        snap: layerOpts.popupSnap,
        popupBuilder: layerOpts.popupBuilder,
        popupAnimation: layerOpts.popupAnimation,
      );
    } else {
      return SimplePopupContainer(
        mapState: map,
        popupController: layerOpts.popupController,
        snap: layerOpts.popupSnap,
        popupBuilder: layerOpts.popupBuilder,
      );
    }
  }
}
