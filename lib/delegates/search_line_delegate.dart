// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';

import '../models/models.dart';
import 'dart:math';

class SearchLineDelegate extends SearchDelegate {
  var col = 300;
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

    return ListView.separated(
      itemCount: _lineasFiltradas.length,
      itemBuilder: (context, index) {
        if (col == 300) {
          col = 600;
        } else {
          col = 300;
        }

        return ListTile(
          tileColor: Colors.green[col],
          onTap: () async {
            final linea = _lineasFiltradas[index];
            final result = await lineaBloc.getRecorrido(linea);

            close(context, result);
          },
          title: Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(Icons.bus_alert_sharp)),
              SizedBox(width: 120, child: Text(_lineasFiltradas[index].nombre)),
              const SizedBox(
                width: 25,
              ),
              Image.network(
                "http://res.cloudinary.com/drxr7czpf/image/upload/v1630622084/p4342jsygtdplzgtkbbd.jpg",
                width: 200,
                height: 120,
                alignment: Alignment.topRight,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(
          height: 5, color: Color.fromARGB(255, 106, 189, 108), thickness: 5),
    );
  }
}
