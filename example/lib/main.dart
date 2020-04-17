import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marker Popup Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapPage(),
      builder: (context, navigator) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Marker Popup Demo"),
          ),
          body: navigator,
        );
      },
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const _markerSize = 40.0;

  static final LatLng _centerPosition = LatLng(44.421, 10.404);
  static final LatLng _secondPosition = LatLng(45.683, 10.839);
  static final LatLng _thirdPosition = LatLng(45.246, 5.783);
  static final List<LatLng> points = [
    _centerPosition,
    _secondPosition,
    _thirdPosition,
  ];

  List<MarkerWithPopup> _markers;

  PopupLayerController _popupLayerController = PopupLayerController();

  @override
  void initState() {
    super.initState();

    _markers = points
        .map(
          (LatLng point) => MarkerWithPopup(
            uuid: point,
            showMarker: (_, uuid, point) =>
                _popupLayerController.togglePopup(uuid, point),
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
      options: new MapOptions(
        zoom: 5.0,
        center: _centerPosition,
        onTap: (pos) => _popupLayerController.hidePopup(),
        plugins: [PopupMarkerPlugin()],
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: _markers,
        ),
        PopupMarkerLayerOptions(
          popupWidth: 200.0,
          popupHeight: 100.0,
          popupVerticalOffset: -_markerSize,
          popupLayerController: _popupLayerController,
          popupBuilder: (context, uuid) => Container(
            width: 200.0,
            height: 100.0,
            child: Text(uuid.toString()),
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _popupLayerController.dispose();
    super.dispose();
  }
}
