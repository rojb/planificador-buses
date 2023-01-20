import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';

class LineInfo extends StatelessWidget {
  const LineInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LineaBloc, LineaState>(
      builder: (context, state) {
        if (state.lineaActual != null) {
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 50, 134, 190),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.lineaActual!.nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        const Text('Recorrido Ida:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(width: 5),
                        Container(
                          width: 25,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: state
                                  .datosRecorridoActual!.colorRecorridoIda),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        const Text('Recorrido Vuelta:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(width: 5),
                        Container(
                          width: 25,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: state
                                  .datosRecorridoActual!.colorRecorridoVuelta),
                        ),
                      ],
                    )
                  ],
                ))
          ]);
        }
        return const SizedBox();
      },
    );
  }
}
