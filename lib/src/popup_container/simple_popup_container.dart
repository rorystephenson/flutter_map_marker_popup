import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_event.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import '../popup_controller_impl.dart';
import '../popup_state_impl.dart';
import 'marker_with_key.dart';
import 'popup_container_mixin.dart';

class SimplePopupContainer extends StatefulWidget {
  final FlutterMapState mapState;
  final PopupStateImpl popupStateImpl;
  final PopupControllerImpl popupControllerImpl;
  final PopupBuilder popupBuilder;
  final PopupSnap snap;
  final bool markerRotate;
  final Function(PopupEvent event, List<Marker> selectedMarkers)? onPopupEvent;

  const SimplePopupContainer({
    required this.mapState,
    required this.popupStateImpl,
    required this.popupControllerImpl,
    required this.snap,
    required this.popupBuilder,
    required this.markerRotate,
    required this.onPopupEvent,
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
  FlutterMapState get mapState => widget.mapState;

  @override
  PopupStateImpl get popupStateImpl => widget.popupStateImpl;

  @override
  PopupSnap get snap => widget.snap;

  @override
  bool get markerRotate => widget.markerRotate;

  @override
  Function(PopupEvent event, List<Marker> selectedMarkers)? get onPopupEvent =>
      widget.onPopupEvent;

  @override
  void initState() {
    super.initState();
    _popupEventSubscription = widget
        .popupControllerImpl.streamController!.stream
        .listen((PopupEvent popupEvent) => handleAction(popupEvent));
    _selectedMarkersWithKeys =
        LinkedHashSet.from(widget.popupStateImpl.selectedMarkersWithKeys);
  }

  @override
  void didUpdateWidget(covariant SimplePopupContainer oldWidget) {
    if (oldWidget.popupControllerImpl != widget.popupControllerImpl) {
      _popupEventSubscription.cancel();
      _popupEventSubscription = widget
          .popupControllerImpl.streamController!.stream
          .listen((PopupEvent popupEvent) => handleAction(popupEvent));
      _selectedMarkersWithKeys
        ..clear()
        ..addAll(widget.popupStateImpl.selectedMarkersWithKeys);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _popupEventSubscription.cancel();
    super.dispose();
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
}
