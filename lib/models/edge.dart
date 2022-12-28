import 'package:planificador_buses/models/models.dart';

class Edge {
  Parada paradaIni;
  Parada paradaSig;
  double distancia;
  double tiempo;
/* double get  */
  Edge(
      {required this.paradaIni,
      required this.paradaSig,
      required this.distancia,
      required this.tiempo});
}
