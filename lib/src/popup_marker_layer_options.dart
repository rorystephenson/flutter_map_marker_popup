import 'package:flutter/cupertino.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/marker_tap_behavior.dart';
import 'package:flutter_map_marker_popup/src/popup_animation.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

import 'marker_center_animation.dart';
import 'popup_event.dart';

class PopupMarkerLayerOptions extends MarkerLayer {
  /// Used to construct the popup. Leave null if you wish to show popups outside
  /// of the map.
  final PopupBuilder? popupBuilder;

  /// If a PopupController is provided it can be used to programmatically show
  /// and hide the popup.
  final PopupController? popupController;

  /// The markers for which a popup should be initially visible. Note that this
  /// has no affect if the [PopupMarkerLayer] is within a [PopupScope] and
  /// should be declared on [PopupScope] instead.
  final List<Marker> initiallySelectedMarkers;

  /// Controls the position of the popup relative to the marker or popup.
  final PopupSnap popupSnap;

  /// Allows the use of an animation for showing/hiding popups. Defaults to no
  /// animation.
  final PopupAnimation? popupAnimation;

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

  /// An optional callback which can be used to react to [PopupEvent]s. The
  /// [selectedMarkers] is the list of [Marker]s which are selected *before*
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
  /// null and the rotation alignment should be set using to the value returned
  /// by [PopupMarkerLayerOptions.rotationAlignmentFor(anchorAlign)], either
  /// at the [Marker] level or for all markers using [markerRotateAlignment].
  ///
  /// If you are *not* using an [AnchorAlign] for the anchor position you must
  /// set the rotation origin and rotation alignment such that whilst rotating
  /// the map:
  ///   * The anchor point does not move relative to the [Marker]'s point.
  ///   * The [Marker]'s orientation matches the rotation.
  PopupMarkerLayerOptions({
    super.key,
    List<Marker> markers = const [],
    AlignmentGeometry? markerRotateAlignment,
    Offset? markerRotateOrigin,
    this.popupBuilder,
    this.popupController,
    this.initiallySelectedMarkers = const [],
    this.popupSnap = PopupSnap.markerTop,
    this.popupAnimation,
    this.selectedMarkerBuilder,
    this.markerCenterAnimation,
    MarkerTapBehavior? markerTapBehavior,
    bool markerRotate = true,
    this.onPopupEvent,
  })  : markerTapBehavior =
            markerTapBehavior ?? MarkerTapBehavior.togglePopupAndHideRest(),
        super(
          markers: markers,
          rotate: markerRotate,
          rotateAlignment: markerRotateAlignment,
          rotateOrigin: markerRotateOrigin,
        );

  static AlignmentGeometry rotationAlignmentFor(AnchorAlign anchorAlign) {
    switch (anchorAlign) {
      case AnchorAlign.left:
        return Alignment.centerRight;
      case AnchorAlign.top:
        return Alignment.bottomCenter;
      case AnchorAlign.right:
        return Alignment.centerLeft;
      case AnchorAlign.bottom:
        return Alignment.topCenter;
      case AnchorAlign.center:
      case AnchorAlign.none:
        return Alignment.center;
    }
  }
}
