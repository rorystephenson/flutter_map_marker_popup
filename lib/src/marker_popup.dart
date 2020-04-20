import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_container.dart';
import 'package:flutter_map_marker_popup/src/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/popup_marker_layer_options.dart';
import 'package:flutter_map_marker_popup/src/popup_position.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

class MarkerPopup extends StatefulWidget {
  final PopupController popupController;
  final PopupBuilder popupBuilder;
  final PopupSnap snap;
  final MapState mapState;

  MarkerPopup({
    @required this.mapState,
    @required this.popupController,
    @required this.snap,
    @required this.popupBuilder,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MarkerPopupState(
      this.mapState,
      this.popupController,
      this.snap,
      this.popupBuilder,
    );
  }
}

class _MarkerPopupState extends State<MarkerPopup> {
  final MapState _mapState;
  final PopupController _popupController;
  final PopupBuilder _popupBuilder;
  final PopupSnap _snap;

  Marker _selectedMarker;

  _MarkerPopupState(
    this._mapState,
    this._popupController,
    this._snap,
    this._popupBuilder,
  );

  @override
  void initState() {
    super.initState();

    _popupController.streamController = StreamController<Marker>.broadcast();
    _popupController.streamController.stream
        .listen((Marker tapped) => _markerTapped(tapped));
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedMarker == null) return Container();

    final PopupContainer popupContainer =
        PopupPosition.container(_mapState, _selectedMarker, _snap);

    return Positioned(
      width: popupContainer.width,
      height: popupContainer.height,
      left: popupContainer.left,
      top: popupContainer.top,
      right: popupContainer.right,
      bottom: popupContainer.bottom,
      child: Align(
        alignment: popupContainer.alignment,
        child: _popupBuilder(
          context,
          _selectedMarker,
        ),
      ),
    );
  }

  void _markerTapped(Marker marker) {
    setState(() {
      _selectedMarker = _selectedMarker == marker ? null : marker;
    });
  }

  @override
  void dispose() {
    _popupController.streamController.close();
    super.dispose();
  }
}
