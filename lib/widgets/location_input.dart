import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/delegates/select_location_delegate.dart';
import 'package:planificador_buses/utils/constants.dart';

import '../blocs/blocs.dart';

class LocationInput extends StatelessWidget {
  const LocationInput({
    Key? key,
    required this.size,
    required this.text,
    required this.tipo,
  }) : super(key: key);

  final Size size;
  final String text;
  final String tipo;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanificadorBloc, PlanificadorState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            final result = await showSearch(
                context: context, delegate: SelectLocationDelegate(tipo));
          },
          child: Container(
            width: size.width - 120,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
            child: (tipo == TIPO_IDA)
                ? Text(
                    (state.inicio != null)
                        ? text
                        : "Elige el inicio de la ruta",
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  )
                : Text(
                    (state.destino != null)
                        ? text
                        : "Elige el destino de la ruta",
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }
}
