import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class Parada {
  final int paradaID;
  final LatLng coordenadas;

  Parada({required this.paradaID, required this.coordenadas});

  Map<String, dynamic> toMap() {
    return {
      'paradaID': paradaID,
      'longitud': coordenadas.longitude,
      'latitud': coordenadas.latitude,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Parada{paradaID: $paradaID, longitud: ${coordenadas.longitude}, latitud: ${coordenadas.latitude}}';
  }
}
