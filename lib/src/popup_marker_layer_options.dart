import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

class PopupMarkerLayerOptions extends LayerOptions {
  /// The list of markers to show on the map.
  final List<Marker> markers;

  /// Used to construct the popup.
  final PopupBuilder popupBuilder;

  /// If a PopupController is provided it can be used to programmatically show
  /// and hide the popup.
  final PopupController popupController;

  /// Controls the position of the popup relative to the marker or popup.
  final PopupSnap popupSnap;

  /// Show the list of [markers] on the map with a popup that is shown when a
  /// marker is tapped or when triggered via the [popupController].
  ///
  /// Use [popupBuilder] to build the popup widget and [popupSnap] to control
  /// where the popup appears. [rebuild] can be used to force a rebuild of the
  /// layer.
  PopupMarkerLayerOptions({
    this.markers = const [],
    @required this.popupBuilder,
    this.popupSnap = PopupSnap.markerTop,
    PopupController popupController,
    Stream<Null> rebuild,
  })  : popupController = popupController ?? PopupController(),
        super(rebuild: rebuild);
}
