import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';

extension FlutterMapMarkerPopupAnchorAlignExtension on AnchorAlign {
  AlignmentGeometry get rotationAlignment {
    switch (this) {
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
