import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:flutter_map_marker_popup/src/controller/popup_controller_impl.dart';
import 'package:flutter_map_marker_popup/src/state/inherit_or_create_popup_scope.dart';

import '../flutter_map_marker_popup.dart';
import 'marker_layer.dart';

@Deprecated('Use PopupMarkerLayer instead.')
typedef PopupMarkerLayerWidget = PopupMarkerLayer;

class PopupMarkerLayer extends StatefulWidget {
  final PopupMarkerLayerOptions options;

  const PopupMarkerLayer({super.key, required this.options});

  @override
  State<PopupMarkerLayer> createState() => _PopupMarkerLayerState();
}

class _PopupMarkerLayerState extends State<PopupMarkerLayer> {
  late PopupControllerImpl _popupControllerImpl;
  bool _shouldDisposePopupController = false;

  @override
  void initState() {
    super.initState();

    _setPopupController();
  }

  void _setPopupController() {
    if (_shouldDisposePopupController) _popupControllerImpl.dispose();

    final providedPopupController = widget.options.popupController;
    if (providedPopupController != null) {
      _popupControllerImpl = providedPopupController as PopupControllerImpl;
      _shouldDisposePopupController = false;
    } else {
      _popupControllerImpl = PopupControllerImpl();
      _shouldDisposePopupController = true;
    }
  }

  @override
  void dispose() {
    if (_shouldDisposePopupController) _popupControllerImpl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritOrCreatePopupScope(
      popupController: _popupControllerImpl,
      onPopupEvent: widget.options.onPopupEvent,
      initiallySelected: widget.options.initiallySelected,
      builder: (context, popupState) => Stack(
        children: [
          MarkerLayer(
            layerOptions: widget.options,
            mapCamera: flutter_map.MapCamera.of(context),
            mapController: flutter_map.MapController.of(context),
            popupState: popupState,
            popupController: _popupControllerImpl,
          ),
          if (widget.options.popupDisplayOptions != null)
            PopupLayer(
              popupDisplayOptions: widget.options.popupDisplayOptions!,
            ),
        ],
      ),
    );
  }
}
