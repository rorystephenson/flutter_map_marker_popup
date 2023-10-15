import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:latlong2/latlong.dart';

final markerA = Marker(
  child: Container(
    color: Colors.blue,
    child: const Text('markerA'),
  ),
  point: const LatLng(40.0, 10.0),
);

final popupSpecA = PopupSpec.wrap(markerA);

final wrappedMarkerA = TestWrappedMarker(markerA);

final markerB = Marker(
  child: Container(
    color: Colors.green,
    child: const Text('markerB'),
  ),
  point: const LatLng(40.1, 10.1),
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
  Alignment? get alignment => marker.alignment;

  @override
  Widget get child => marker.child;

  @override
  double get height => marker.height;

  @override
  Key? get key => marker.key;

  @override
  LatLng get point => marker.point;

  @override
  bool? get rotate => marker.rotate;

  @override
  double get width => marker.width;
}
