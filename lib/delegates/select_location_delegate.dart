import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/utils/constants.dart';

class SelectLocationDelegate extends SearchDelegate {
  final String tipo;

  SelectLocationDelegate(this.tipo) : super(searchFieldLabel: 'Buscar');

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
          final result = 'hi';
          close(context, result);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);

    return BlocBuilder<PlanificadorBloc, PlanificadorState>(
      builder: (context, state) {
        /*   final places = searchBloc.state.places; */
        return Text('Hello');
        /* ListView.separated(
          itemBuilder: (context, index) {
            /*  final place = places[index]; */
            return ListTile(
              title: Text(place.text),
              subtitle: Text(place.placeName),
              leading: const Icon(
                Icons.place_outlined,
                color: Colors.black,
              ),
              onTap: () {
                final result = 'hii';
                close(context, result);
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: places.length,
        ); */
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(
            Icons.location_on_rounded,
            color: (tipo == TIPO_IDA) ? Colors.green : Colors.red,
          ),
          title: Text(
            'Seleccionar en el mapa',
            style: TextStyle(
                color: (tipo == TIPO_IDA) ? Colors.green : Colors.red),
          ),
          onTap: () {
            final planificadorBloc = BlocProvider.of<PlanificadorBloc>(context);
            if (tipo == TIPO_IDA) {
              planificadorBloc.add(OnAddTipoSeleccionEvent(tipo));
            }
            if (tipo == TIPO_VUELTA) {
              planificadorBloc.add(OnAddTipoSeleccionEvent(tipo));
            }
            planificadorBloc.add(OnActivateManualMarketEvent());
            close(context, 'listo');
          },
        )
      ],
    );
  }
}
