import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_popup_example/full_example.dart';
import 'package:flutter_map_marker_popup_example/widget/popup_option_controls.dart';

import 'drawer.dart';

class FullExamplePage extends StatefulWidget {
  static const route = 'fullExamplePage';

  const FullExamplePage({super.key});

  @override
  State<FullExamplePage> createState() => _FullExamplePageState();
}

class _FullExamplePageState extends State<FullExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Example')),
      drawer: buildDrawer(context, FullExamplePage.route),
      body: PopupOptionControls(
        builder: (
          context,
          popupSnap,
          rotate,
          fade,
          markerAnchorAlign,
          showMultiplePopups,
          showPopups,
        ) =>
            PopupScope(
          child: Builder(
            builder: (context) => FullExample(
              snap: popupSnap,
              rotate: rotate,
              fade: fade,
              markerAlignment: markerAnchorAlign,
              showMultiplePopups: showMultiplePopups,
              showPopups: showPopups,
              popupState: PopupState.of(context),
            ),
          ),
        ),
      ),
    );
  }
}
