import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart' as flutter_map;
import 'package:flutter_map_marker_popup/src/popup_layer.dart';

import '../flutter_map_marker_popup.dart';
import 'marker_layer.dart';
import 'popup_controller_impl.dart';

class PopupMarkerLayerWidget extends StatelessWidget {
  final PopupMarkerLayerOptions options;

  PopupMarkerLayerWidget({required this.options}) : super(key: options.key);

  @override
  Widget build(BuildContext context) {
    final mapState = flutter_map.MapState.maybeOf(context)!;
    return Stack(children: [
      MarkerLayer(
        options,
        mapState,
        mapState.onMoved,
        options.popupController as PopupControllerImpl,
      ),
      PopupLayer(
        mapState: mapState,
        stream: mapState.onMoved,
        popupSnap: options.popupSnap,
        popupBuilder: options.popupBuilder,
        popupController: options.popupController as PopupControllerImpl,
        popupAnimation: options.popupAnimation,
        markerRotate: options.rotate ?? false,
      ),
    ]);
  }
}
