import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Contains the data relevant for constructing a popup.
class PopupSpec {
  /// Used internally to maintain the popup's state when it is off-screen.
  final Key key;

  /// The Marker for which this popup should be shown.
  final Marker marker;

  /// If set this popup will removed when the map zoom rounded up to the
  /// nearest int is less than this value.
  final int? removeIfZoomLessThan;

  final String? namespace;

  /// Override the marker's point. This will only affect popup placement when
  /// using a marker snap.
  final LatLng? markerPointOverride;

  /// Override the marker's anchor. This will only affect popup placement when
  /// using a marker snap.
  final Alignment? markerAlignmentOverride;

  PopupSpec({
    required this.marker,
    this.removeIfZoomLessThan,
    this.namespace,
    this.markerPointOverride,
    this.markerAlignmentOverride,
  }) : key = GlobalKey();

  /// A convenience constructor for creating a PopupSpec without setting
  /// optional fields.
  PopupSpec.wrap(this.marker)
      : key = GlobalKey(),
        removeIfZoomLessThan = null,
        namespace = null,
        markerPointOverride = null,
        markerAlignmentOverride = null;

  /// A convenience method for extracting the marker from a PopupSpec.
  /// Particularly handy for lists e.g. popupSpecs.map(PopupSpec.unwrap).
  static Marker unwrap(PopupSpec popupSpec) => popupSpec.marker;

  // Uses the hashCode for equals comparison to allow Marker extensions to be
  // considered equal to a normal Marker by overriding their hashCode to equal
  // the hashCode of their container Marker. This is useful for FlutterMap
  // plugins that need to wrap Markers with their own data but still have them
  // match the user provided markers.
  @override
  bool operator ==(Object other) =>
      other is PopupSpec && marker.hashCode == other.marker.hashCode;

  @override
  int get hashCode => marker.hashCode;

  ///////////////////////////////
  /// Marker method overrides  //
  ///////////////////////////////

  LatLng get markerPoint => markerPointOverride ?? marker.point;

  Alignment get markerAlignment =>
      markerAlignmentOverride ?? marker.alignment ?? Alignment.center;

  ////////////////////////////
  /// Marker method proxies //
  ////////////////////////////

  bool get markerRotate => marker.rotate == true;

  double get markerWidth => marker.width;

  double get markerHeight => marker.height;
}
