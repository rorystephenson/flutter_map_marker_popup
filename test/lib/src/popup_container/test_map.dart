import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import '../../../test_wrapped_marker.dart';

class TestMap extends StatelessWidget {
  final PopupController? popupController;
  final PopupAnimation? popupAnimation;

  TestMap({
    super.key,
    this.popupController,
    this.popupAnimation,
  });

  final _markers = [markerA, markerB];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterMap(
        options: MapOptions(center: markerA.point),
        children: [
          PopupMarkerLayerWidget(
            options: PopupMarkerLayerOptions(
              popupController: popupController,
              popupAnimation: popupAnimation,
              markers: _markers,
              markerRotateAlignment:
                  PopupMarkerLayerOptions.rotationAlignmentFor(
                AnchorAlign.top,
              ),
              popupBuilder: (BuildContext context, Marker marker) => Container(
                color: Colors.white,
                child: Text(_markerText(marker)),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _markerText(Marker marker) {
    if (marker == markerA || marker == wrappedMarkerA) {
      return 'popupA';
    } else if (marker == markerB || marker == wrappedMarkerB) {
      return 'popupB';
    } else {
      throw 'Unexpected marker';
    }
  }
}
