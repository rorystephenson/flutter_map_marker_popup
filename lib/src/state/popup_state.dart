import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:provider/provider.dart';

abstract class PopupState with ChangeNotifier {
  /// The [Marker]s for which a popup is currently showing if there is one.
  List<Marker> get selectedMarkers;

  /// The [PopupSpec]s for which a popup is currently showing if there is one.
  List<PopupSpec> get selectedPopupSpecs;

  /// Returns true if the [marker] is selected.
  bool isSelected(Marker marker);

  static PopupState? maybeOf(BuildContext context, {bool listen = true}) {
    return Provider.of<PopupState?>(context, listen: listen);
  }

  static PopupState of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ??
      (throw StateError(
          '`PopupState.of()` called in a context with no PopupState. Consider using PopupScope to add a PopupState to the context'));
}
