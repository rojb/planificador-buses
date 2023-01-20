import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:planificador_buses/models/models.dart';

class LineaRecorrido {
  final List<LatLng> puntosIda;
  final List<LatLng> puntosVuelta;
  final double duration;
  final double distance;
  final String tipoRecorridoSeleccionado;
  final List<LatLng>? transbordo;
  final List<String>? listaLineas;

  LineaRecorrido(
      {required this.puntosIda,
      required this.puntosVuelta,
      required this.duration,
      required this.distance,
      required this.tipoRecorridoSeleccionado,
      this.transbordo,
      this.listaLineas});
}
