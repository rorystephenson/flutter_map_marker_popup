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

  SimplePopupContainer({
    @required this.mapState,
    @required this.popupController,
    @required this.snap,
    @required this.popupBuilder,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SimplePopupContainerState(
      mapState,
      popupController,
      snap,
      popupBuilder,
    );
  }
}

class _SimplePopupContainerState extends State<SimplePopupContainer>
    with PopupContainerMixin {
  @override
  final MapState mapState;
  final PopupController _popupController;
  final PopupBuilder _popupBuilder;
  @override
  final PopupSnap snap;

  MarkerWithKey _selectedMarkerWithKey;

  StreamSubscription<PopupEvent> _popupEventSubscription;

  _SimplePopupContainerState(
    this.mapState,
    this._popupController,
    this.snap,
    this._popupBuilder,
  );

  @override
  void initState() {
    super.initState();

    _popupController.streamController =
        StreamController<PopupEvent>.broadcast();
    _popupEventSubscription = _popupController.streamController.stream
        .listen((PopupEvent popupEvent) => handleAction(popupEvent));
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedMarkerWithKey == null) return Container();

    return inPosition(
      _selectedMarkerWithKey.marker,
      popupWithStateKeepAlive(_selectedMarkerWithKey, _popupBuilder),
    );
  }

  @override
  void hideAny() {
    if (_selectedMarkerWithKey != null) {
      setState(() {
        _selectedMarkerWithKey = null;
      });
    }
  }

  @override
  void showForMarker(Marker marker) {
    if (marker != null && !markerIsVisible(marker)) {
      setState(() {
        _selectedMarkerWithKey = MarkerWithKey(marker);
      });
    }
  }

  @override
  bool markerIsVisible(Marker marker) {
    return _selectedMarkerWithKey != null &&
        _selectedMarkerWithKey.marker == marker;
  }

  @override
  void dispose() {
    _popupController.streamController.close();
    _popupEventSubscription?.cancel();
    super.dispose();
  }
}
