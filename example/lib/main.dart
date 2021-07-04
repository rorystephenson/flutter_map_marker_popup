import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup_example/popup_option_controls.dart';

void main() => runApp(MyApp());

/// NOTE:
/// There are three main files:
///  - popup_option_controls.dart: This is just for toggling the different
///    options.
///  - map_with_popups.dart: This is where the actual map is and where you
///    can see an example of using the PopupMarkerLayerWidget.
///  - simple_map_with_popups.dart: A simplified example of using the
///    PopupMarkerLayerWidget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marker Popup Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PopupOptionControls(),
    );
  }
}
