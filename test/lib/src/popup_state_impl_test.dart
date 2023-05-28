import 'package:flutter_map_marker_popup/src/controller/popup_controller_event.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';
import 'package:flutter_map_marker_popup/src/state/popup_state_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_wrapped_marker.dart';

void main() {
  group('PopupStateImpl', () {
    test('selectedMarkers', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelected: [popupSpecA],
      );
      expect(popupStateImpl.selectedMarkers, [markerA]);
    });

    test('isSelected with wrapped marker argument', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelected: [popupSpecA],
      );
      expect(popupStateImpl.isSelected(markerA), isTrue);
      expect(popupStateImpl.isSelected(wrappedMarkerA), isTrue);
      expect(popupStateImpl.isSelected(markerB), isFalse);
      expect(popupStateImpl.isSelected(wrappedMarkerB), isFalse);
    });

    test('isSelected with wrapped marker selected', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelected: [PopupSpec.wrap(wrappedMarkerA)],
      );
      expect(popupStateImpl.isSelected(markerA), isTrue);
      expect(popupStateImpl.isSelected(wrappedMarkerA), isTrue);
      expect(popupStateImpl.isSelected(markerB), isFalse);
      expect(popupStateImpl.isSelected(wrappedMarkerB), isFalse);
    });

    test('ShowPopupsAlsoForControllerEvent', () {
      final popupStateImpl = PopupStateImpl();
      int notifyCount = 0;
      popupStateImpl.addListener(() => notifyCount++);

      expect(popupStateImpl.selectedMarkers, isEmpty);
      popupStateImpl.applyEvent(
        ShowPopupsAlsoForControllerEvent(
          [popupSpecA],
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, [markerA]);
      popupStateImpl.applyEvent(
        ShowPopupsAlsoForControllerEvent(
          [popupSpecB],
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, [markerA, markerB]);

      expect(notifyCount, 2);
    });

    test('ShowPopupsOnlyForControllerEvent', () {
      final popupStateImpl = PopupStateImpl();
      int notifyCount = 0;
      popupStateImpl.addListener(() => notifyCount++);

      expect(popupStateImpl.selectedMarkers, isEmpty);
      popupStateImpl.applyEvent(
        ShowPopupsOnlyForControllerEvent(
          [popupSpecA],
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, [markerA]);
      popupStateImpl.applyEvent(
        ShowPopupsOnlyForControllerEvent(
          [popupSpecB],
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, [markerB]);

      expect(notifyCount, 2);
    });

    test('HideAllPopupsControllerEvent', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelected: [popupSpecA, popupSpecB],
      );
      int notifyCount = 0;
      popupStateImpl.addListener(() => notifyCount++);

      expect(popupStateImpl.selectedMarkers, [markerA, markerB]);
      popupStateImpl.applyEvent(
        const HideAllPopupsControllerEvent(disableAnimation: false),
      );
      expect(popupStateImpl.selectedMarkers, isEmpty);

      expect(notifyCount, 1);
    });

    test('HidePopupsWhereControllerEvent', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelected: [popupSpecA, popupSpecB],
      );
      int notifyCount = 0;
      popupStateImpl.addListener(() => notifyCount++);

      expect(popupStateImpl.selectedMarkers, [markerA, markerB]);
      popupStateImpl.applyEvent(
        HidePopupsWhereControllerEvent(
          (popupSpec) => popupSpec.marker.point == markerA.point,
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, [markerB]);
      popupStateImpl.applyEvent(
        HidePopupsWhereControllerEvent(
          (popupSpec) => popupSpec.marker.point == markerB.point,
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, isEmpty);

      expect(notifyCount, 2);
    });

    test('HidePopupsOnlyForControllerEvent', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelected: [popupSpecA, popupSpecB],
      );
      int notifyCount = 0;
      popupStateImpl.addListener(() => notifyCount++);

      expect(popupStateImpl.selectedMarkers, [markerA, markerB]);
      popupStateImpl.applyEvent(
        HidePopupsOnlyForControllerEvent(
          [popupSpecA],
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, [markerB]);
      popupStateImpl.applyEvent(
        HidePopupsOnlyForControllerEvent(
          [popupSpecB],
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, isEmpty);

      expect(notifyCount, 2);
    });

    test('TogglePopupControllerEvent', () {
      final popupStateImpl = PopupStateImpl();
      int notifyCount = 0;
      popupStateImpl.addListener(() => notifyCount++);

      expect(popupStateImpl.selectedMarkers, isEmpty);
      popupStateImpl.applyEvent(
        TogglePopupControllerEvent(
          popupSpecA,
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, [markerA]);
      popupStateImpl.applyEvent(
        TogglePopupControllerEvent(
          popupSpecB,
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, [markerA, markerB]);
      popupStateImpl.applyEvent(
        TogglePopupControllerEvent(
          popupSpecA,
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, [markerB]);
      popupStateImpl.applyEvent(
        TogglePopupControllerEvent(
          popupSpecB,
          disableAnimation: false,
        ),
      );
      expect(popupStateImpl.selectedMarkers, isEmpty);

      expect(notifyCount, 4);
    });
  });
}
