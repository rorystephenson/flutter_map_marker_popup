import 'package:flutter/widgets.dart';

extension FlutterMapMarkerPopupAnchorAlignExtension on Alignment {
  Alignment get opposite => const Alignment(0, 0) - this;
}
