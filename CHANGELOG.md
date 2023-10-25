## 6.1.2 - 25/10/23

* BREAKING: flutter_map 6.0.1, despite the minor version change this introduced
  a breaking change which required a small fix.
* CHORE: Bump deps, fix some analysis issues from the new flutter lints.

## 6.1.1 - 15/10/23

* BUGFIX: Remove unused PopupSpec variables.

## 6.1.0 - 15/10/23

* BUGFIX: Correct the popup position when the map is rotated.

## 6.0.0 - 15/10/23

* BREAKING: flutter_map 6.0.0

## [5.3.0-dev.1] - 11/07/23

* BREAKING: flutter_map 6.0.0-dev.1.
* BREAKING: Marker's now declare anchor instead of anchorPos, this was the case
  case pre-5.2.0 but a change in flutter_map forced it to be changed in this
  plugin. This has now been changed back.
* BUGFIX: Make disableAnimation option work again for PopupController's:
  - togglePopupSpec
  - hidePopupsOnlyFor
  - hidePopupsWhere
  - showPopupsAlsoFor
  - showPopupsOnlyFor
  - togglePopup
* FEATURE: Example tidy up.

## [5.2.0] - 22/06/23

* BREAKING: flutter_map v5.
* BREAKING: latlong2 v0.9.0
* BREAKING: A change in flutter_map v5 means that you now declare anchorPos for
  Markers instead of Anchor. A PR has been accepted to change this back and
  will be released with flutter_map v6.
* FEATURE: More Marker anchor alignments are now supported.

## [5.1.0] - 28/05/23

* BREAKING: Requires dart 3.

## [5.0.0] - 28/05/23

This version includes extensive changes which were necessary to allow popups
from multiple marker layers to overlay their markers i.e. a PopupMarkerLayer
and a SuperclusterLayer can be displayed on the same map and their popups will
overlay both layers' markers.

* BREAKING: Now requires flutter_map 4.0.0 or higher.
* BREAKING: PopupController now has a dispose() method which must be called by
  the code that creates it.
* DEPRECATED: PopupMarkerLayerWidget is now called PopupMarkerLayer. 
* BREAKING: The following options are now part of PopupDisplayOptions:
  - popupBuilder (builder)
  - popupSnap (snap)
  - popupAnimation (animation)
* BREAKING: The following marker rotation options have been removed, they
  should be set on the markers themselves:
  - markerRotate
  - markerRotateAlignment
  - markerAnchorAlign
* BREAKING: The onPopupEvent's returned options have now changed. The
  selectedMarkers argument now contains the markers *after* the event and the
  events names have changed to reflect that they are past tense. The toggle
  event is also now removed and the relevant show/hide event will be called
  instead depending on whether the marker was visible or not.
* FEATURE: PopupController now has a hidePopupsWhere method which allows you to
  hide popups based on their markers.
* FEATURE: PopupScope has two new optional parameters:
  - popupController: Provide a controller to control visible popups.
  - onPopupEvent: A Function which is called whenever the PopupState emits an
    event.
* BREAKING: PopupStateWrapper is now replaced with InheritOrCreatePopupScope.
  It now supports onPopupEvent and initiallySelectedMarkers.
* DEPRECATED: PopupMarkerLayerOptions.rotationAlignmentFor has been replaced
  a new rotateAlignment extension method on AnchorAlign. So
  PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top) becomes
  AnchorAlign.top.rotationAlignment.

## [4.1.0] - 07/05/23

* Update flutter_map to 4.0.0.
* Change latlong2 version constraint to match flutter_map.

## [4.0.3] - 02/05/23

* Change marker comparison method so that FlutterMap plugins that use this plugin can wrap Markers
  with their own data and still have them match the original Markers as long as their hashCode
  matches the Marker.

## [4.0.2] - 04/04/23

* Reduce builds during fading of popups. Faded popups now only build once when fading in and once
  when fading out. Previously the popup builder would be called many times during fading.

## [4.0.1] - 10/09/22

* Fix regression in 4.0.0 which broke snap-to-map when the map was rotated.

## [4.0.0] - 10/09/22

