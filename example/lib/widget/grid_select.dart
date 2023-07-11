import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup_example/widget/grid_select_button.dart';

class GridSelect extends StatefulWidget {
  final void Function(Alignment alignment) onSelect;
  final Alignment initialAlignment;
  final bool disableCornerAlignments;

  const GridSelect({
    super.key,
    required this.onSelect,
    required this.initialAlignment,
    this.disableCornerAlignments = false,
  });

  @override
  State<GridSelect> createState() => _GridSelectState();
}

class _GridSelectState extends State<GridSelect> {
  late Alignment _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialAlignment;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridSelectButton(
              alignment: Alignment.topLeft,
              selection: _selected,
              onSelect: widget.disableCornerAlignments ? null : _onSelectButton,
            ),
            GridSelectButton(
              alignment: Alignment.topCenter,
              selection: _selected,
              onSelect: _onSelectButton,
            ),
            GridSelectButton(
              alignment: Alignment.topRight,
              selection: _selected,
              onSelect: widget.disableCornerAlignments ? null : _onSelectButton,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridSelectButton(
              alignment: Alignment.centerLeft,
              selection: _selected,
              onSelect: _onSelectButton,
            ),
            GridSelectButton(
              alignment: Alignment.center,
              selection: _selected,
              onSelect: _onSelectButton,
            ),
            GridSelectButton(
              alignment: Alignment.centerRight,
              selection: _selected,
              onSelect: _onSelectButton,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridSelectButton(
              alignment: Alignment.bottomLeft,
              selection: _selected,
              onSelect: widget.disableCornerAlignments ? null : _onSelectButton,
            ),
            GridSelectButton(
              alignment: Alignment.bottomCenter,
              selection: _selected,
              onSelect: _onSelectButton,
            ),
            GridSelectButton(
              alignment: Alignment.bottomRight,
              selection: _selected,
              onSelect: widget.disableCornerAlignments ? null : _onSelectButton,
            ),
          ],
        ),
      ],
    );
  }

  void _onSelectButton(Alignment selected) {
    widget.onSelect(selected);
    setState(() {
      _selected = selected;
    });
  }
}
