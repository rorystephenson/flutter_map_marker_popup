import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_container/popup_container_mixin.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event.dart';
import 'package:flutter_map_marker_popup/src/state/popup_state_impl.dart';

class SimplePopupContainer extends StatefulWidget {
  final MapCamera mapCamera;
  final PopupStateImpl popupStateImpl;
  final PopupBuilder popupBuilder;
  final PopupSnap snap;

  const SimplePopupContainer({
    super.key,
    required this.mapCamera,
    required this.popupStateImpl,
    required this.snap,
    required this.popupBuilder,
  });

  @override
  State<StatefulWidget> createState() => _SimplePopupContainerState();
}

class _SimplePopupContainerState extends State<SimplePopupContainer>
    with PopupContainerMixin {
  late Set<PopupSpec> _selectedPopupSpecs;

  late StreamSubscription<PopupEvent> _popupStateEventSubscription;

  @override
  MapCamera get mapCamera => widget.mapCamera;

  @override
  PopupStateImpl get popupStateImpl => widget.popupStateImpl;

  @override
  PopupSnap get snap => widget.snap;

  @override
  void initState() {
    super.initState();
    _popupStateEventSubscription =
        widget.popupStateImpl.stream.listen(handleEvent);
    _selectedPopupSpecs = LinkedHashSet.from(
      widget.popupStateImpl.selectedMarkers.map(PopupSpec.wrap),
    );
  }

  @override
  void didUpdateWidget(covariant SimplePopupContainer oldWidget) {
    if (oldWidget.popupStateImpl != widget.popupStateImpl) {
      _popupStateEventSubscription.cancel();
      _popupStateEventSubscription =
          widget.popupStateImpl.stream.listen(handleEvent);
      _selectedPopupSpecs
        ..clear()
        ..addAll(widget.popupStateImpl.selectedPopupSpecs);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _popupStateEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedPopupSpecs.isEmpty) return Container();

    return MobileLayerTransformer(
      child: Stack(
        children: _selectedPopupSpecs
            .map((popupSpec) => inPosition(
                  popupSpec,
                  popupWithStateKeepAlive(popupSpec, widget.popupBuilder),
                ))
            .toList(),
      ),
    );
  }

  @override
  void showPopupsAlsoFor(ShowedPopupsAlsoForEvent event) {
    setState(() {
      _selectedPopupSpecs.addAll(event.popupSpecs);
    });
  }

  @override
  void showPopupsOnlyFor(ShowedPopupsOnlyForEvent event) {
    setState(() {
      _selectedPopupSpecs.clear();
      _selectedPopupSpecs.addAll(event.popupSpecs);
    });
  }

  @override
  void hideAllPopups(HidAllPopupsEvent event) {
    if (_selectedPopupSpecs.isNotEmpty) {
      setState(() {
        _selectedPopupSpecs.clear();
      });
    }
  }

  @override
  void hidePopupsOnlyFor(HidPopupsOnlyForEvent event) {
    setState(() {
      _selectedPopupSpecs.removeAll(event.popupSpecs);
    });
  }
}
