import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/delegates/search_line_delegate.dart';

import '../models/models.dart';

class ShowLine extends StatelessWidget {
  const ShowLine({super.key});

  @override
  Widget build(BuildContext context) {
    void onSearchResults(BuildContext context, var result) async {
      final mapBloc = BlocProvider.of<MapBloc>(context);

      if (result != null) {
        final LineaRecorrido destination = result;
        final points = destination.puntosIda;
        mapBloc.drawRoutePolyline(destination);
        mapBloc.moveCamera(points[(points.length - 1) ~/ 2], zoom: 11.5);
      }
    }

    return BlocBuilder<LineaBloc, LineaState>(
      builder: (context, state) {
        if (state.displayLine == true) {
          showSearch(context: context, delegate: SearchLineDelegate())
              .then((value) => onSearchResults(context, value));
        }
        return const SizedBox();
      },
    );
  }
}
