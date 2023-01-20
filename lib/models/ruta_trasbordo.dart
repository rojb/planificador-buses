import 'package:planificador_buses/models/ksp_response.dart';
import 'package:planificador_buses/models/models.dart';

class RutasTransbordo {
  final List<KspResponse> listaRutas;
  final List<List<Parada>> transbordos;
  final List<List<String>> listaLineas;

  RutasTransbordo(this.listaRutas, this.transbordos, this.listaLineas);
}
