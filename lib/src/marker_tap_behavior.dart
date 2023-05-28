import '../flutter_map_marker_popup.dart';

/// Controls what happens when a Marker is tapped.
class MarkerTapBehavior {
  final Function(
    PopupSpec popupSpec,
    PopupState popupState,
    PopupController popupController,
  ) _onTap;

  /// Toggle the popup of the tapped marker and hide all other popups. This is
  /// the recommended behavior if you only want to show one popup at a time.
  MarkerTapBehavior.togglePopupAndHideRest()
      : _onTap = ((
          PopupSpec popupSpec,
          PopupState popupState,
          PopupController popupController,
        ) {
          if (popupState.selectedPopupSpecs.contains(popupSpec)) {
            popupController.hideAllPopups();
          } else {
            popupController.showPopupsOnlyForSpecs([popupSpec]);
          }
        });

  /// Toggle the popup of the tapped marker and leave all other visible popups
  /// as they are. This is the recommended behavior if you want to show multiple
  /// popups at once.
  MarkerTapBehavior.togglePopup()
      : _onTap = ((
          PopupSpec popupSpec,
          PopupState popupState,
          PopupController popupController,
        ) {
          popupController.togglePopupSpec(popupSpec);
        });

  /// Do nothing when tapping the marker. This is useful if you want to control
  /// popups exclusively with the [PopupController].
  MarkerTapBehavior.none(
      Function(
    PopupSpec popupSpec,
    PopupState popupState,
    PopupController popupController,
  )
          onTap)
      : _onTap = ((_, __, ___) {});

  /// Define your own custom behavior when tapping a marker.
  MarkerTapBehavior.custom(
      Function(
    PopupSpec popupSpec,
    PopupState popupState,
    PopupController popupController,
  )
          onTap)
      : _onTap = onTap;

  void apply(
    PopupSpec popupSpec,
    PopupState popupState,
    PopupController popupController,
  ) =>
      _onTap(popupSpec, popupState, popupController);
}
