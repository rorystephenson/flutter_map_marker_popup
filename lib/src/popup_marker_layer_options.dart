import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_animation.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_controller.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

class PopupMarkerLayerOptions extends MarkerLayerOptions {
  /// Used to construct the popup.
  final PopupBuilder popupBuilder;

  /// If a PopupController is provided it can be used to programmatically show
  /// and hide the popup.
  final PopupController popupController;

  /// Controls the position of the popup relative to the marker or popup.
  final PopupSnap popupSnap;

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
    List<Marker> markers = const [],
    bool? markerRotate = true,
    AlignmentGeometry? markerRotateAlignment,
    Offset? markerRotateOrigin,
    required this.popupBuilder,
    this.popupSnap = PopupSnap.markerTop,
    this.popupAnimation,
    PopupController? popupController,
    // Forced by flutter_map
    // ignore: prefer_void_to_null
    Stream<Null>? rebuild,
  })  : popupController = popupController ?? PopupController(),
        super(
          markers: markers,
          rotate: markerRotate,
          rotateAlignment: markerRotateAlignment,
          rotateOrigin: markerRotateOrigin,
          rebuild: rebuild,
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
