import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/db/db.dart';
import 'package:planificador_buses/models/linea_recorrido.dart';

class BtnGenerarRecorrido extends StatelessWidget {
  const BtnGenerarRecorrido({super.key});

  @override
  Widget build(BuildContext context) {
    void onSearchResults(BuildContext context, var result) async {
      final mapBloc = BlocProvider.of<MapBloc>(context);
      if (result != null) {
        final LineaRecorrido destination = result;
        final points = destination.puntosIda;
        mapBloc.drawRoutePolyline(destination);
        mapBloc.moveCamera(points[(points.length - 1) ~/ 2], zoom: 15.5);
      }
    }

    return FloatingActionButton(
      backgroundColor: const Color.fromARGB(255, 236, 102, 13),
      onPressed: () {
        final planificadorBloc = BlocProvider.of<PlanificadorBloc>(context);
        final lineaBloc = BlocProvider.of<LineaBloc>(context);
        final mapBloc = BlocProvider.of<MapBloc>(context);
        lineaBloc.add(OnHidingLineInformationEvent());
        mapBloc.add(OnHidePolylinesEvent());

        if (planificadorBloc.state.displayPlanificador == true) {
          planificadorBloc.add(OnCancelPlanificadorEvent());
          return;
        }
        planificadorBloc.add(OnActivatePlanificadorEvent());
      },
      child: const Icon(Icons.route),
    );
  }
}
