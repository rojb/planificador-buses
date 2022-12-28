import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:planificador_buses/models/models.dart';

class DB {
  Future<Database> _openDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'geo_database.db');
    if (FileSystemEntity.typeSync(databasePath) ==
        FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'geo_database.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await File(databasePath).writeAsBytes(bytes);
    }
    return openDatabase(databasePath);
  }

  Future<List<Linea>> lines() async {
    final db = await _openDatabase();

    final List<Map<String, dynamic>> maps = await db.query('linea');

    return List.generate(maps.length, (i) {
      return Linea(
        cod: maps[i]['cod'],
        nombre: maps[i]['nombre'],
        direccion: maps[i]['direccion'],
        telefono: maps[i]['telefono'],
        email: maps[i]['email'],
        descripcion: maps[i]['descripcion'],
        foto: maps[i]['foto'],
      );
    });
  }

  Future<List<Linea>> searchLines(String name) async {
    final db = await _openDatabase();

    final List<Map<String, dynamic>> maps = await db.rawQuery("""  
          SELECT *
          FROM linea
          WHERE nombre LIKE '%$name%' 
    """);

    return List.generate(maps.length, (i) {
      return Linea(
        cod: maps[i]['cod'],
        nombre: maps[i]['nombre'],
        direccion: maps[i]['direccion'],
        telefono: maps[i]['telefono'],
        email: maps[i]['email'],
        descripcion: maps[i]['descripcion'],
        foto: maps[i]['foto'],
      );
    });
  }

  Future<List<Parada>> stops() async {
    final db = await _openDatabase();

    final List<Map<String, dynamic>> maps = await db.query('parada');

    return List.generate(maps.length, (i) {
      return Parada(
        id: maps[i]['id'],
        paradaID: maps[i]['paradaID'],
        coordenadas: LatLng(maps[i]['latitud'], maps[i]['longitud']),
      );
    });
  }

  Future<List<Recorrido>> route(String lineCod) async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> recorrido = await db.rawQuery(""" 
    SELECT * FROM recorrido
    WHERE lineaCod = '$lineCod';
    """);
    final List<Map<String, dynamic>> recorridoIda = await db.rawQuery("""
          SELECT recorrido.recorridoid, tipo, recorrido.tiempo, distancia, velocidad, color_linea,  descripcion, grosor, orden, i.longitud as longitud_ini, i.latitud as latitud_ini, i.paradaid as parada_ini, i.id as p_ini_id,  s.id as p_sig_id, s.paradaid as parada_sig,   s.longitud as longitud_sig,s.latitud as latitud_sig 
          FROM recorrido
          LEFT JOIN recorridoParada on recorridoParada.recorridoID = recorrido.recorridoID
          LEFT JOIN parada i on i.paradaID=recorridoParada.parada_ini
          LEFT JOIN parada s on s.paradaID=recorridoParada.parada_sig
          WHERE lineacod = '$lineCod' AND tipo = 'ida'
          ORDER by recorridoParada.orden
    """);
    final List<Map<String, dynamic>> recorridoVuelta = await db.rawQuery("""
          SELECT recorrido.recorridoid, tipo, recorrido.tiempo, distancia, velocidad, color_linea,  descripcion, grosor, orden, i.longitud as longitud_ini, i.latitud as latitud_ini, i.paradaid as parada_ini,  i.id as p_ini_id,  s.id as p_sig_id,  s.paradaid as parada_sig,   s.longitud as longitud_sig,s.latitud as latitud_sig 
          FROM recorrido
          LEFT JOIN recorridoParada on recorridoParada.recorridoID = recorrido.recorridoID
          LEFT JOIN parada i on i.paradaID=recorridoParada.parada_ini
          LEFT JOIN parada s on s.paradaID=recorridoParada.parada_sig
          WHERE lineacod = '$lineCod' AND tipo = 'vuelta'
          ORDER by recorridoParada.orden
    """);
    return List.generate(recorrido.length, (i) {
      return Recorrido(
          recorridoID: recorrido[i]['recorridoID'],
          lineaCod: recorrido[i]['lineaCod'],
          tipo: recorrido[i]['tipo'],
          tiempo: recorrido[i]['tiempo'],
          distancia: recorrido[i]['distancia'],
          velocidad: recorrido[i]['velocidad'],
          colorLinea: recorrido[i]['color_linea'],
          grosor: recorrido[i]['grosor'],
          descripcion: recorrido[i]['descripcion'],
          puntos: recorrido[i]['tipo']! == 'ida'
              ? List.generate(recorridoIda.length, (i) {
                  return RecorridoParada(
                    recorridoParadaID: recorridoIda[i]['recorridoID'],
                    orden: recorridoIda[i]['orden'],
                    paradaIni: Parada(
                        id: recorridoIda[i]['p_ini_id'],
                        paradaID: recorridoIda[i]['parada_ini'],
                        coordenadas: LatLng(recorridoIda[i]['latitud_ini'],
                            recorridoIda[i]['longitud_ini'])),
                    paradaSig: Parada(
                        id: recorridoIda[i]['p_sig_id'],
                        paradaID: recorridoIda[i]['parada_sig'],
                        coordenadas: LatLng(recorridoIda[i]['latitud_sig'],
                            recorridoIda[i]['longitud_sig'])),
                    distancia: 0,
                    tiempo: 0,
                  );
                })
              : List.generate(recorridoVuelta.length, (i) {
                  return RecorridoParada(
                    recorridoParadaID: recorridoVuelta[i]['recorridoID'],
                    orden: recorridoVuelta[i]['orden'],
                    paradaIni: Parada(
                        id: recorridoVuelta[i]['p_ini_id'],
                        paradaID: recorridoVuelta[i]['parada_ini'],
                        coordenadas: LatLng(recorridoVuelta[i]['latitud_ini'],
                            recorridoVuelta[i]['longitud_ini'])),
                    paradaSig: Parada(
                        id: recorridoVuelta[i]['p_sig_id'],
                        paradaID: recorridoVuelta[i]['parada_sig'],
                        coordenadas: LatLng(recorridoVuelta[i]['latitud_sig'],
                            recorridoVuelta[i]['longitud_sig'])),
                    distancia: 0,
                    tiempo: 0,
                  );
                }));
    });
  }

  Future<List<RecorridoParada>> getListaAdyacencia() async {
    final db = await _openDatabase();

    final List<Map<String, dynamic>> maps = await db.rawQuery("""  
          SELECT recorridoParada.recorridoID, i.id as p_ini_id,  i.longitud as longitud_ini, i.latitud as latitud_ini,  i.paradaid as parada_ini, s.id as p_sig_id, s.paradaid as parada_sig, s.longitud as longitud_sig,s.latitud as latitud_sig, tiempo, disxpunto  
          FROM recorridoParada
          LEFT JOIN parada i on i.paradaID=recorridoParada.parada_ini
          LEFT JOIN parada s on s.paradaID=recorridoParada.parada_sig
          WHERE parada_ini IN (SELECT parada.paradaID FROM parada) 
          GROUP BY parada_ini, parada_sig
          HAVING COUNT(parada_ini)>=0
          ORDER BY parada_ini asc
    """);

    return List.generate(maps.length, (i) {
      return RecorridoParada(
          recorridoParadaID: maps[i]['recorridoID'],
          orden: 0,
          paradaIni: Parada(
              id: maps[i]['p_ini_id'],
              paradaID: maps[i]['parada_ini'],
              coordenadas:
                  LatLng(maps[i]['latitud_ini'], maps[i]['longitud_ini'])),
          paradaSig: Parada(
              id: maps[i]['p_sig_id'],
              paradaID: maps[i]['parada_sig'],
              coordenadas:
                  LatLng(maps[i]['latitud_sig'], maps[i]['longitud_sig'])),
          distancia: maps[i]['disxpunto'],
          tiempo: maps[i]['tiempo']);
    });
  }

  Future<int> getNroParadas() async {
    final db = await _openDatabase();

    final List<Map<String, dynamic>> maps = await db.rawQuery("""  
          SELECT COUNT(id) as nroParada
          FROM parada;
    """);
    int al = maps[0]['nroParada'];

    return al;
  }
}
