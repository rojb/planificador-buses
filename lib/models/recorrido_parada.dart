import 'package:planificador_buses/models/models.dart';

class RecorridoParada {
  final int recorridoParadaID;
  final int orden;
  final Parada paradaIni;
  final Parada paradaSig;
  final double distancia;
  final double tiempo;

  const RecorridoParada({
    required this.recorridoParadaID,
    required this.orden,
    required this.paradaIni,
    required this.paradaSig,
    required this.distancia,
    required this.tiempo,
  });

  Map<String, dynamic> toMap() {
    return {
      'recorridoParadaID': recorridoParadaID,
      'orden': orden,
      'paradaIni': paradaIni,
      'paradaSig': paradaSig,
      'distancia': distancia,
      'tiempo': tiempo
    };
  }

  // Implement toString to make it easier to see information about
  // each property when using the print statement.
  @override
  String toString() {
    return 'RecorridoParada{recorridoID: $recorridoParadaID,  orden: $orden, paradaIni: ${paradaIni.toString()}, paradaSig: ${paradaSig.toString()}, $distancia, $tiempo';
  }
}
