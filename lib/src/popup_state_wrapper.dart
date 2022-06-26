import 'package:flutter/widgets.dart';
import 'package:flutter_map_marker_popup/src/popup_scope.dart';

import 'popup_state.dart';

class PopupStateWrapper extends StatelessWidget {
  final Widget Function(BuildContext context, PopupState popupState) builder;

  const PopupStateWrapper({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final popupState = PopupState.maybeOf(context, listen: false);
    if (popupState != null) return builder(context, popupState);

    return PopupScope(
      child: Builder(
        builder: (BuildContext context) => builder(
          context,
          PopupState.maybeOf(context, listen: false)!,
        ),
      ),
    );
  }
}
