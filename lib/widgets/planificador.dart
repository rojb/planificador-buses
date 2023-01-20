import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/models/linea_recorrido.dart';
import 'package:planificador_buses/models/ruta_trasbordo.dart';
import 'package:planificador_buses/utils/constants.dart';
import 'package:planificador_buses/widgets/widgets.dart';

class Planificador extends StatelessWidget {
  const Planificador({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanificadorBloc, PlanificadorState>(
      builder: (context, state) {
        if (state.displayManualMarker) {
          return const SizedBox();
        }
        if (state.displayPlanificador) {
          return FadeInDown(
              duration: const Duration(milliseconds: 200),
              child: const _PlanificadorBody());
        }
        return const SizedBox();
      },
    );
  }
}

class _PlanificadorBody extends StatelessWidget {
  const _PlanificadorBody({super.key});

  void onSearchResults(BuildContext context, var result) async {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    if (result != null) {
      final LineaRecorrido destination = result;
      final points = destination.puntosIda;
      mapBloc.drawRoutePolyline(destination);
      mapBloc.moveCamera(points[(points.length - 1) ~/ 2], zoom: 15.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final planificadorBloc = BlocProvider.of<PlanificadorBloc>(context);
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: Column(
          children: [
            LocationInput(
              size: size,
              text: 'Punto A definido',
              tipo: TIPO_IDA,
            ),
            const SizedBox(
              height: 10,
            ),
            LocationInput(
              size: size,
              text: 'Punto B definido',
              tipo: TIPO_VUELTA,
            ),
            const SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () async {
                final puntoInicio = planificadorBloc.state.inicio;
                if (puntoInicio == null) {
                  return;
                }
                final puntoDestino = planificadorBloc.state.destino;
                if (puntoDestino == null) {
                  return;
                }
                /*       print(puntoDestino);
                print(puntoInicio); */
                showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                              color: Colors.green, strokeWidth: 8),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Obteniendo las rutas',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ));
                    });
                /* await planificadorBloc.getHttp(
                    puntoInicio.latitude,
                    puntoInicio.longitude,
                    puntoDestino.latitude,
                    puntoDestino.longitude); */

                final ks = await planificadorBloc.KshortestPath(
                    puntoInicio.latitude,
                    puntoInicio.longitude,
                    puntoDestino.latitude,
                    puntoDestino.longitude);

                Navigator.of(context).pop();

                if (ks != NO_ERROR) {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Se ha producido un error"),
                          content: Text(ks),
                          actions: [
                            MaterialButton(
                                child: const Text('Aceptar'),
                                onPressed: () {
                                  /*    planificadorBloc
                                      .add(OnRemoveRoutesErrorEvent()); */

                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      });
                  return;
                }
                await showModalBottomSheet(
                    backgroundColor: Colors.green,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    context: context,
                    builder: (context) {
                      return Container(
                          padding: const EdgeInsets.only(top: 15, bottom: 30),
                          child: ListView.builder(
                              itemCount: planificadorBloc
                                  .state.rutas!.listaRutas.length,
                              itemBuilder: (context, index) {
                                final ruta = planificadorBloc
                                    .state.rutas!.listaRutas[index];
                                final transbordos = planificadorBloc
                                    .state.rutas!.transbordos[index];
                                final listaLineas = planificadorBloc
                                    .state.rutas!.listaLineas[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.bus_alert,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'OPCIÓN ${index + 1}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tiempo estimado: ${ruta.totalCost!.round()} minutos aprox. ',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0),
                                        ),
                                        Text(
                                          'Número de transbordos: ${listaLineas.length}. ',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      final recorrido =
                                          planificadorBloc.calcularRuta(
                                              ruta, transbordos, listaLineas);
                                      onSearchResults(context, recorrido);

                                      planificadorBloc
                                          .add(OnCancelPlanificadorEvent());
                                      planificadorBloc.add(OnAddRoutesEvent(
                                          RutasTransbordo([], [], [])));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              }));
                    });
              },
              minWidth: 200,
              color: const Color.fromARGB(255, 236, 102, 13),
              elevation: 0,
              height: 50,
              shape: const StadiumBorder(),
              child: const Text(
                'PLANIFICAR VIAJE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
