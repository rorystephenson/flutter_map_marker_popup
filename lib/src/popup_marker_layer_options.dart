import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

class PopupMarkerLayerOptions extends LayerOptions {
  final List<Marker> markers;
  final PopupBuilder popupBuilder;
  final PopupController popupController;
  final PopupSnap popupSnap;

  PopupMarkerLayerOptions({
    this.markers = const [],
    @required this.popupBuilder,
    this.popupSnap = PopupSnap.top,
    popupController,
    rebuild,
  })  : this.popupController = popupController ?? PopupController(),
        super(rebuild: rebuild);
}
