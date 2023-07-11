import 'package:flutter/material.dart';

class GridSelectButton extends StatelessWidget {
  final Alignment alignment;
  final Alignment selection;
  final void Function(Alignment alignment)? onSelect;
  const GridSelectButton({
    super.key,
    required this.alignment,
    required this.selection,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: alignment == selection ? Colors.blue.shade100 : null,
      child: InkWell(
        onTap: onSelect == null ? null : () => onSelect!(alignment),
        child: Icon(
          _iconData,
          size: 30,
          color: onSelect != null ? null : Colors.grey.shade300,
        ),
      ),
    );
  }

  IconData get _iconData {
    switch (alignment) {
      case Alignment.topLeft:
        return Icons.north_west;
      case Alignment.topCenter:
        return Icons.north;
      case Alignment.topRight:
        return Icons.north_east;

      case Alignment.centerLeft:
        return Icons.west;
      case Alignment.center:
        return Icons.center_focus_strong;
      case Alignment.centerRight:
        return Icons.east;

      case Alignment.bottomLeft:
        return Icons.south_west;
      case Alignment.bottomCenter:
        return Icons.south;
      case Alignment.bottomRight:
        return Icons.south_east;
      default:
        throw 'Unexpected alignment';
    }
  }
}
