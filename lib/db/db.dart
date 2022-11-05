import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planificador_buses/db/data.dart';
import 'package:planificador_buses/models/models.dart';

class DB {
  Future<Database> _openDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'geo_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          """
        CREATE TABLE linea
          (lineaID varchar(10) PRIMARY KEY NOT NULL,  
          nombre varchar(30) NOT NULL,
          imagen varchar(50));

        """,
        );
        await db.execute(
          """ CREATE TABLE parada(
	            paradaID int PRIMARY KEY NOT NULL,
	            longitud float NOT NULL,
	            latitud float NOT NULL);""",
        );

        await db.execute(
          """CREATE TABLE recorrido
          (lineaID varchar(10) NOT NULL,
          orden int NOT NULL,
          paradaIni int NOT NULL,
          paradaSig int NOT NULL,
          distancia float,
          PRIMARY KEY(lineaID, paradaIni),
          FOREIGN KEY(lineaID) REFERENCES linea(lineaID),
          FOREIGN KEY(paradaIni) REFERENCES parada(paradaID),
          FOREIGN KEY(paradaSig) REFERENCES parada(paradaID));""",
        );
      },
      version: 1,
    );
  }

  Future<void> insertStops() async {
    final db = await _openDatabase();
    await db.rawInsert(insertParada);
  }

  Future<void> insertLines() async {
    final db = await _openDatabase();
    await db.rawInsert(insert);
  }

  Future<void> insertRoutes() async {
    final db = await _openDatabase();
    await db.rawInsert(insertRecorrido);
  }

  Future<List<Linea>> lines() async {
    final db = await _openDatabase();

    final List<Map<String, dynamic>> maps = await db.query('linea');

    return List.generate(maps.length, (i) {
      return Linea(
        lineaID: maps[i]['lineaID'],
        nombre: maps[i]['nombre'],
        imagen: maps[i]['imagen'],
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
        lineaID: maps[i]['lineaID'],
        nombre: maps[i]['nombre'],
        imagen: maps[i]['imagen'],
      );
    });
  }

  Future<List<Parada>> stops() async {
    final db = await _openDatabase();

    final List<Map<String, dynamic>> maps = await db.query('parada');

    return List.generate(maps.length, (i) {
      return Parada(
        paradaID: maps[i]['paradaID'],
        coordenadas: LatLng(maps[i]['latitud'], maps[i]['longitud']),
      );
    });
  }

  Future<List<Recorrido>> route(String lineId) async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery("""
          SELECT lineaID, orden, paradaIni, paradaSig, distancia, i.longitud as longitudIni,i.latitud as latitudIni, s.longitud as longitudSig,s.latitud as latitudSig
          FROM recorrido
          LEFT JOIN parada i ON i.paradaID= recorrido.paradaIni
          LEFT JOIN parada s ON s.paradaID = recorrido.paradaSig
          WHERE recorrido.lineaID = '$lineId'
          ORDER BY recorrido.orden
    """);

    return List.generate(maps.length, (i) {
      return Recorrido(
        lineaID: maps[i]['lineaID'],
        orden: maps[i]['orden'],
        paradaIni: Parada(
            paradaID: maps[i]['paradaIni'],
            coordenadas: LatLng(maps[i]['latitudIni'], maps[i]['longitudIni'])),
        paradaSig: Parada(
            paradaID: maps[i]['paradaSig'],
            coordenadas: LatLng(maps[i]['latitudSig'], maps[i]['longitudSig'])),
        distancia: maps[i]['distancia'],
      );
    });
  }
}
