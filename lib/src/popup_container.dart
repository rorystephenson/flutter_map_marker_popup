import 'package:flutter/widgets.dart';

class PopupContainer {
  final double width;
  final double height;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final Alignment alignment;

  PopupContainer({
    size,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.alignment,
  })  : this.width = size.x,
        this.height = size.y;
}
