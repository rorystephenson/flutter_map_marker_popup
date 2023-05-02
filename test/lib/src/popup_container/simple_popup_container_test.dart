import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_wrapped_marker.dart';
import 'test_map.dart';

void main() {
  group('SimplePopupContainer', () {
    testWidgets('tapping marker toggles popup', (tester) async {
      await tester.pumpWidget(TestMap());

      await tester.tap(find.text('markerA'));
      await tester.pump();
      expect(find.text('popupA'), findsOneWidget);

      await tester.tap(find.text('markerA'));
      await tester.pump();
      expect(find.text('popupA'), findsNothing);
    });

    group('PopupController', () {
      testWidgets('showPopupsAlsoFor with original marker', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.showPopupsAlsoFor([markerA]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);

        popupController.showPopupsAlsoFor([markerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);
        expect(find.text('popupB'), findsOneWidget);
      });

      testWidgets('showPopupsAlsoFor with wrapped marker', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.showPopupsAlsoFor([wrappedMarkerA]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);

        popupController.showPopupsAlsoFor([wrappedMarkerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);
        expect(find.text('popupB'), findsOneWidget);
      });

      testWidgets('showPopupsOnlyFor with original marker', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.showPopupsOnlyFor([markerA]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);
        expect(find.text('popupB'), findsNothing);

        popupController.showPopupsOnlyFor([markerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
        expect(find.text('popupB'), findsOneWidget);
      });

      testWidgets('showPopupsOnlyFor with wrapped marker', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.showPopupsOnlyFor([wrappedMarkerA]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);
        expect(find.text('popupB'), findsNothing);

        popupController.showPopupsOnlyFor([wrappedMarkerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
        expect(find.text('popupB'), findsOneWidget);
      });

      testWidgets('hideAllPopups', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.showPopupsOnlyFor([markerA, markerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);
        expect(find.text('popupB'), findsOneWidget);

        popupController.hideAllPopups();
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
        expect(find.text('popupB'), findsNothing);
      });

      testWidgets('hidePopupsOnlyFor with original marker', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.showPopupsOnlyFor([markerA, markerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);
        expect(find.text('popupB'), findsOneWidget);

        popupController.hidePopupsOnlyFor([markerA]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
        expect(find.text('popupB'), findsOneWidget);

        popupController.hidePopupsOnlyFor([markerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
        expect(find.text('popupB'), findsNothing);
      });

      testWidgets('hidePopupsOnlyFor with wrapped marker', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.showPopupsOnlyFor([wrappedMarkerA, wrappedMarkerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);
        expect(find.text('popupB'), findsOneWidget);

        popupController.hidePopupsOnlyFor([wrappedMarkerA]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
        expect(find.text('popupB'), findsOneWidget);

        popupController.hidePopupsOnlyFor([wrappedMarkerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
        expect(find.text('popupB'), findsNothing);
      });

      testWidgets('togglePopup with original marker', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.togglePopup(markerA);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);

        popupController.togglePopup(markerA);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
      });

      testWidgets('togglePopup with wrapped marker', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.togglePopup(wrappedMarkerA);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);

        popupController.togglePopup(wrappedMarkerA);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
      });

      testWidgets('mixing wrapped and original markers', (tester) async {
        final popupController = PopupController();
        await tester.pumpWidget(TestMap(popupController: popupController));

        popupController.showPopupsAlsoFor([markerA, wrappedMarkerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);
        expect(find.text('popupB'), findsOneWidget);

        popupController.hidePopupsOnlyFor([wrappedMarkerA, markerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
        expect(find.text('popupB'), findsNothing);

        popupController.showPopupsOnlyFor([markerA, wrappedMarkerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);
        expect(find.text('popupB'), findsOneWidget);

        popupController.hidePopupsOnlyFor([wrappedMarkerA, markerB]);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
        expect(find.text('popupB'), findsNothing);

        popupController.togglePopup(markerA);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsOneWidget);

        popupController.togglePopup(wrappedMarkerA);
        await tester.pumpAndSettle();
        expect(find.text('popupA'), findsNothing);
      });
    });
  });
}
