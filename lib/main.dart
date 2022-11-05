import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/screens/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
/* import 'package:planificador_buses/screens/testDB.dart'; */

void main() => runApp(MultiBlocProvider(providers: [
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => LocationBloc()),
      BlocProvider(
          create: (context) =>
              MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
      BlocProvider(create: (context) => LineaBloc())
    ], child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  void initApp(LineaBloc lineaBloc) async {
    final preferences = await SharedPreferences.getInstance();
    final bool? isFirstRun = preferences.getBool('isFirstRun');
    if (isFirstRun == null) {
      await lineaBloc.initApp();
    }

    await lineaBloc.loadLineas();
  }

  @override
  Widget build(BuildContext context) {
    final lineaBloc = BlocProvider.of<LineaBloc>(context);
    initApp(lineaBloc);
    return MaterialApp(
      home: const LoadingScreen(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}
