import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_popup/src/state/popup_event.dart';

class PopupMarkerLayerOptions {
  /// The markers to display on the map.
  final List<Marker> markers;

  /// Controls the appearance of popups. Leave null if you wish to show popups
  /// elsewhere either using PopupLayerPopups or by manually constructing the
  /// popup using PopupScope/PopupState.
  final PopupDisplayOptions? popupDisplayOptions;

  /// If a PopupController is provided it can be used to programmatically show
  /// and hide the popup. This must be null if there is a surrounding
  /// [PopupScope]. The PopupController should be passed there instead.
  final PopupController? popupController;

  /// The PopupSpecs for which a popup should be initially visible. Note that
  /// this has no affect if the [PopupMarkerLayer] is within a [PopupScope] and
  /// should be declared on the [PopupScope] instead.
  final List<PopupSpec> initiallySelected;

  /// An optional builder which, if provided, will be used to build markers
  /// which are selected.
  final Widget Function(BuildContext context, Marker marker)?
      selectedMarkerBuilder;

  /// Setting a [MarkerCenterAnimation] will cause the map to be centered on
  /// a marker when it is tapped. Defaults to not centering on the marker.
  final MarkerCenterAnimation? markerCenterAnimation;

  /// The default MarkerTapBehavior is
  /// [MarkerTapBehavior.togglePopupAndHideRest] which will toggle the popup of
  /// the tapped marker and hide all other popups. This is a sensible default
  /// when you only want to show a single popup at a time but if you show
  /// multiple popups you probably want to use [MarkerTapBehavior.togglePopup].
  ///
  /// For more information and other options see [MarkerTapBehavior].
  final MarkerTapBehavior markerTapBehavior;

  /// An optional callback which can be used to react to [PopupControllerEvent]s.
  /// The [selectedMarkers] is the list of [Marker]s which are selected *after*
  /// the [event] is applied.
  final Function(PopupEvent event, List<Marker> selectedMarkers)? onPopupEvent;

  /// Show the list of [markers] on the map with a popups that are shown when a
  /// marker is tapped or when triggered via the [popupController].
  ///
  /// Use [popupBuilder] to build the popup widget and [popupSnap] to control
  /// where the popup appears. [rebuild] can be used to force a rebuild of the
  /// layer.
  ///
  /// Important notes about rotation:
  ///
  /// **Note**: This only applies if the chosen [PopupSnap] snaps to the
  /// [Marker]. If you are snapping to the map then the rotation origin and
  /// rotation alignment have to effect on the popup.
  ///
  /// In order for the popup to be placed correctly relative to the [Marker],
  /// the [Marker] rotation origin and rotation alignment must be correctly
  /// set with respect to the [Marker]'s anchor. If you are using one of the
  /// [AnchorAlign] values for the anchor then the rotation origin can be left
  /// null and the rotation alignment should be set to the value returned by
  /// by calling [rotationAlignment] on the [AnchorAlign] value.
  ///
  /// If you are *not* using an [AnchorAlign] for the anchor position you must
  /// set the rotation origin and rotation alignment such that whilst rotating
  /// the map:
  ///   * The anchor point does not move relative to the [Marker]'s point.
  ///   * The [Marker]'s orientation matches the rotation.
  PopupMarkerLayerOptions({
    required this.markers,
    this.popupDisplayOptions,
    this.popupController,
    this.initiallySelected = const [],
    this.selectedMarkerBuilder,
    this.markerCenterAnimation,
    MarkerTapBehavior? markerTapBehavior,
    this.onPopupEvent,
  }) : markerTapBehavior =
            markerTapBehavior ?? MarkerTapBehavior.togglePopupAndHideRest();
}
