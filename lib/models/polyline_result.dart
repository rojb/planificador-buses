import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineResult {
  final Map<String, Marker> currentMarkers;
  final Map<String, Polyline> currentPolylines;

  PolylineResult(
      {required this.currentMarkers, required this.currentPolylines});
}
