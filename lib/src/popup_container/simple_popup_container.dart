import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_event.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import '../popup_controller_impl.dart';
import 'marker_with_key.dart';
import 'popup_container_mixin.dart';

class SimplePopupContainer extends StatefulWidget {
  final PopupControllerImpl popupController;
  final PopupBuilder popupBuilder;
  final PopupSnap snap;
  final MapState mapState;
  final bool markerRotate;

  const SimplePopupContainer({
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
  late Set<MarkerWithKey> _selectedMarkersWithKeys;

  late StreamSubscription<PopupEvent> _popupEventSubscription;

  @override
  MapState get mapState => widget.mapState;

  @override
  PopupControllerImpl get popupController => widget.popupController;

  @override
  PopupSnap get snap => widget.snap;

  @override
  bool get markerRotate => widget.markerRotate;

  @override
  void initState() {
    super.initState();
    _popupEventSubscription = widget.popupController.streamController!.stream
        .listen((PopupEvent popupEvent) => handleAction(popupEvent));
    _selectedMarkersWithKeys =
        LinkedHashSet.from(widget.popupController.selectedMarkersWithKeys);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedMarkersWithKeys.isEmpty) return Container();

    return Stack(
      children: _selectedMarkersWithKeys
          .map((markerWithKey) => inPosition(
                markerWithKey.marker,
                popupWithStateKeepAlive(markerWithKey, widget.popupBuilder),
              ))
          .toList(),
    );
  }

  @override
  void showPopupsAlsoFor(
    List<MarkerWithKey> markersWithKeys, {
    required bool disableAnimation,
  }) {
    setState(() {
      _selectedMarkersWithKeys.addAll(markersWithKeys);
    });
  }

  @override
  void showPopupsOnlyFor(
    List<MarkerWithKey> markersWithKeys, {
    required bool disableAnimation,
  }) {
    setState(() {
      _selectedMarkersWithKeys.clear();
      _selectedMarkersWithKeys.addAll(markersWithKeys);
    });
  }

  @override
  void hideAllPopups({required bool disableAnimation}) {
    if (_selectedMarkersWithKeys.isNotEmpty) {
      setState(() {
        _selectedMarkersWithKeys.clear();
      });
    }
  }

  @override
  void hidePopupsOnlyFor(List<Marker> markers,
      {required bool disableAnimation}) {
    setState(() {
      _selectedMarkersWithKeys.removeAll(markers.map(MarkerWithKey.wrap));
    });
  }

  @override
  void dispose() {
    _popupEventSubscription.cancel();
    super.dispose();
  }
}
