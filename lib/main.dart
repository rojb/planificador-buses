import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/screens/loading_screen.dart';
import 'package:planificador_buses/screens/testDB.dart';
import 'package:shared_preferences/shared_preferences.dart';
/* import 'package:planificador_buses/screens/testDB.dart'; */

void main() => runApp(MultiBlocProvider(providers: [
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => LocationBloc()),
      BlocProvider(
          create: (context) =>
              MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
      BlocProvider(create: (context) => LineaBloc()),
      BlocProvider(create: (context) => PlanificadorBloc())
    ], child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  void initApp(LineaBloc lineaBloc) async {
    await lineaBloc.loadLineas();
  }

  @override
  Widget build(BuildContext context) {
    final lineaBloc = BlocProvider.of<LineaBloc>(context);
    initApp(lineaBloc);
    return MaterialApp(
      /*  home: DBTest(), */
      home: const LoadingScreen(),
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }
}
