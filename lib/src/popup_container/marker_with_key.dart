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

  // Uses the hashCode for equals comparison to allow Marker extensions to be
  // considered equal to a normal Marker by overriding their hashCode to equal
  // the hashCode of their container Marker. This is useful for FlutterMap
  // plugins that need to wrap Markers with their own data but still have them
  // match the user provided markers.
  @override
  bool operator ==(Object other) =>
      other is MarkerWithKey && marker.hashCode == other.marker.hashCode;

  @override
  int get hashCode => marker.hashCode;
}
