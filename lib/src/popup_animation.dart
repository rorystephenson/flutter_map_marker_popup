import 'package:flutter/animation.dart';

class PopupAnimation {
  final Duration duration;
  final Curve curve;
  final bool enabled;

  static const Duration _defaultDuration = Duration(milliseconds: 300);

  const PopupAnimation.none()
      : enabled = false,
        duration = null,
        curve = null;

  const PopupAnimation.fade({Duration duration, Curve curve})
      : enabled = true,
        duration = duration ?? _defaultDuration,
        curve = curve ?? Curves.ease;
}
