// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/delegates/search_line_delegate.dart';

import '../models/models.dart';

class BtnSearchLine extends StatelessWidget {
  const BtnSearchLine({super.key});
  void onSearchResults(BuildContext context, var result) async {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    if (result != null) {
      final LineaRecorrido destination = result;
      final points = destination.points;
      await mapBloc.drawRoutePolyline(destination);
      mapBloc.moveCamera(points[(points.length - 1) ~/ 2], zoom: 11.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btnSearchLine",
      onPressed: () async {
        final result =
            await showSearch(context: context, delegate: SearchLineDelegate());
        onSearchResults(context, result);
      },
      child: const Icon(Icons.bus_alert_rounded),
    );
  }
}
