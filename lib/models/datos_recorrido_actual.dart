import 'package:flutter/animation.dart';

class DatosRecorridoActual {
  final double distanciaIda;
  final double distanciaVuelta;
  final String colorLinea;
  final double tiempoRecorridoIda;
  final double tiempoRecorridoVuelta;
  final int velocidadPromedio;
  final Color colorRecorridoIda;
  final Color colorRecorridoVuelta;

  DatosRecorridoActual(
      {required this.distanciaIda,
      required this.distanciaVuelta,
      required this.tiempoRecorridoIda,
      required this.tiempoRecorridoVuelta,
      required this.colorLinea,
      required this.velocidadPromedio,
      required this.colorRecorridoIda,
      required this.colorRecorridoVuelta});
}
