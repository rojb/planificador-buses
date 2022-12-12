import 'package:flutter/material.dart';
import 'package:planificador_buses/models/models.dart';

import '../db/db.dart';

class DBTest extends StatefulWidget {
  DBTest({super.key});

  @override
  State<DBTest> createState() => _DBTestState();
}

class _DBTestState extends State<DBTest> {
  final db = DB();
  void insertDB() async {
    /*   await db.insertLines();
    await db.insertStops();
    await db.insertRoutes(); */
    /*  print(await db.route('L001V')); */
    print('loaded');
  }

  @override
  Widget build(BuildContext context) {
    /*  insertDB(); */
    return Scaffold(
      appBar: AppBar(title: Text('Prueba')),
      body: FutureBuilder(
        future: DB().lines(),
        builder: (BuildContext context, AsyncSnapshot<List<Linea>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  final linea = snapshot.data![index];
                  return ListTile(
                    title: Text('${linea.cod} - ${linea.nombre} '),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: snapshot.data!.length);
          }
          return const Text('Cargando');
        },
      ),
    );
  }
}
