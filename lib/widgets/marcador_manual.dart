import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/utils/constants.dart';

import '../blocs/blocs.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanificadorBloc, PlanificadorState>(
      builder: (context, state) {
        if (state.displayManualMarker) {
          return const _ManualMarkerBody();
        }
        if (state.displayManualMarker == false) {
          return const SizedBox();
        }
        return const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final planificadorBloc = BlocProvider.of<PlanificadorBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(children: [
        const Positioned(top: 50, left: 20, child: _BtnBack()),
        Center(
          child: Transform.translate(
            offset: const Offset(0, -22),
            child: BounceInDown(
              from: 100,
              child: Icon(
                Icons.location_on_rounded,
                size: 50,
                color: (planificadorBloc.state.tipoSeleccion == TIPO_IDA)
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          left: 40,
          child: FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: MaterialButton(
              onPressed: () async {
                final coordenadas = mapBloc.mapCenter;
                if (coordenadas == null) {
                  return;
                }
                final tipo = planificadorBloc.state.tipoSeleccion;
                planificadorBloc.setCoordenadas(tipo!, coordenadas);

                // ignore: use_build_context_synchronously
                planificadorBloc.add(OnCancelManualMarketEvent());
              },
              minWidth: size.width - 120,
              color: Colors.black,
              elevation: 0,
              height: 50,
              shape: const StadiumBorder(),
              child: const Text(
                'Confirmar destino',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Container(
            padding: const EdgeInsets.only(left: 5),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            final planificadorBloc = BlocProvider.of<PlanificadorBloc>(context);

            planificadorBloc.add(OnCancelManualMarketEvent());
          },
        ),
      ),
    );
  }
}
