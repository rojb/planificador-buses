import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planificador_buses/db/db.dart';
import 'package:planificador_buses/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'linea_event.dart';
part 'linea_state.dart';

class LineaBloc extends Bloc<LineaEvent, LineaState> {
  final _db = DB();
  LineaBloc() : super(const LineaState()) {
    on<OnLineaInitializedEvent>(
        (event, emit) => emit(state.copyWith(lineas: event.lineas)));

    on<OnGetLineEvent>((event, emit) => emit(state.copyWith(
        recorridoActual: event.recorridoActual,
        lineaActual: event.lineaActual)));
    on<OnShowingLineInformationEvent>(
        (event, emit) => emit(state.copyWith(mostrandoLinea: true)));
    on<OnHidingLineInformationEvent>(
        (event, emit) => emit(state.copyWith(mostrandoLinea: false)));
    on<OnAddingRouteEvent>((event, emit) =>
        emit(state.copyWith(datosRecorridoActual: event.datosRecorridoActual)));
  }
  Future<void> initApp() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isFirstRun', true);
  }

  Future<void> loadLineas() async {
    final lineas = await _db.lines();
    add(OnLineaInitializedEvent(lineas));
  }

  Future<LineaRecorrido> getRecorrido(Linea linea) async {
    final recorrido = await _db.route(linea.cod);

    final puntosIda = recorrido[0].puntos.map((e) {
      return e.paradaIni.coordenadas;
    }).toList();
    final puntosVuelta = recorrido[1].puntos.map((e) {
      return e.paradaIni.coordenadas;
    }).toList();
    /*   final points = recorrido.map((e) => e.paradaIni.coordenadas).toList();
    */
    final datos = DatosRecorridoActual(
        distanciaIda: recorrido[0].distancia!,
        distanciaVuelta: recorrido[1].distancia!,
        colorLinea: recorrido[0].colorLinea!,
        tiempoRecorridoIda: recorrido[0].tiempo!,
        tiempoRecorridoVuelta: recorrido[1].tiempo!,
        velocidadPromedio: recorrido[0].velocidad!,
        colorRecorridoIda: Colors.red,
        colorRecorridoVuelta: Colors.green);

    add(OnGetLineEvent(puntosIda, linea));
    add(OnAddingRouteEvent(datos));
    add(OnShowingLineInformationEvent());
    return LineaRecorrido(
        puntosIda: puntosIda,
        puntosVuelta: puntosVuelta,
        duration: 0.0,
        distance: 0.0);
  }
}
