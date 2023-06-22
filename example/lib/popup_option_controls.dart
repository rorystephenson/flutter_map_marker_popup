import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import 'drawer.dart';
import 'map_with_popups.dart';

/// NOTE:
/// This file is just for toggling the different options. See
/// map_with_popups.dart for the actual map or simple_map_with_popups.dart for
/// a simpler version.
class PopupOptionControls extends StatefulWidget {
  static const route = 'popupOptionControls';

  const PopupOptionControls({Key? key}) : super(key: key);

  @override
  State<PopupOptionControls> createState() => _PopupOptionControlsState();
}

class _PopupOptionControlsState extends State<PopupOptionControls> {
  static const List<AlignmentGeometry> alignments = [
    Alignment.centerLeft,
    Alignment.topCenter,
    Alignment.centerRight,
    Alignment.bottomCenter,
    Alignment.center,
  ];

  final _popupController = PopupController();

  bool rotate = true;
  bool fade = true;
  bool snapToMarker = true;
  AlignmentGeometry popupAlignment = alignments[1];
  AlignmentGeometry anchorAlignment = alignments[1];
  bool showMultiplePopups = false;
  bool showPopups = true;

  @override
  void dispose() {
    _popupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full example')),
      drawer: buildDrawer(context, PopupOptionControls.route),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PopupScope(
              popupController: _popupController,
              child: Builder(builder: (context) {
                return MapWithPopups(
                  popupController: _popupController,
                  popupState: PopupState.maybeOf(context, listen: false)!,
                  snap: _popupSnap,
                  rotate: rotate,
                  fade: fade,
                  markerAnchorAlign: _markerAnchorAlign,
                  showMultiplePopups: showMultiplePopups,
                  showPopups: showPopups,
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToggleButtons(
                  textStyle: const TextStyle(fontSize: 16),
                  isSelected: [snapToMarker, rotate, fade],
                  onPressed: (int index) {
                    setState(() {
                      if (index == 0) snapToMarker = !snapToMarker;
                      if (index == 1) rotate = !rotate;
                      if (index == 2) fade = !fade;
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.messenger),
                          Text(' Snap to Marker'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [Icon(Icons.rotate_right), Text(' Rotate')],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.animation),
                          Text(' Fade'),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Column(
                    children: [
                      const Text(
                        '\nPopup snap ',
                        style: TextStyle(fontSize: 18),
                      ),
                      GridSelect(
                        initialAlignment: Alignment.topCenter,
                        disableCornerAlignments: true,
                        onSelect: (alignment) {
                          setState(() {
                            popupAlignment = alignment;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        '\nMarker anchor ',
                        style: TextStyle(fontSize: 18),
                      ),
                      GridSelect(
                        initialAlignment: Alignment.topCenter,
                        onSelect: (alignment) {
                          setState(() {
                            anchorAlignment = alignment;
                          });
                        },
                      ),
                    ],
                  ),
                ]),
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '\nShow popups',
                          style: TextStyle(fontSize: 18),
                        ),
                        Switch(
                          value: showPopups,
                          onChanged: (newValue) {
                            setState(() {
                              showPopups = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '\nShow multiple',
                          style: TextStyle(fontSize: 18),
                        ),
                        Switch(
                          value: showMultiplePopups,
                          onChanged: !showPopups
                              ? null
                              : (newValue) {
                                  setState(() {
                                    showMultiplePopups = newValue;
                                  });
                                },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AnchorAlign get _markerAnchorAlign {
    return <AlignmentGeometry, AnchorAlign>{
      Alignment.topLeft: AnchorAlign.topLeft,
      Alignment.topCenter: AnchorAlign.top,
      Alignment.topRight: AnchorAlign.topRight,
      Alignment.centerLeft: AnchorAlign.left,
      Alignment.center: AnchorAlign.center,
      Alignment.centerRight: AnchorAlign.right,
      Alignment.bottomLeft: AnchorAlign.bottomLeft,
      Alignment.bottomCenter: AnchorAlign.bottom,
      Alignment.bottomRight: AnchorAlign.bottomRight,
    }[anchorAlignment]!;
  }

  PopupSnap get _popupSnap {
    if (snapToMarker) {
      return <AlignmentGeometry, PopupSnap>{
        Alignment.centerLeft: PopupSnap.markerLeft,
        Alignment.topCenter: PopupSnap.markerTop,
        Alignment.centerRight: PopupSnap.markerRight,
        Alignment.bottomCenter: PopupSnap.markerBottom,
        Alignment.center: PopupSnap.markerCenter,
      }[popupAlignment]!;
    } else {
      return <AlignmentGeometry, PopupSnap>{
        Alignment.centerLeft: PopupSnap.mapLeft,
        Alignment.topCenter: PopupSnap.mapTop,
        Alignment.centerRight: PopupSnap.mapRight,
        Alignment.bottomCenter: PopupSnap.mapBottom,
        Alignment.center: PopupSnap.mapCenter,
      }[popupAlignment]!;
    }
  }
}

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
