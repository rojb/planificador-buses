import 'package:planificador_buses/models/edge.dart';

class Graphh {
  List<List<Edge>> adjList = [];
  Graphh(List<Edge> edges, int n) {
    for (int i = 0; i < n; i++) {
      adjList.add([]);
    }

    // agrega bordes al grafo dirigido
    for (Edge edge in edges) {
      adjList[edge.paradaIni.id - 2].add(edge);
    }
  }
}
