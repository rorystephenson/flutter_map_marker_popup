import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup_example/widget_between_popups_and_markers_page.dart';

import 'basic_example_page.dart';
import 'full_example_page.dart';
import 'popup_outside_of_map_page.dart';
import 'selected_marker_builder_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marker Popup Examples',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BasicExamplePage(),
      routes: <String, WidgetBuilder>{
        BasicExamplePage.route: (context) => const BasicExamplePage(),
        FullExamplePage.route: (context) => const FullExamplePage(),
        SelectedMarkerBuilderPage.route: (context) =>
            const SelectedMarkerBuilderPage(),
        PopupOutsideOfMapPage.route: (context) => const PopupOutsideOfMapPage(),
        WidgetBetweenPopupsAndMarkersPage.route: (context) =>
            const WidgetBetweenPopupsAndMarkersPage(),
      },
    );
  }
}
