import 'package:flutter_map_marker_popup/src/popup_container/marker_with_key.dart';
import 'package:flutter_map_marker_popup/src/popup_state_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_wrapped_marker.dart';

void main() {
  group('PopupStateImpl', () {
    test('selectedMarkers', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelectedMarkers: [markerA],
      );
      expect(popupStateImpl.selectedMarkers, [markerA]);
    });

    test('isSelected with wrapped marker argument', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelectedMarkers: [markerA],
      );
      expect(popupStateImpl.isSelected(markerA), isTrue);
      expect(popupStateImpl.isSelected(wrappedMarkerA), isTrue);
      expect(popupStateImpl.isSelected(markerB), isFalse);
      expect(popupStateImpl.isSelected(wrappedMarkerB), isFalse);
    });

    test('isSelected with wrapped marker selected', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelectedMarkers: [wrappedMarkerA],
      );
      expect(popupStateImpl.isSelected(markerA), isTrue);
      expect(popupStateImpl.isSelected(wrappedMarkerA), isTrue);
      expect(popupStateImpl.isSelected(markerB), isFalse);
      expect(popupStateImpl.isSelected(wrappedMarkerB), isFalse);
    });

    test('addAll', () {
      final popupStateImpl = PopupStateImpl();
      int notifyCount = 0;
      popupStateImpl.addListener(() => notifyCount++);

      expect(popupStateImpl.isSelected(markerA), isFalse);
      expect(popupStateImpl.isSelected(markerB), isFalse);
      popupStateImpl.addAll([markerA, markerB].map(MarkerWithKey.wrap));
      expect(popupStateImpl.isSelected(markerA), isTrue);
      expect(popupStateImpl.isSelected(markerB), isTrue);

      expect(notifyCount, 1);
    });

    test('clear', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelectedMarkers: [markerA],
      );
      int notifyCount = 0;
      popupStateImpl.addListener(() => notifyCount++);

      popupStateImpl.clear();

      expect(popupStateImpl.selectedMarkers, isEmpty);
      expect(popupStateImpl.isSelected(markerA), isFalse);
      expect(popupStateImpl.isSelected(markerB), isFalse);

      expect(notifyCount, 1);
    });

    test('removeAll', () {
      final popupStateImpl = PopupStateImpl(
        initiallySelectedMarkers: [markerA, markerB],
      );
      int notifyCount = 0;
      popupStateImpl.addListener(() => notifyCount++);

      popupStateImpl.removeAll([markerB]);

      expect(popupStateImpl.selectedMarkers, [markerA]);
      expect(popupStateImpl.isSelected(markerA), isTrue);
      expect(popupStateImpl.isSelected(markerB), isFalse);

      expect(notifyCount, 1);
    });
  });
}
