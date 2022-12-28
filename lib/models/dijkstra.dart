import 'package:planificador_buses/db/db.dart';
import 'package:planificador_buses/models/edge.dart';
import 'package:planificador_buses/models/graphh.dart';
import 'package:collection/collection.dart';
import 'package:planificador_buses/models/models.dart';
import 'package:planificador_buses/models/node.dart';

class Dijkstra {
/*   late Graphh grafo;
  late int profundidad;

  void maini() async {
    List<Parada> paradas = await DB().stops();
    grafo = await onInit();
    for (var i = 1; i < paradas.length; i++) {
      findShortestPath(paradas[i]);
    }
  }

  Future<Graphh> onInit() async {
    List<List<double>> matriz = [];

    profundidad = await DB().getNroParadas();
    final adjacencyList = await DB().getListaAdyacencia();

    List<Edge> edges = List.from(adjacencyList.map((e) {
      if (e.paradaSig.id != 1 || e.paradaSig.id != e.paradaIni.id) {
        return Edge(
            paradaIni: e.paradaIni,
            paradaSig: e.paradaSig,
            distancia: e.distancia,
            tiempo: e.tiempo);
      }
    }));
    Graphh newGraph = Graphh(edges, profundidad - 1);
    return newGraph;
  }

  void findShortestPath(Parada inicio) async {
    final pq = PriorityQueue<Node>(
      (p0, p1) => p0.peso.compareTo(p1.peso),
    );
    pq.add(Node(parada: inicio, peso: 0.0));

    List<double> dist = [];
    List<bool> visitados = [];
    List<int> prev = [];

    for (var i = 0; i < profundidad - 1; i++) {
      dist.add(double.maxFinite);
      visitados.add(false);
      prev.add(-2);
    }
    dist[inicio.id] = 0.0;
    visitados[inicio.id] = true;

    while (pq.isNotEmpty) {
      Node nodo = pq.removeFirst();
      int u = nodo.parada.id - 2;

      for (Edge edge in grafo.adjList[u]) {
        int v = edge.paradaSig.id - 2;
        double peso = edge.tiempo;

        if (!visitados[v] && (dist[u] + peso) < dist[v]) {
          dist[v] = dist[u] + peso;
          prev[v] = u;
          pq.add(Node(parada: edge.paradaSig, peso: dist[v]));
        }
      }
      visitados[u] = true;
    }
    List<int> route = [];
    for (var i = 0; i < profundidad - 1; i++) {
      if (i != inicio.id - 2 && dist[i] != double.maxFinite) {
        getRoute(prev, i, route);
        print(
            "Path (%${inicio.id - 2} —> %$i): Minimum cost = ${dist[i]}, Route = ${route.toString()}\n");
        route.clear();
      }
    }
  }

  void getRoute(List<int> prev, int i, List<int> route) {
    if (i >= 0) {
      getRoute(prev, prev[i], route);
      route.add(i);
    }
  } */

}
