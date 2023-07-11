import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup_example/widget_between_popups_and_markers_page.dart';

import 'basic_example_page.dart';
import 'full_example_page.dart';
import 'popup_outside_of_map_page.dart';
import 'selected_marker_builder_page.dart';

Widget _buildMenuItem(
  BuildContext context,
  Widget title,
  String routeName,
  String currentRoute,
) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Popup Examples'),
          ),
        ),
        _buildMenuItem(
          context,
          const Text('Basic Example'),
          BasicExamplePage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Full Example'),
          FullExamplePage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Selected Marker Builder'),
          SelectedMarkerBuilderPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Popup Outside of Map'),
          PopupOutsideOfMapPage.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Widget Between Popups and Markers'),
          WidgetBetweenPopupsAndMarkersPage.route,
          currentRoute,
        ),
      ],
    ),
  );
}
