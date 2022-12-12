import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class LineaRecorrido {
  final List<LatLng> puntosIda;
  final List<LatLng> puntosVuelta;
  final double duration;
  final double distance;

  LineaRecorrido(
      {required this.puntosIda,
      required this.puntosVuelta,
      required this.duration,
      required this.distance});
}
