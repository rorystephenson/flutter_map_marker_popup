import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

// In a separate file so it can be exported individually in extension_api.dart
typedef PopupBuilder = Widget Function(BuildContext, Marker);
