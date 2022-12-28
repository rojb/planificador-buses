import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class Parada {
  final int id;
  final int paradaID;
  final LatLng coordenadas;

  Parada({required this.id, required this.paradaID, required this.coordenadas});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paradaID': paradaID,
      'longitud': coordenadas.longitude,
      'latitud': coordenadas.latitude
    };
  }

  // Implement toString to make it easier to see information about
  // each property when using the print statement.
  @override
  String toString() {
    return 'Parada{id: $id, paradaID: $paradaID, longitud: ${coordenadas.longitude}, latitud: ${coordenadas.latitude}}';
  }
}
