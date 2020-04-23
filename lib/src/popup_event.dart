import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/src/popup_event_actions.dart';

class PopupEvent {
  final Marker marker;
  final List<Marker> markers;
  final PopupEventActions action;

  PopupEvent.hideInList(this.markers)
      : this.marker = null,
        this.action = PopupEventActions.hideInList;

  PopupEvent.hideAny()
      : this.marker = null,
        this.markers = null,
        this.action = PopupEventActions.hideAny;

  PopupEvent.toggle(this.marker)
      : this.markers = null,
        this.action = PopupEventActions.toggle;

  PopupEvent.show(this.marker)
      : this.markers = null,
        this.action = PopupEventActions.show;
}
