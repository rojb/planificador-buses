import 'package:planificador_buses/models/models.dart';

class Recorrido {
  final int recorridoID;
  final String lineaCod;
  final String tipo;
  final double? tiempo;
  final double? distancia;
  final int? velocidad;
  final String? colorLinea;
  final double? grosor;
  final String? descripcion;
  final List<RecorridoParada> puntos;

  const Recorrido(
      {required this.recorridoID,
      required this.lineaCod,
      required this.tipo,
      this.tiempo,
      this.distancia,
      this.velocidad,
      this.colorLinea,
      this.grosor,
      this.descripcion,
      required this.puntos});

  Map<String, dynamic> toMap() {
    return {
      'recorridoID': recorridoID,
      'lineaCod': lineaCod,
      'tipo': tipo,
      'tiempo': tiempo,
      'distancia': distancia,
      'velocidad': velocidad,
      'colorLinea': colorLinea,
      'grosor': grosor,
      'descripcion': descripcion,
      'puntos': puntos
    };
  }

  // Implement toString to make it easier to see information about
  // each property when using the print statement.
  @override
  String toString() {
    return 'Recorrido{recorridoID: $recorridoID,  lineaCod: $lineaCod, tipo: $tipo, tiempo: $tiempo, distancia: $distancia, velocidad: $velocidad, colorLinea: $colorLinea, grosor: $grosor, descripcion: $descripcion';
  }
}
