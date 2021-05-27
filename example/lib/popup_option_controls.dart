import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import 'map_with_popups.dart';

class PopupOptionControls extends StatefulWidget {
  PopupOptionControls();

  @override
  _PopupOptionControlsState createState() => _PopupOptionControlsState();
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
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToggleButtons(
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
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.messenger),
                          Text(' Snap to Marker',
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.rotate_right),
                          Text(' Rotate', style: TextStyle(fontSize: 18))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.animation),
                          Text(' Fade', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                              padding: EdgeInsets.all(8.0),
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
                    Text(
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
                              padding: EdgeInsets.all(8.0),
                              child: Icon(icon),
                            ),
                          )
                          .toList(),
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
