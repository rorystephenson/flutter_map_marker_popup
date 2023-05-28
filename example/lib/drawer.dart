import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup_example/map_with_separate_popups.dart';

import 'popup_option_controls.dart';
import 'popup_outside_of_map.dart';
import 'selected_marker_builder.dart';
import 'simple_map_with_popups.dart';

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
          const Text('Full example'),
          PopupOptionControls.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Simple map with popups'),
          SimpleMapWithPopups.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Selected marker builder'),
          SelectedMarkerBuilder.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Popup outside of map example'),
          PopupOutsideOfMap.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Map with separate popups'),
          MapWithSeparatePopups.route,
          currentRoute,
        ),
      ],
    ),
  );
}
