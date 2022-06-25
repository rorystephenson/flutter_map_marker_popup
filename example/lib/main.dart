import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup_example/popup_manager_example.dart';
import 'package:flutter_map_marker_popup_example/popup_option_controls.dart';
import 'package:flutter_map_marker_popup_example/simple_map_with_popups.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marker Popup Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PopupOptionControls(),
      routes: <String, WidgetBuilder>{
        PopupOptionControls.route: (context) => const PopupOptionControls(),
        SimpleMapWithPopups.route: (context) => SimpleMapWithPopups(),
        PopupManagerExample.route: (context) => PopupManagerExample(),
      },
    );
  }
}
