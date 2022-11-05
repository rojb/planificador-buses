import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';

class LineInfo extends StatelessWidget {
  const LineInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LineaBloc, LineaState>(
      builder: (context, state) {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Text(
                state.lineaActual!.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))
        ]);
      },
    );
  }
}
