import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_event.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import '../popup_controller_impl.dart';
import '../popup_state_impl.dart';
import 'marker_with_key.dart';
import 'popup_container_mixin.dart';

class DoNotDisplayPopupContainer extends StatefulWidget {
  final FlutterMapState mapState;
  final PopupStateImpl popupStateImpl;
  final PopupControllerImpl popupControllerImpl;
  final Function(PopupEvent event, List<Marker> selectedMarkers)? onPopupEvent;

  const DoNotDisplayPopupContainer({
    required this.mapState,
    required this.popupStateImpl,
    required this.popupControllerImpl,
    required this.onPopupEvent,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DoNotDisplayPopupContainerState();
}

class _DoNotDisplayPopupContainerState extends State<DoNotDisplayPopupContainer>
    with PopupContainerMixin {
  late Set<MarkerWithKey> _selectedMarkersWithKeys;

  late StreamSubscription<PopupEvent> _popupEventSubscription;

  @override
  FlutterMapState get mapState => widget.mapState;

  @override
  PopupStateImpl get popupStateImpl => widget.popupStateImpl;

  @override
  PopupSnap get snap => PopupSnap.mapBottom; // Not used

  @override
  bool get markerRotate => false;

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
  void didUpdateWidget(covariant DoNotDisplayPopupContainer oldWidget) {
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
    return const SizedBox.shrink();
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
