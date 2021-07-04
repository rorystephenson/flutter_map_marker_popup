# `flutter_map_marker_popup`

Makes adding marker popups to [`flutter_map`](https://github.com/fleaflet/flutter_map) easy.

If you have any suggestions/problems please don't hesitate to open an issue.

## Getting Started

For a minimal code example have a look at [SimpleMapWithPopups](https://github.com/rorystephenson/flutter_map_marker_popup/blob/master/example/lib/simple_map_with_popups.dart).

For a complete example which demonstrates all of the various options available try running the demo app in the `example/` directory which results in the following:

![Example](https://github.com/rorystephenson/project_gifs/blob/master/flutter_map_marker_popup/demo.gif)

## FAQ

* Why is the popup not showing when I tap the marker?

   Make sure you don't have a GestureDetector in your Marker's builder which is preventing this plugin from detecting the Marker tap.

## Clustering

If you want both marker popups and marker clustering, this plugin's popup functionality has been integrated in to the wonderful [flutter_map_marker_cluster](https://github.com/lpongetti/flutter_map_marker_cluster) plugin.

## Thanks

A huge thanks to the contributors of `flutter_map` and the `flutter_map_marker_popup`. I use them together in a large personal project and they work wonderfully.
