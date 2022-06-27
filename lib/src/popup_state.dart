import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:provider/provider.dart';

import 'popup_state_impl.dart';

abstract class PopupState with ChangeNotifier {
  /// The [Marker]s for which a popup is currently showing if there is one.
  List<Marker> get selectedMarkers;

  factory PopupState({List<Marker> initiallySelectedMarkers}) = PopupStateImpl;

  bool isSelected(Marker marker);

  static PopupState? maybeOf(BuildContext context, {bool listen = true}) {
    return Provider.of<PopupState?>(context, listen: listen);
  }
}
