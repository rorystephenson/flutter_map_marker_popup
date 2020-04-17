import 'package:latlong/latlong.dart';

class MapPopup<T> {
  final T uuid;
  final LatLng point;

  MapPopup(this.uuid, this.point);
}