* flutter_map v3. Thanks to [MooNag](https://github.com/MooNag) for the contribution!

## [3.2.0] - 28/07/22

* Support flutter_map v2.

## [3.1.0+1] - 27/06/22

* Improve the example for showing popups over the map.

## [3.1.0] - 27/06/22

* A new selectedMarkerBuilder option allows you to give selected Markers a
  different appearance/behaviour.

## [3.0.0] - 26/06/22

* Allow popups to be shown outside of the map if desired. A new example has
  been added demonstrating how this works.

## [2.2.1] - 10/06/22

* Fix a bug where the visible popup would disappear on rebuild if no
  PopupController was specified.

## [2.2.0] - 08/06/22

* Upgrade flutter_map dependency to 1.0.0. This is not backwards compatible due
  to a breaking change in the map movement stream which plugins rely on.

## [2.1.2] - 11/02/22

* Fix a bug where the map would jump around when centering on a Marker if another Marker was tapped
  before the centering finished.

## [2.1.1+1] - 11/02/22

* Fix example, the flutter_map onTap required an extra argument.

## [2.1.1] - 12/01/22

* Set onPopupEvent as an optional parameter for the PopupLayer otherwise a warning is generated when
  it is used by `flutter_map_marker_cluster`.

## [2.1.0] - 12/01/22

* Add the onPopupEvent callback.

## [2.0.1] - 31/10/21

* Fix a bug where popup showing/hiding might get stuck if a PopupController was not provided and the
  popup container layer changed position in the widget tree.

## [2.0.0] - 23/09/21

* Support multiple visible popups at once. The default behaviour remains single-popup but some
  breaking changes in PopupController were required:

    - hidePopups -> hideAllPopups
    - hidePopupIfShowingFor -> hidePopupsOnlyFor
    - showPopup -> showPopupsOnlyFor

  If you wish to show multiple popups at once you will want to change the default MarkerTapBehavior,
  see the documentation in PopupMarkerLayerOptions.

## [1.0.1] - 27/08/21

* Add an option to center the map on the marker when showing the popup.

## [1.0.0+2] - 04/07/21

* Add simple example.
* Remove pedantic lints in favour of flutter's built in lints.

## [1.0.0+1] - 11/06/21

* Add updated demo gif.

## [1.0.0] - 07/06/21

* Null safe
* Support rotation
* Many fixes and some extra control over the visible popup via PopupController

## [0.3.0] - 17/05/21

* PopupMarkerPlugin is removed and PopupMarkerPluginWidget is added. This plugin should now be added
  to FlutterMap as one of the 'children' instead of being added as a plugin.
* Showing/hiding of popups can now use a fade animation with a customisable duration and curve.
* Removed deprecated PopupSnap values, they have been replaced as follows:
    * left -> markerLeft
    * top -> markerTop
    * right -> markerRight
    * bottom -> markerBottom

## [0.2.1] - 05/03/21

* Move demo gif to separate repo so that the gif is not included when downloading this package.
* Updated demo gif to show new snapping behaviour.
* Added some thanks and links to related repos in READEME.md.
* Add documentation to make pub.dev happy.
* Add trailing newline to PopupSnap to make pub.dev happy.

## [0.2.0] - 18/02/21

* New dialog-snapping options added. Can now be snapped to the map rather than just the marker. Old
  marker snapping options have been deprecated in favour of more specific enums, so `left` now
  becomes `markerLeft` etc.

## [0.1.4] - 23/04/20

* Fix bug where the popup state did not change when selected another marker when the popup was
  already showing.
* Add showPopupFor(Marker) method to PopupController if the user wants plain show behaviour instead
  of toggle behaviour.

## [0.1.3] - 22/04/20

* Move `PopupBuilder` to its own file and export it in `extension_api.dart` so that it can be used
  without having to import the layer options.

## [0.1.2] - 22/04/20

* Possible to hide any of a list of markers. If the popup is showing for any of the provided markers
  it will be hidden. Otherwise nothing happens.
* Added `extension_api.dart` to be imported by plugins extending this one. This is initially
  for `flutter_map_marker_cluster`.

## [0.1.1] - 20/04/20

* Add example gif

## [0.1.0] - 20/04/20

* Complete rewrite. Now PopupMarkerLayer is a replacement for MarkerLayer and is not compatible with
  the clustering plugin. Popups for the clustering plugin will be proposed via PR on the marker
  clustering project.

## [0.0.3] - 17/04/20

* More detailed description
* Improve README.md

## [0.0.2] - 17/04/20

* Allow constraining of the uuid type.

## [0.0.1] - 17/04/20

* Initial release.
