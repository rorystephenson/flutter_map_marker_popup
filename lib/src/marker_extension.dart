import 'package:flutter_map/plugin_api.dart';

extension MarkerExtension on Marker {
  Anchor get anchor => Anchor.fromPos(
        anchorPos ?? AnchorPos.align(AnchorAlign.center),
        width,
        height,
      );
}
