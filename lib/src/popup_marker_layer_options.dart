import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_animation.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

class PopupMarkerLayerOptions extends LayerOptions {
  /// The list of markers to show on the map.
  final List<Marker> markers;

  /// Used to construct the popup.
  final PopupBuilder popupBuilder;

  /// If a PopupController is provided it can be used to programmatically show
  /// and hide the popup.
  final PopupController popupController;

  /// Controls the position of the popup relative to the marker or popup.
  final PopupSnap popupSnap;

  /// Enable/Disable rotation for all [Marker]s and their respective popups.
  /// Currently a [Marker] and its popup both have rotation enabled or neither
  /// of them. If a [Marker] has rotation enabled then the popup will be counter
  /// rotated so that it maintains its original orientation. If the [Marker] has
  /// rotation disabled then the popup is not rotated.
  ///
  /// This can be overridden per-[Marker] by setting the [Marker]'s rotate.
  final bool markerAndPopupRotate;

  /// The origin of the coordinate system (relative to the upper left corner of
  /// the [Marker]) in which to apply the rotation.
  ///
  /// See important notes about rotation in [PopupMarkerLayerOptions].
  final Offset? markerRotateOrigin;

  /// The alignment of the rotation origin, relative to the size of the
  /// [Marker].
  ///
  /// If it is specified at the same time as the [rotateOrigin], both are
  /// applied.
  ///
  /// See important notes about rotation in [PopupMarkerLayerOptions].
  final AlignmentGeometry? markerRotateAlignment;

  /// Allows the use of an animation for showing/hiding popups. Defaults to no
  /// animation.
  final PopupAnimation? popupAnimation;

  /// Show the list of [markers] on the map with a popup that is shown when a
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
    this.markers = const [],
    this.markerAndPopupRotate = true,
    this.markerRotateAlignment,
    this.markerRotateOrigin,
    required this.popupBuilder,
    this.popupSnap = PopupSnap.markerTop,
    this.popupAnimation,
    PopupController? popupController,
    Stream<Null>? rebuild,
  })  : popupController = popupController ?? PopupController(),
        super(rebuild: rebuild);

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
