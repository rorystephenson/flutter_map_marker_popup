import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:provider/provider.dart';

import '../flutter_map_marker_popup.dart';
import 'lat_lng_tween.dart';

class MarkerLayer extends StatefulWidget {
  final PopupMarkerLayerOptions layerOptions;
  final FlutterMapState map;
  final PopupState popupState;
  final PopupController popupController;

  const MarkerLayer({
    Key? key,
    required this.layerOptions,
    required this.map,
    required this.popupState,
    required this.popupController,
  }) : super(key: key);

  @override
  State<MarkerLayer> createState() => _MarkerLayerState();
}

class _MarkerLayerState extends State<MarkerLayer>
    with SingleTickerProviderStateMixin {
  var lastZoom = -1.0;

  /// List containing cached pixel positions of markers
  /// Should be discarded when zoom changes
  // Has a fixed length of markerOpts.markers.length - better performance:
  // https://stackoverflow.com/questions/15943890/is-there-a-performance-benefit-in-using-fixed-length-lists-in-dart
  var _pxCache = <CustomPoint>[];

  late AnimationController _centerMarkerController;
  void Function()? _animationListener;

  // Calling this every time markerOpts change should guarantee proper length
  List<CustomPoint> generatePxCache() => List.generate(
        widget.layerOptions.markers.length,
        (i) => widget.map.project(widget.layerOptions.markers[i].point),
      );

  @override
  void initState() {
    super.initState();
    _pxCache = generatePxCache();
    _centerMarkerController = AnimationController(
      vsync: this,
      duration: widget.layerOptions.markerCenterAnimation?.duration,
    );
  }

  @override
  void didUpdateWidget(covariant MarkerLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    lastZoom = -1.0;
    _pxCache = generatePxCache();
    _centerMarkerController.duration =
        widget.layerOptions.markerCenterAnimation?.duration;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layerOptions.selectedMarkerBuilder != null) {
      context.watch<PopupState>();
    }
    var markers = <Widget>[];
    final sameZoom = widget.map.zoom == lastZoom;
    for (var i = 0; i < widget.layerOptions.markers.length; i++) {
      var marker = widget.layerOptions.markers[i];

      // Decide whether to use cached point or calculate it
      var pxPoint = sameZoom ? _pxCache[i] : widget.map.project(marker.point);
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

      final pos = pxPoint - widget.map.pixelOrigin;

      var markerBuilder = marker.builder;
      if (widget.layerOptions.selectedMarkerBuilder != null &&
          widget.popupState.isSelected(marker)) {
        markerBuilder = (context) =>
            widget.layerOptions.selectedMarkerBuilder!(context, marker);
      }
      final markerWithGestureDetector = GestureDetector(
        onTap: () {
          if (!widget.popupState.selectedMarkers.contains(marker)) {
            _centerMarker(marker);
          }

          widget.layerOptions.markerTapBehavior.apply(
            PopupSpec.wrap(marker),
            widget.popupState,
            widget.popupController,
          );
        },
        child: markerBuilder(context),
      );

      Widget markerWidget;
      if (marker.rotate == true) {
        final markerRotateOrigin = marker.rotateOrigin;
        final markerRotateAlignment = marker.rotateAlignment;

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

    return Stack(children: markers);
  }

  void _centerMarker(Marker marker) {
    final markerLayerAnimation = widget.layerOptions.markerCenterAnimation;
    if (markerLayerAnimation == null) return;

    final center = widget.map.center;
    final tween = LatLngTween(begin: center, end: marker.point);

    Animation<double> animation = CurvedAnimation(
      parent: _centerMarkerController,
      curve: markerLayerAnimation.curve,
    );

    void listener() {
      widget.map.move(
        tween.evaluate(animation),
        widget.map.zoom,
        source: MapEventSource.custom,
      );
    }

    _centerMarkerController.removeListener(_animationListener ?? () {});
    _centerMarkerController.reset();
    _animationListener = listener;

    _centerMarkerController.addListener(listener);
    _centerMarkerController.forward().then((_) {
      _centerMarkerController
        ..removeListener(listener)
        ..reset();
      _animationListener = null;
    });
  }

  @override
  void dispose() {
    _centerMarkerController.dispose();
    super.dispose();
  }
}
