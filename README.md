# `flutter_map_marker_popup`

Makes adding marker popups to `flutter_map` easy.

This package is currently in early stages after I packaged up code that I used for a personal project to give back a little given how useful `flutter_map` has been for me.

If you have any suggestions/problems please don't hesitate to open an issue.

## Getting Started

See the `example/` directory for a demo app. Note that you can use whatever type you like for the `UUID` as long as it is comparable.

Warning: Make sure to call `dispose()` on the PopupController in your StatefulWidget's `dispose()` method as is done in the example, or in another suitable place if you know what you're doing.

This can be useful for passing through the data that you want to use to build the popup.

## Roadmap

- [ ] Allow dynamically sized popups, currently the size is fixed and the widget returned by the `popupBuilder` must respect that size.
- [ ] Document an example of using this with a marker clustering layer. This is how I use it myself and it works well.
- [ ] Prevent the user from needing to dispose of the PopupController themselves.
