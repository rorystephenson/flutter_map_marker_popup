import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:provider/provider.dart';

import 'popup_state.dart';

class PopupScope extends StatelessWidget {
  final Widget child;

  /// The markers for which a popup should be initially visible.
  final List<Marker> initiallySelectedMarkers;

  const PopupScope({
    Key? key,
    this.initiallySelectedMarkers = const [],
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PopupState>(
      create: (context) => PopupState(
        initiallySelectedMarkers: initiallySelectedMarkers,
      ),
      child: child,
    );
  }
}
