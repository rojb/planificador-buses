import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/widgets/line_info.dart';

class LineAppBar extends StatelessWidget {
  const LineAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final lineaBloc = BlocProvider.of<LineaBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return BlocBuilder<LineaBloc, LineaState>(
      builder: (context, state) {
        if (state.mostrandoLinea == true) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 15),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(25)),
                  child: IconButton(
                      onPressed: () {
                        lineaBloc.add(OnHidingLineInformationEvent());
                        mapBloc.add(OnHidePolylinesEvent());
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                ),
                const LineInfo()
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
