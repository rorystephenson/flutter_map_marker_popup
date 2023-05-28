import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:latlong2/latlong.dart';

final markerA = Marker(
  builder: (context) => Container(
    color: Colors.blue,
    child: const Text('markerA'),
  ),
  point: LatLng(40.0, 10.0),
);

final popupSpecA = PopupSpec.wrap(markerA);

final wrappedMarkerA = TestWrappedMarker(markerA);

final markerB = Marker(
  builder: (context) => Container(
    color: Colors.green,
    child: const Text('markerB'),
  ),
  point: LatLng(40.1, 10.1),
);

final popupSpecB = PopupSpec.wrap(markerB);

final wrappedMarkerB = TestWrappedMarker(markerB);

class TestWrappedMarker implements Marker {
  final Marker marker;

  const TestWrappedMarker(this.marker);

  @override
  bool operator ==(Object other) =>
      other is TestWrappedMarker && marker.hashCode == other.marker.hashCode;

  @override
  int get hashCode => marker.hashCode;

  @override
  Anchor get anchor => marker.anchor;

  @override
  WidgetBuilder get builder => marker.builder;

  @override
  double get height => marker.height;

  @override
  Key? get key => marker.key;

  @override
  LatLng get point => marker.point;

  @override
  bool? get rotate => marker.rotate;

  @override
  AlignmentGeometry? get rotateAlignment => marker.rotateAlignment;

  @override
  Offset? get rotateOrigin => marker.rotateOrigin;

  @override
  double get width => marker.width;
}
