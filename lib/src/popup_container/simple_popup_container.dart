import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/popup_event.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import 'marker_with_key.dart';
import 'popup_container_mixin.dart';

class SimplePopupContainer extends StatefulWidget {
  final PopupController popupController;
  final PopupBuilder popupBuilder;
  final PopupSnap snap;
  final MapState mapState;
  final bool markerRotate;

  SimplePopupContainer({
    required this.mapState,
    required this.popupController,
    required this.snap,
    required this.popupBuilder,
    required this.markerRotate,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SimplePopupContainerState();
}

class _SimplePopupContainerState extends State<SimplePopupContainer>
    with PopupContainerMixin {
  MarkerWithKey? _selectedMarkerWithKey;

  late StreamSubscription<PopupEvent> _popupEventSubscription;

  @override
  MapState get mapState => widget.mapState;

  @override
  PopupController get popupController => widget.popupController;

  @override
  PopupSnap get snap => widget.snap;

  @override
  bool get markerRotate => widget.markerRotate;

  @override
  void initState() {
    super.initState();
    _popupEventSubscription = widget.popupController.streamController!.stream
        .listen((PopupEvent popupEvent) => handleAction(popupEvent));
    _selectedMarkerWithKey = widget.popupController.selectedMarkerWithKey;
  }

  @override
  Widget build(BuildContext context) {
    final _currentlySelected = _selectedMarkerWithKey;

    if (_currentlySelected == null) return Container();

    return inPosition(
      _currentlySelected.marker,
      popupWithStateKeepAlive(_currentlySelected, widget.popupBuilder),
    );
  }

  @override
  void hideAny({required bool disableAnimation}) {
    if (_selectedMarkerWithKey != null) {
      setState(() {
        _selectedMarkerWithKey = null;
      });
    }
  }

  @override
  void showForMarker(
    MarkerWithKey markerWithKey, {
    required bool disableAnimation,
  }) {
    if (!markerIsVisible(markerWithKey.marker)) {
      setState(() {
        _selectedMarkerWithKey = markerWithKey;
      });
    }
  }

  @override
  bool markerIsVisible(Marker marker) {
    return _selectedMarkerWithKey?.marker == marker;
  }

  @override
  void dispose() {
    _popupEventSubscription.cancel();
    super.dispose();
  }
}
