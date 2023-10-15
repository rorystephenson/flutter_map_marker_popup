import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_popup_example/widget/grid_select.dart';

/// This class provides controls for various popup layer examples.
class PopupOptionControls extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    PopupSnap popupSnap,
    bool rotate,
    bool fade,
    Alignment markerAlignment,
    bool showMultiplePopups,
    bool showPopups,
  ) builder;

  const PopupOptionControls({
    super.key,
    required this.builder,
  });

  @override
  State<PopupOptionControls> createState() => _PopupOptionControls();
}

class _PopupOptionControls extends State<PopupOptionControls> {
  static const List<Alignment> alignments = [
    Alignment.centerLeft,
    Alignment.topCenter,
    Alignment.centerRight,
    Alignment.bottomCenter,
    Alignment.center,
  ];

  bool _rotate = true;
  bool _fade = true;
  bool _snapToMarker = true;
  Alignment _popupAlignment = alignments[1];
  Alignment _markerAlignment = alignments[1];
  bool _showMultiplePopups = false;
  bool _showPopups = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: widget.builder(
            context,
            _popupSnap,
            _rotate,
            _fade,
            _markerAlignment,
            _showMultiplePopups,
            _showPopups,
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
                isSelected: [_snapToMarker, _rotate, _fade],
                onPressed: (int index) {
                  setState(() {
                    if (index == 0) _snapToMarker = !_snapToMarker;
                    if (index == 1) _rotate = !_rotate;
                    if (index == 2) _fade = !_fade;
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
                          _popupAlignment = alignment;
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
                          _markerAlignment = alignment;
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
                        value: _showPopups,
                        onChanged: (newValue) {
                          setState(() {
                            _showPopups = newValue;
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
                        value: _showMultiplePopups,
                        onChanged: !_showPopups
                            ? null
                            : (newValue) {
                                setState(() {
                                  _showMultiplePopups = newValue;
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
    );
  }

  PopupSnap get _popupSnap {
    if (_snapToMarker) {
      return <Alignment, PopupSnap>{
        Alignment.centerLeft: PopupSnap.markerLeft,
        Alignment.topCenter: PopupSnap.markerTop,
        Alignment.centerRight: PopupSnap.markerRight,
        Alignment.bottomCenter: PopupSnap.markerBottom,
        Alignment.center: PopupSnap.markerCenter,
      }[_popupAlignment]!;
    } else {
      return <Alignment, PopupSnap>{
        Alignment.centerLeft: PopupSnap.mapLeft,
        Alignment.topCenter: PopupSnap.mapTop,
        Alignment.centerRight: PopupSnap.mapRight,
        Alignment.bottomCenter: PopupSnap.mapBottom,
        Alignment.center: PopupSnap.mapCenter,
      }[_popupAlignment]!;
    }
  }
}
