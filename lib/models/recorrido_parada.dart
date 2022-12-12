import 'package:planificador_buses/models/models.dart';

class RecorridoParada {
  final int recorridoParadaID;
  final int orden;
  final Parada paradaIni;
  final Parada paradaSig;

  const RecorridoParada({
    required this.recorridoParadaID,
    required this.orden,
    required this.paradaIni,
    required this.paradaSig,
  });

  Map<String, dynamic> toMap() {
    return {
      'recorridoParadaID': recorridoParadaID,
      'orden': orden,
      'paradaIni': paradaIni,
      'paradaSig': paradaSig
    };
  }

  // Implement toString to make it easier to see information about
  // each property when using the print statement.
  @override
  String toString() {
    return 'RecorridoParada{recorridoID: $recorridoParadaID,  orden: $orden, paradaIni: ${paradaIni.toString()}, paradaSig: ${paradaSig.toString()}';
  }
}
