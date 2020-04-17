import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_marker_layer.dart';
import 'package:flutter_map_marker_popup/src/popup_marker_layer_options.dart';

class PopupMarkerPlugin<T> extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    return PopupMarkerLayer<T>(options, mapState, stream);
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is PopupMarkerLayerOptions<T>;
  }
}
