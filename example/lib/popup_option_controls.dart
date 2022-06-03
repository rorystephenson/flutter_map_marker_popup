import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import 'map_with_popups.dart';

class PopupOptionControls extends StatefulWidget {
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

  bool rotate = true;
  bool fade = true;
  bool snapToMarker = true;
  AlignmentGeometry popupAlignment = alignments[1];
  AlignmentGeometry anchorAlignment = alignments[1];
  bool showMultiplePopups = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MapWithPopups(
              snap: _popupSnap,
              rotate: rotate,
              fade: fade,
              markerAnchorAlign: _markerAnchorAlign,
              showMultiplePopups: showMultiplePopups,
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(Icons.messenger),
                          Text(' Snap to Marker'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(Icons.rotate_right),
                          Text(' Rotate')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(Icons.animation),
                          Text(' Fade'),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '\nPopup snap ',
                      style: TextStyle(fontSize: 18),
                    ),
                    ToggleButtons(
                      isSelected: List.generate(alignments.length,
                          (index) => popupAlignment == alignments[index]),
                      onPressed: (int index) {
                        setState(() {
                          popupAlignment = alignments[index];
                        });
                      },
                      children: [
                        Icons.arrow_back,
                        Icons.arrow_upward,
                        Icons.arrow_forward,
                        Icons.arrow_downward,
                        Icons.filter_center_focus_rounded,
                      ]
                          .map(
                            (icon) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(icon),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '\nMarker Anchor',
                      style: TextStyle(fontSize: 18),
                    ),
                    ToggleButtons(
                      isSelected: List.generate(alignments.length,
                          (index) => anchorAlignment == alignments[index]),
                      onPressed: (int index) {
                        setState(() {
                          anchorAlignment = alignments[index];
                        });
                      },
                      children: [
                        Icons.arrow_back,
                        Icons.arrow_upward,
                        Icons.arrow_forward,
                        Icons.arrow_downward,
                        Icons.filter_center_focus_rounded,
                      ]
                          .map(
                            (icon) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(icon),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '\nShow multiple',
                      style: TextStyle(fontSize: 18),
                    ),
                    Switch(
                        value: showMultiplePopups,
                        onChanged: (newValue) {
                          setState(() {
                            showMultiplePopups = newValue;
                          });
                        })
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
      Alignment.centerLeft: AnchorAlign.left,
      Alignment.topCenter: AnchorAlign.top,
      Alignment.centerRight: AnchorAlign.right,
      Alignment.bottomCenter: AnchorAlign.bottom,
      Alignment.center: AnchorAlign.center,
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
