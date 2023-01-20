import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planificador_buses/models/datos_recorrido_actual.dart';
import 'package:planificador_buses/models/ksp_response.dart';
import 'package:planificador_buses/models/linea_recorrido.dart';
import 'package:planificador_buses/models/models.dart';
import 'package:planificador_buses/models/ruta_trasbordo.dart';
import 'package:planificador_buses/models/trasbordo.dart';
import 'package:planificador_buses/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
part 'planificador_event.dart';
part 'planificador_state.dart';

class PlanificadorBloc extends Bloc<PlanificadorEvent, PlanificadorState> {
  PlanificadorBloc() : super(const PlanificadorState()) {
    on<OnActivateManualMarketEvent>((event, emit) {
      emit(state.copyWith(displayManualMarker: true));
    });
    on<OnCancelManualMarketEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: false)));
    on<OnAddStartEvent>(
        (event, emit) => emit(state.copyWith(inicio: event.inicio)));
    on<OnAddDestinationEvent>(
        (event, emit) => emit(state.copyWith(destino: event.destino)));
    on<OnAddRoutesEvent>(
        (event, emit) => emit(state.copyWith(rutas: event.rutas)));
    on<OnAddRoutesErrorEvent>(
        (event, emit) => emit(state.copyWith(error: event.error)));
    on<OnRemoveRoutesErrorEvent>(
        (event, emit) => emit(state.copyWith(error: {})));
    on<OnActivatePlanificadorEvent>(
        (event, emit) => emit(state.copyWith(displayPlanificador: true)));
    on<OnCancelPlanificadorEvent>(
        (event, emit) => emit(state.copyWith(displayPlanificador: false)));
    on<OnAddTipoSeleccionEvent>((event, emit) =>
        emit(state.copyWith(tipoSeleccion: event.tipoSeleccion)));
  }

  void setCoordenadas(String tipo, LatLng coordenadas) {
    if (tipo == TIPO_IDA) {
      print('$coordenadas f');
      add(OnAddStartEvent(coordenadas));
    }

    if (tipo == TIPO_VUELTA) {
      add(OnAddDestinationEvent(coordenadas));
      return;
    }
  }

  Future<String> KshortestPath(
      double latIni, double longIni, double latDest, double longDest) async {
    add(OnRemoveRoutesErrorEvent());
    const urlProducccion =
        'https://planificador-api.up.railway.app/api/dijkstra';
    const urlLocal = 'http://192.168.0.10:3000/api/dijkstra';

    final url =
        '$urlProducccion?latini=$latIni&longini=$longIni&latdest=$latDest&longdest=$longDest';
    final peticion = Uri.parse(url);

    final response = await http.get(peticion);
    if (response.statusCode == 400) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      add(OnAddRoutesEvent(RutasTransbordo([], [], [])));
      return json['msg'];
    }
    final List<dynamic> json = jsonDecode(response.body);
    final rutas =
        List.generate(json.length, (index) => KspResponse.fromMap(json[index]));

    List<List<Parada>> transbordos = [];
    List<List<String>> lineasTransbordos = [];
    List<KspResponse> listaRutas = [];

    for (KspResponse ksp in rutas) {
      listaRutas.add(ksp);
      final transbordo = setTransbordo(ksp);
      transbordos.add(transbordo.listaParada);
      lineasTransbordos.add(transbordo.lineaParada);
    }

    final rutasTransbordo =
        RutasTransbordo(listaRutas, transbordos, lineasTransbordos);
    add(OnAddRoutesEvent(rutasTransbordo));

    return NO_ERROR;
  }

  Transbordo setTransbordo(KspResponse listaLineas) {
    List<Parada> listaTransbordo = [];
    List<String> lineas = [];
/*     final listadoParadas = listaLineas.edges!.first!.paradaIni.lineas; */
    final paradaInicio = listaLineas.edges!.first!.paradaIni;
    listaTransbordo.add(paradaInicio);
    /*   final paradaFinal = listaLineas.edges!.last!.paradaSig; */
    /*    List<LineaCode?>? lineasAux = listaLineas.edges!.first!.paradaIni.lineas;
    List<LineaCode?>? lineasAux2 = listaLineas.edges!.first!.paradaIni.lineas; */
    String lineaSeleccionada = paradaInicio.lineas!.first!.lineaCod;
    lineas.add(lineaSeleccionada);
    for (Edge? edge in listaLineas.edges!) {
      /*   lineasAux2 = compararLinea(lineasAux, edge!.paradaSig.lineas);
      lineasAux2.forEach((element) {
        print(element!.lineaCod);
      });
      if (lineasAux2.isEmpty) {
        // Guardar una linea iremos
        lineasAux = lineasAux2;
        print(edge.paradaSig.lineas![0]);
        listaTransbordo.add(edge.paradaSig);
      } else {
        lineasAux = lineasAux2;
      } */

      final existe = edge!.paradaIni.lineas!
          .where((linea) => linea!.lineaCod == lineaSeleccionada);
      if (existe.isEmpty) {
        listaTransbordo.add(edge.paradaIni);
        lineaSeleccionada = edge.paradaIni.lineas!.first!.lineaCod;
        lineas.add(lineaSeleccionada);
      }
    }
    listaTransbordo.add(listaLineas.edges!.last!.paradaSig);

    return Transbordo(listaTransbordo, lineas);
  }

  List<LineaCode?> compararLinea(
      List<LineaCode?>? linea1, List<LineaCode?>? linea2) {
    List<LineaCode?> lineas = [];
    for (int i = 0; i < linea1!.length; i++) {
      List<LineaCode?> lineaAux = linea2!
          .where((linea) => linea!.lineaCod == linea1[i]!.lineaCod)
          .toList();
      if (lineaAux.isNotEmpty) {
        lineas.add(lineaAux.first);
      }
    }

    return lineas;
  }

  LineaRecorrido calcularRuta(
      KspResponse ksp, List<Parada> transbordo, List<String> listaLineas) {
    final puntosIda = ksp.edges!.map((e) {
      return e!.paradaIni.coordenadas;
    }).toList();
    final puntosTransbordo = transbordo.map((e) {
      return e.coordenadas;
    }).toList();
    puntosIda.add(ksp.edges!.last!.paradaSig.coordenadas);

    return LineaRecorrido(
        puntosIda: puntosIda,
        puntosVuelta: [],
        duration: ksp.totalCost!,
        distance: 0.0,
        transbordo: puntosTransbordo,
        listaLineas: listaLineas,
        tipoRecorridoSeleccionado: TIPO_RECORRIDO);
  }
}
