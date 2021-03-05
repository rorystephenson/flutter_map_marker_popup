import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong/latlong.dart';

import 'example_popup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marker Popup Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapPageScaffold(PopupSnap.markerTop),
    );
  }
}

class MapPageScaffold extends StatelessWidget {
  final PopupSnap popupSnap;

  MapPageScaffold(this.popupSnap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Marker Popup Demo')),
      body: MapPage(popupSnap),
      floatingActionButton: _buttonToSwitchSnap(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buttonToSwitchSnap(BuildContext context) {
    /// Note this plugin doesn't currently support changing the snap type
    /// dynamically. To demo different snap types this rebuilds the page with
    /// the new snap type. If you have a use case for dynamically changing the
    /// snap please create a GitHub Issue describing the use case.
    return Padding(
      padding: EdgeInsets.only(top: kToolbarHeight),
      child: FloatingActionButton.extended(
        label: Text(_isFirstSnap ? 'Snap mapBottom' : 'Snap markerTop'),
        onPressed: () {
          final newSnap =
              _isFirstSnap ? PopupSnap.mapBottom : PopupSnap.markerTop;
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => MapPageScaffold(newSnap),
            ),
          );
        },
        icon: Icon(
            _isFirstSnap ? Icons.vertical_align_bottom_rounded : Icons.message),
        backgroundColor: Colors.green,
      ),
    );
  }

  bool get _isFirstSnap => popupSnap == PopupSnap.markerTop;
}

class MapPage extends StatefulWidget {
  final PopupSnap popupSnap;

  MapPage(this.popupSnap, {Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static final List<LatLng> _points = [
    LatLng(44.421, 10.404),
    LatLng(45.683, 10.839),
    LatLng(45.246, 5.783),
  ];

  static const _markerSize = 40.0;
  List<Marker> _markers;

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();

    _markers = _points
        .map(
          (LatLng point) => Marker(
            point: point,
            width: _markerSize,
            height: _markerSize,
            builder: (_) => Icon(Icons.location_on, size: _markerSize),
            anchorPos: AnchorPos.align(AnchorAlign.top),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        zoom: 5.0,
        center: _points.first,
        plugins: [PopupMarkerPlugin()],
        onTap: (_) => _popupLayerController
            .hidePopup(), // Hide popup when the map is tapped.
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        PopupMarkerLayerOptions(
          markers: _markers,
          popupSnap: widget.popupSnap,
          popupController: _popupLayerController,
          popupBuilder: (BuildContext _, Marker marker) => ExamplePopup(marker),
        ),
      ],
    );
  }
}
