import 'package:planificador_buses/models/parada.dart';

class Recorrido {
  final String lineaID;
  final int orden;
  final Parada paradaIni;
  final Parada paradaSig;
  final double? distancia;

  const Recorrido(
      {required this.lineaID,
      required this.orden,
      required this.paradaIni,
      required this.paradaSig,
      this.distancia});

  Map<String, dynamic> toMap() {
    return {
      'lineaID': lineaID,
      'orden': orden,
      'paradaIni': paradaIni,
      'paradaSig': paradaSig,
      'distancia': distancia,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Recorrido{lineaID: $lineaID, orden: $orden, paradaIni: ${paradaIni.toString()}, paradaSig: ${paradaSig.toString()}, distancia: $distancia}';
  }
}
