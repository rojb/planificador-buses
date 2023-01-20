import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:planificador_buses/models/ksp_response.dart';

class Parada {
  final int id;
  final int paradaID;
  final LatLng coordenadas;
  double? distancia;
  List<LineaCode?>? lineas;

  Parada(
      {required this.id,
      required this.paradaID,
      required this.coordenadas,
      this.distancia,
      this.lineas});

  factory Parada.fromJson(String str) => Parada.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Parada.fromMap(Map<String, dynamic> json) => Parada(
        id: json["id"],
        paradaID: json["paradaID"],
        coordenadas: LatLng(json["latitud"], json["longitud"]),
        lineas: json["lineas"] == null
            ? []
            : List<LineaCode>.from(
                json["lineas"]!.map((x) => LineaCode.fromMap(x))),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paradaID': paradaID,
      'longitud': coordenadas.longitude,
      'latitud': coordenadas.latitude,
      'distancia': distancia,
      "lineas": (lineas == null)
          ? []
          : List<dynamic>.from(lineas!.map((x) => x!.toMap()))
    };
  }

  // Implement toString to make it easier to see information about
  // each property when using the print statement.
  @override
  String toString() {
    return 'Parada{id: $id, paradaID: $paradaID, longitud: ${coordenadas.longitude}, latitud: ${coordenadas.latitude}}';
  }
}
