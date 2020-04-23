## [0.0.1] - 17/04/20

* Initial release.

## [0.0.2] - 17/04/20

* Allow constraining of the uuid type.

## [0.0.3] - 17/04/20

* More detailed description
* Improve README.md

## [0.1.0] - 20/04/20

* Complete rewrite. Now PopupMarkerLayer is a replacement for MarkerLayer and
  is not compatible with the clustering plugin. Popups for the clustering plugin
  will be proposed via PR on the marker clustering project.

## [0.1.1] - 20/04/20

* Add example gif

## [0.1.2] - 22/04/20

* Possible to hide any of a list of markers. If the popup is showing for any of the provided markers it will be hidden. Otherwise nothing happens.
* Added `extension_api.dart` to be imported by plugins extending this one. This is initially for `flutter_map_marker_cluster`.

## [0.1.3] - 22/04/20

* Move `PopupBuilder` to its own file and export it in `extension_api.dart` so that it can be used without having to import the layer options.

## [0.1.4] - 23/04/20

* Fix bug where the popup state did not change when selected another marker when the popup was already showing.
* Add showPopupFor(Marker) method to PopupController if the user wants plain show behaviour instead of toggle behaviour.
