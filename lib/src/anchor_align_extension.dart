import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';

extension FlutterMapMarkerPopupAnchorAlignExtension on AnchorAlign {
  AlignmentGeometry get rotationAlignment {
    switch (this) {
      case AnchorAlign.left:
        return Alignment.centerRight;
      case AnchorAlign.topLeft:
        return Alignment.bottomRight;
      case AnchorAlign.top:
        return Alignment.bottomCenter;
      case AnchorAlign.topRight:
        return Alignment.bottomLeft;
      case AnchorAlign.right:
        return Alignment.centerLeft;
      case AnchorAlign.bottomRight:
        return Alignment.topLeft;
      case AnchorAlign.bottom:
        return Alignment.topCenter;
      case AnchorAlign.bottomLeft:
        return Alignment.topRight;
      // TODO: Remove none once flutter_map removes it.
      // ignore: deprecated_member_use
      case AnchorAlign.none:
      case AnchorAlign.center:
        return Alignment.center;
    }
  }
}
