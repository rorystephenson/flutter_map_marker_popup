import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/src/controller/popup_controller_impl.dart';
import 'package:flutter_map_marker_popup/src/popup_spec.dart';

/// Used to programmatically show/hide popups and find out which markers
/// have visible popups.

abstract class PopupController {
  factory PopupController() = PopupControllerImpl;

  /// Show the popups for the given [markers]. If a popup is already showing for
  /// a given marker it remains visible.
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when showing the popups.
  void showPopupsAlsoFor(List<Marker> markers, {bool disableAnimation = false});

  /// Show the popups only for the given [markers]. All other popups will be
  /// hidden. If a popup is already showing for a given marker it remains
  /// visible.
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when showing/hiding the popups.
  void showPopupsOnlyFor(List<Marker> markers, {bool disableAnimation = false});

  /// Hide all popups that are showing.
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when hiding the popups.
  void hideAllPopups({bool disableAnimation = false});

  /// Hide popups for which the provided [test] return true.
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when hiding the popups.
  void hidePopupsWhere(
    bool Function(Marker marker) test, {
    bool disableAnimation = false,
  });

  /// Hide popups showing for any of the given markers.
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when hiding the popups.
  void hidePopupsOnlyFor(List<Marker> markers, {bool disableAnimation = false});

  /// Hide the popup if it is showing for the given [marker], otherwise show it
  /// for that [marker].
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when showing/hiding the popup.
  void togglePopup(Marker marker, {bool disableAnimation = false});

  /// Show the popups for the markers of the given [popupSpecs]. If a popup is
  /// already showing for a given marker it remains visible.
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when showing the popups.
  void showPopupsAlsoForSpecs(
    List<PopupSpec> popupSpecs, {
    bool disableAnimation = false,
  });

  /// Show the popups only for markers of the given [popupSpecs]. All other
  /// popups will be hidden. If a popup is already showing for a given marker
  /// it remains visible.
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when showing/hiding the popups.
  void showPopupsOnlyForSpecs(
    List<PopupSpec> popupSpecs, {
    bool disableAnimation = false,
  });

  /// Hide popups for which the provided [test] return true.
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when hiding the popups.
  void hidePopupsWhereSpec(
    bool Function(PopupSpec popupSpec) test, {
    bool disableAnimation = false,
  });

  /// Hide popups showing for any of the markers of the given [popupSpecs].
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when hiding the popups.
  void hidePopupsOnlyForSpecs(
    List<PopupSpec> popupSpecs, {
    bool disableAnimation = false,
  });

  /// Hide the popup if it is showing for the marker of the given [popupSpec],
  /// otherwise show it for that [popupSpec].
  ///
  /// If [disableAnimation] is true and a popup animation is enabled then the
  /// animation will not be used when showing/hiding the popup.
  void togglePopupSpec(PopupSpec popupSpec, {bool disableAnimation = false});

  /// Should be called once the PopupController is no longer used.
  void dispose();
}
