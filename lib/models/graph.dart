import 'dart:convert';
import 'dart:ffi';

import 'package:dijkstra/dijkstra.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planificador_buses/db/db.dart';
import 'package:planificador_buses/models/models.dart';
import 'package:planificador_buses/models/edge.dart';

class GraphI {
  List<RecorridoParada> recorridos = [];
  List<List<double>> matrizA = [];
  List<RecorridoParada> adjacencyList = [];
  int profundidad = 0;

  Future<List<List<double>>> generateMatrizA() async {
    List<List<double>> matriz = [];

    profundidad = await DB().getNroParadas();
    adjacencyList = await DB().getListaAdyacencia();
    for (var i = 0; i < profundidad - 1; i++) {
      List<double> fila = [];
      for (var j = 0; j < profundidad - 1; j++) {
        fila.add(0.0);
      }
      matriz.add(fila);
    }
    int index = 0;

    for (var i = 0; i < adjacencyList.length; i++) {
      // Diagonal
      /* matriz[index][index] = 0.0; */
      // Comprobamos que estamos dentro de la fila x
      if (index == adjacencyList[i].paradaIni.id - 2) {
        if (adjacencyList[i].paradaSig.id != index + 1 ||
            adjacencyList[i].paradaSig.id != 1) {
          matriz[index][adjacencyList[i].paradaSig.id - 2] =
              adjacencyList[i].tiempo;
        }
      } else {
        index = (adjacencyList[i].paradaIni.id) - 2;
        if (adjacencyList[i].paradaSig.id != index + 1) {
          if (adjacencyList[i].paradaSig.id != 1) {
            /*   print(index);
            print(adjacencyList[i].paradaSig.id); */

            matriz[index][adjacencyList[i].paradaSig.id - 2] =
                adjacencyList[i].tiempo;
          }
        }
      }
    }
/* 
    for (int i = 0; i < matrizA.length; i++) {
      for (int j = 0; j < matrizA[i].length; j++) {
        print('${matrizA[i][j]} \n');
      }
      print('\n');
    }
    print('\n'); */

    return matriz;
  }

  void shortestPathDijkstra(int src, int destino) async {
    /*  print(profundidad); */
    matrizA = await generateMatrizA();
    List<double> dist = [];
    List<bool> visitados = [];
    List<int> parent = [];

    for (var i = 0; i < profundidad - 1; i++) {
      dist.add(double.maxFinite);
      visitados.add(false);
      parent.add(-2);
    }
    dist[src] = 0;
    parent[0] = -1;
    for (var i = 0; i < profundidad - 2; i++) {
      int u = minDistancia(dist, visitados);
      visitados[u] = true;

      for (var j = 0; j < profundidad - 1; j++) {
        if (!visitados[j] &&
            matrizA[u][j] != 0.0 &&
            dist[u] != double.maxFinite &&
            dist[u] + matrizA[u][j] < dist[j]) {
          parent[j] = u;
          dist[j] = dist[u] + matrizA[u][j];
        }
      }
    }
    print("Vertex \t\t Distance from Source \n");
    for (int i = 0; i < profundidad - 1; i++) {
      if (dist[i] != double.maxFinite) {
        print("$i \t\t ${dist[i]} \n");
      }
    }

    print("Vertex \t\t number \n");
    for (int i = 0; i < profundidad - 1; i++) {
      if (parent[i] != -2) {
        print("$i \t\t   ${parent[i]} \n");
      }
    }
  }

  int minDistancia(List<double> dist, List<bool> visitados) {
    double min = double.maxFinite;
    int min_index = -1;
    for (var i = 0; i < profundidad - 1; i++) {
      if (visitados[i] == false && dist[i] <= min) {
        min = dist[i];
        min_index = i;
      }
    }
    return min_index;
  }

  void generarM() async {
    profundidad = await DB().getNroParadas();
    adjacencyList = await DB().getListaAdyacencia();
    Map graph = {};

    int index = adjacencyList[0].paradaIni.id;
    Map vertices = {};

    for (var i = 0; i < adjacencyList.length; i++) {
      if (adjacencyList[i].paradaIni.id == index) {
        if (adjacencyList[i].paradaSig.id != index ||
            adjacencyList[i].paradaSig.id != 1) {
          vertices
              .addAll({adjacencyList[i].paradaSig.id: adjacencyList[i].tiempo});
        }
      } else {
        graph.addAll({index: vertices});
        index = adjacencyList[i].paradaIni.id;
        vertices = {};
        if (adjacencyList[i].paradaSig.id != index ||
            adjacencyList[i].paradaSig.id != 1) {
          vertices
              .addAll({adjacencyList[i].paradaSig.id: adjacencyList[i].tiempo});
        }
      }

      if (i == adjacencyList.length - 1) {
        graph.addAll({index: vertices});
      }
    }

    // Not working

    var output2 = Dijkstra.findPathFromGraph(graph, 2, 1705);
    print(output2);
  }
}
