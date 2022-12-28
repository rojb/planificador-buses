import 'dart:math';

import 'package:planificador_buses/db/db.dart';
import 'package:planificador_buses/models/linea.dart';
import 'package:planificador_buses/models/models.dart';

class Graph {
  late List<Linea> lineas;
  late Recorrido recorrido;
  late RecorridoParada recorridoParada;
  late List<Parada> paradas;

  Future<List<dynamic>> getGrafo() async {
    /*   List<Parada> vertices = [];
    var arcos = {};

    List<Recorrido> recorridos = [];
    await DB().lines().then((value) => lineas = value);
    await DB().stops().then((value) => paradas = value);
    /*   final lineaActual = lineas.first; */
    for (var i = 0; i < lineas.length; i++) {
      await DB().route(lineas[i].cod).then((value) {
        recorridos.add(value[0]);
        recorridos.add(value[1]);
      });
    }
    print('Entrando...');
    for (var i = 0; i < paradas.length; i++) {
      Parada paradaActual = paradas[i];
      if (!vertices.contains(paradaActual)) {
        vertices.add(paradaActual);
      }
      for (var i = 0; i < recorridos.length; i++) {
        Recorrido recorridoActual = recorridos[i];
        for (var puntosRecorrido in recorridoActual.puntos) {
          Parada paradaRecorridoActual = puntosRecorrido.paradaIni;

          if (paradaRecorridoActual.paradaID == paradaActual.paradaID) {
            arcos = {
              ...arcos,
              'vertice': {
                'origen': paradaActual.paradaID,
                'destino': puntosRecorrido.paradaSig.paradaID,
                'tiempo': Random()
              }
            };
          }
        }
      }
    }
    vertices.toString();
    arcos.toString(); */
    /* await DB().route(lineaActual.cod).then((value) => recorrido = value.first);
    for (RecorridoParada element in recorrido.puntos) {
      element.paradaIni;
    } */
    return [];
  }
}
