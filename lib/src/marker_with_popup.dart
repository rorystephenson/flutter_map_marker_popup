import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MarkerWithPopup extends Marker {
  final dynamic uuid;

  MarkerWithPopup({
    @required this.uuid,
    @required builder,
    @required Function(BuildContext, dynamic, LatLng) showMarker,
    LatLng point,
    double width,
    double height,
    AnchorPos anchorPos,
  }) : super(
          point: point,
          width: width,
          height: height,
          anchorPos: anchorPos,
          builder: _popupMarkerBuilder(builder, uuid, point, showMarker),
        );

  static WidgetBuilder _popupMarkerBuilder(WidgetBuilder builder, dynamic uuid,
      LatLng point, Function(BuildContext, dynamic, LatLng) showMarker) {
    return (BuildContext context) => GestureDetector(
          onTap: () => showMarker(context, uuid, point),
          child: builder(context),
        );
  }
}
