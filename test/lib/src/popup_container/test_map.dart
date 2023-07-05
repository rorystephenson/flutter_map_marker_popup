import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/controller/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/options/popup_display_options.dart';
import 'package:flutter_map_marker_popup/src/options/popup_marker_layer_options.dart';
import 'package:flutter_map_marker_popup/src/popup_animation.dart';
import 'package:flutter_map_marker_popup/src/popup_marker_layer.dart';

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
        options: MapOptions(initialCenter: markerA.point),
        children: [
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              popupController: popupController,
              popupDisplayOptions: PopupDisplayOptions(
                animation: popupAnimation,
                builder: (BuildContext context, Marker marker) => Container(
                  color: Colors.white,
                  child: Text(_markerText(marker)),
                ),
              ),
              markers: _markers,
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
