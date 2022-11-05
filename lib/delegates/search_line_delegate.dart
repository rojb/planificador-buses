// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';

import '../models/models.dart';

class SearchLineDelegate extends SearchDelegate {
  List<Linea> _lineasFiltradas = [];
  SearchLineDelegate() : super(searchFieldLabel: 'Buscar');
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    final lineaBloc = BlocProvider.of<LineaBloc>(context);

    return ListView.builder(
        itemCount: _lineasFiltradas.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              final linea = _lineasFiltradas[index];
              final result = await lineaBloc.getRecorrido(linea);

              close(context, result);
            },
            title: Row(
              children: [
                const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.bus_alert_sharp)),
                Text(_lineasFiltradas[index].nombre)
              ],
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final lineaBloc = BlocProvider.of<LineaBloc>(context);
    _lineasFiltradas = lineaBloc.state.lineas
        .where(
          (linea) =>
              linea.nombre.toLowerCase().contains(query.trim().toLowerCase()),
        )
        .toList();
    ;

    return ListView.builder(
        itemCount: _lineasFiltradas.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              final linea = _lineasFiltradas[index];
              final result = await lineaBloc.getRecorrido(linea);

              close(context, result);
            },
            title: Row(
              children: [
                const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.bus_alert_sharp)),
                Text(_lineasFiltradas[index].nombre)
              ],
            ),
          );
        });
  }
}
