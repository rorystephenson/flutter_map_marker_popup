import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';

import '../flutter_map_marker_popup.dart';

class MarkerLayer extends StatefulWidget {
  final MarkerLayerOptions layerOptions;

  final MapState map;

  final Stream<Null>? stream;

  final PopupController popupController;

  MarkerLayer(
    this.layerOptions,
    this.map,
    this.stream,
    this.popupController, {
    Key? key,
  }) : super(key: key);

  @override
  _MarkerLayerState createState() => _MarkerLayerState();
}

class _MarkerLayerState extends State<MarkerLayer> {
  var lastZoom = -1.0;

  /// List containing cached pixel positions of markers
  /// Should be discarded when zoom changes
  // Has a fixed length of markerOpts.markers.length - better performance:
  // https://stackoverflow.com/questions/15943890/is-there-a-performance-benefit-in-using-fixed-length-lists-in-dart
  var _pxCache = <CustomPoint>[];

  // Calling this every time markerOpts change should guarantee proper length
  List<CustomPoint> generatePxCache() => List.generate(
        widget.layerOptions.markers.length,
        (i) => widget.map.project(widget.layerOptions.markers[i].point),
      );

  @override
  void initState() {
    super.initState();
    _pxCache = generatePxCache();
  }

  @override
  void didUpdateWidget(covariant MarkerLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    lastZoom = -1.0;
    _pxCache = generatePxCache();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
      stream: widget.stream, // a Stream<int> or null
      builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
        var markers = <Widget>[];
        final sameZoom = widget.map.zoom == lastZoom;
        for (var i = 0; i < widget.layerOptions.markers.length; i++) {
          var marker = widget.layerOptions.markers[i];

          // Decide whether to use cached point or calculate it
          var pxPoint =
              sameZoom ? _pxCache[i] : widget.map.project(marker.point);
          if (!sameZoom) {
            _pxCache[i] = pxPoint;
          }

          final width = marker.width - marker.anchor.left;
          final height = marker.height - marker.anchor.top;
          var sw = CustomPoint(pxPoint.x + width, pxPoint.y - height);
          var ne = CustomPoint(pxPoint.x - width, pxPoint.y + height);

          if (!widget.map.pixelBounds.containsPartialBounds(Bounds(sw, ne))) {
            continue;
          }

          final pos = pxPoint - widget.map.getPixelOrigin();

          final markerWithGestureDetector = GestureDetector(
            onTap: () => widget.popupController.togglePopup(marker),
            child: marker.builder(context),
          );

          final markerRotate = widget.layerOptions.rotate;

          Widget markerWidget;
          if (marker.rotate ?? markerRotate ?? false) {
            final markerRotateOrigin =
                marker.rotateOrigin ?? widget.layerOptions.rotateOrigin;
            final markerRotateAlignment =
                marker.rotateAlignment ?? widget.layerOptions.rotateAlignment;

            // Counter rotated marker to the map rotation
            markerWidget = Transform.rotate(
              angle: -widget.map.rotationRad,
              origin: markerRotateOrigin,
              alignment: markerRotateAlignment,
              child: markerWithGestureDetector,
            );
          } else {
            markerWidget = markerWithGestureDetector;
          }

          markers.add(
            Positioned(
              key: marker.key,
              width: marker.width,
              height: marker.height,
              left: pos.x - width,
              top: pos.y - height,
              child: markerWidget,
            ),
          );
        }
        lastZoom = widget.map.zoom;

        return Container(
          child: Stack(
            children: markers,
          ),
        );
      },
    );
  }
}
