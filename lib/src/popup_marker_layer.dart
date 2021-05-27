import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_container/simple_popup_container.dart';
import 'package:flutter_map_marker_popup/src/popup_marker_layer_options.dart';

import 'popup_container/animated_popup_container.dart';
import 'popup_event.dart';

class PopupMarkerLayerWidget extends StatelessWidget {
  final PopupMarkerLayerOptions options;

  PopupMarkerLayerWidget({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;
    return PopupMarkerLayer(options, mapState, mapState.onMoved);
  }
}

class PopupMarkerLayer extends StatefulWidget {
  final PopupMarkerLayerOptions layerOptions;
  final MapState map;
  final Stream<Null>? stream;

  PopupMarkerLayer(this.layerOptions, this.map, this.stream)
      : super(key: layerOptions.key);

  @override
  _PopupMarkerLayerState createState() => _PopupMarkerLayerState();
}

class _PopupMarkerLayerState extends State<PopupMarkerLayer> {
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

    widget.layerOptions.popupController.streamController =
        StreamController<PopupEvent>.broadcast();
  }

  @override
  void didUpdateWidget(covariant PopupMarkerLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    lastZoom = -1.0;
    _pxCache = generatePxCache();
  }

  @override
  void dispose() {
    widget.layerOptions.popupController.streamController!.close();
    super.dispose();
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
            onTap: () =>
                widget.layerOptions.popupController.togglePopup(marker),
            child: marker.builder(context),
          );

          final markerRotate = widget.layerOptions.markerAndPopupRotate;

          Widget markerWidget;
          if (marker.rotate ?? markerRotate) {
            final markerRotateOrigin =
                marker.rotateOrigin ?? widget.layerOptions.markerRotateOrigin;
            final markerRotateAlignment = marker.rotateAlignment ??
                widget.layerOptions.markerRotateAlignment;

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

        /// Add the popup.
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
    final popupAnimation = widget.layerOptions.popupAnimation;

    if (popupAnimation == null) {
      return SimplePopupContainer(
        mapState: widget.map,
        popupController: widget.layerOptions.popupController,
        snap: widget.layerOptions.popupSnap,
        popupBuilder: widget.layerOptions.popupBuilder,
        markerRotate: widget.layerOptions.markerAndPopupRotate,
      );
    } else {
      return AnimatedPopupContainer(
        mapState: widget.map,
        popupController: widget.layerOptions.popupController,
        snap: widget.layerOptions.popupSnap,
        popupBuilder: widget.layerOptions.popupBuilder,
        popupAnimation: popupAnimation,
        markerRotate: widget.layerOptions.markerAndPopupRotate,
      );
    }
  }
}
