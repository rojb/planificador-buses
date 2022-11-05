import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class LineaRecorrido {
  final List<LatLng> points;
  final double duration;
  final double distance;

  LineaRecorrido(
      {required this.points, required this.duration, required this.distance});
}
