import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';

class PopupLayout {
  final double? width;
  final double? height;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final Alignment alignment;

  PopupLayout({
    CustomPoint? size,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.alignment,
  })  : width = size?.x.toDouble(),
        height = size?.y.toDouble();
}
