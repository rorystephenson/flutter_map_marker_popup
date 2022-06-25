import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup_example/popup_manager_example.dart';
import 'package:flutter_map_marker_popup_example/popup_option_controls.dart';
import 'package:flutter_map_marker_popup_example/simple_map_with_popups.dart';

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
          const Text('Popup Manager Example'),
          PopupManagerExample.route,
          currentRoute,
        ),
      ],
    ),
  );
}
