import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

/// This allows a popup instance to maintain state until it is closed, even when
/// it goes off screen.
class MarkerWithKey {
  final Key key;
  final Marker marker;

  MarkerWithKey(this.marker) : key = GlobalKey();

  static MarkerWithKey wrap(Marker marker) => MarkerWithKey(marker);

  static Marker unwrap(MarkerWithKey markerWithKey) => markerWithKey.marker;

  @override
  bool operator ==(Object other) =>
      other is MarkerWithKey && marker == other.marker;

  @override
  int get hashCode => marker.hashCode;
}
