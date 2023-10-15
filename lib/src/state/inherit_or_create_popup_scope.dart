import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_popup/src/controller/popup_controller_event.dart';
import 'package:flutter_map_marker_popup/src/controller/popup_controller_impl.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event.dart';
import 'package:flutter_map_marker_popup/src/state/popup_state_impl.dart';
import 'package:provider/provider.dart';

/// Looks for a [PopupState] in the current BuildContext or creates a new one.
/// Events emitted by the provided [PopupController] are applied to the
/// [PopupState].
class InheritOrCreatePopupScope extends StatefulWidget {
  /// Used to show/hide popups.
  final PopupController popupController;

  /// The PopupSpecs for which a popup should be initially visible. If the
  /// PopupState is inherited this has no effect.
  final List<PopupSpec>? initiallySelected;

  /// An optional callback which can be used to react to [PopupControllerEvent]s. The
  /// [selectedMarkers] is the list of [Marker]s which are selected *after*
  /// the [event] is applied.
  final Function(PopupEvent event, List<Marker> selectedMarkers)? onPopupEvent;

  /// Used to build the child.
  final Widget Function(BuildContext context, PopupState popupState) builder;

  /// Only create a new PopupState if there is none in the current BuildContext.
  /// This is useful for plugins/packages that use this package. Note that the
  /// [initiallySelected] will have no affect if a PopupState is
  /// inherited.
  const InheritOrCreatePopupScope({
    super.key,
    required this.popupController,
    this.initiallySelected,
    this.onPopupEvent,
    required this.builder,
  });

  @override
  State<InheritOrCreatePopupScope> createState() =>
      _InheritOrCreatePopupScopeState();
}

class _InheritOrCreatePopupScopeState extends State<InheritOrCreatePopupScope> {
  bool _initialized = false;
  late final PopupStateImpl _popupState;
  late final bool _popupStateProvided;

  StreamSubscription<PopupEvent>? _popupStateSubscription;
  StreamSubscription<PopupControllerEvent>? _popupControllerSubscription;

  int? _previousZoom;
  StreamSubscription<MapEvent>? _mapSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Find or create the PopupState.
    if (_initialized) return;
    final popupState = PopupState.maybeOf(context, listen: false);
    if (popupState == null) {
      _popupStateProvided = false;
      _popupState = PopupStateImpl(
        initiallySelected: widget.initiallySelected ?? [],
      );
    } else {
      _popupStateProvided = true;
      _popupState = popupState as PopupStateImpl;
    }

    _mapSubscription ??=
        MapController.of(context).mapEventStream.listen(_onMapEvent);

    // Set the state listener.
    _setPopupStateListener();

    // Start listening to the controller.
    _listenToPopupController();

    _initialized = true;
  }

  @override
  void didUpdateWidget(covariant InheritOrCreatePopupScope oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.popupController != widget.popupController) {
      _listenToPopupController();
    }

    if ((oldWidget.onPopupEvent == null) != (widget.onPopupEvent == null)) {
      _setPopupStateListener();
    }
  }

  void _setPopupStateListener() {
    _popupStateSubscription?.cancel();
    _popupStateSubscription = null;

    if (widget.onPopupEvent != null) {
      _popupStateSubscription = _popupState.stream.listen((popupEvent) {
        widget.onPopupEvent?.call(popupEvent, _popupState.selectedMarkers);
      });
    }
  }

  void _listenToPopupController() {
    _popupControllerSubscription?.cancel();
    _popupControllerSubscription =
        (widget.popupController as PopupControllerImpl).stream.listen((event) {
      _popupState.applyEvent(event);
    });
  }

  void _onMapEvent(MapEvent mapEvent) {
    final zoom = mapEvent.camera.zoom.ceil();

    if (_previousZoom == null || zoom < _previousZoom!) {
      widget.popupController.hidePopupsWhereSpec((popupSpec) =>
          popupSpec.removeIfZoomLessThan != null &&
          zoom < popupSpec.removeIfZoomLessThan!);
    }

    _previousZoom = zoom;
  }

  @override
  void dispose() {
    _mapSubscription?.cancel();

    _popupStateSubscription?.cancel();
    _popupStateSubscription = null;

    if (!_popupStateProvided) _popupState.dispose();

    _popupControllerSubscription?.cancel();
    _popupControllerSubscription = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_popupStateProvided) return child(context);

    return ChangeNotifierProvider<PopupState>.value(
      value: _popupState,
      child: Builder(
        builder: (context) => child(context),
      ),
    );
  }

  Widget child(BuildContext context) => widget.builder(context, _popupState);
}
