import 'package:flutter/animation.dart';

class MarkerCenterAnimation {
  final Duration duration;
  final Curve curve;

  const MarkerCenterAnimation({
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.ease,
  });
}
