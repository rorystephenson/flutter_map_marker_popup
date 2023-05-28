import 'package:flutter_map_marker_popup/src/popup_animation.dart';
import 'package:flutter_map_marker_popup/src/popup_builder.dart';
import 'package:flutter_map_marker_popup/src/popup_snap.dart';

/// Controls the appearance of popups.
class PopupDisplayOptions {
  /// Used to construct the popup.
  final PopupBuilder builder;

  /// Determines the position of the popup relative to the marker or popup.
  final PopupSnap snap;

  /// Allows the use of an animation for showing/hiding popups. Defaults to no
  /// animation.
  final PopupAnimation? animation;

  const PopupDisplayOptions({
    required this.builder,
    this.snap = PopupSnap.markerTop,
    this.animation,
  });
}
