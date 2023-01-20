// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/widgets/widgets.dart';
import 'package:planificador_buses/utils/constants.dart' as constants;
import '../models/models.dart';

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
              final result = await lineaBloc.getRecorrido(linea, 'ida');

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
            String tipo = '';
            await showModalBottomSheet(
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                context: context,
                builder: (context) {
                  void setTipo(String tipoRecorrido) {
                    tipo = tipoRecorrido;
                  }

                  return Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Elige el tipo de recorrido que deseas visualizar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(235, 255, 255, 255),
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BtnTipoRecorrido(
                              tipo: constants.TIPO_IDA,
                              setTipo: setTipo,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            BtnTipoRecorrido(
                              tipo: constants.TIPO_VUELTA,
                              setTipo: setTipo,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            BtnTipoRecorrido(
                              tipo: constants.TIPO_AMBOS,
                              setTipo: setTipo,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                });

            if (tipo != '') {
              final result = await lineaBloc.getRecorrido(linea, tipo);
              close(context, result);
            }
          },
          title: Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(Icons.bus_alert_sharp)),
              SizedBox(
                  width: 120,
                  child: Text(
                    _lineasFiltradas[index].nombre,
                    style: const TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                width: 25,
              ),
              Image.network(
                _lineasFiltradas[index].foto!,
                width: 150,
                height: 120,
                fit: BoxFit.contain,
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
