import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
  }
  Future<void> initApp() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isFirstRun', true);
  }

  Future<void> loadLineas() async {
    final preferences = await SharedPreferences.getInstance();

    final bool isFirstRun = preferences.getBool('isFirstRun')!;
    if (isFirstRun == true) {
      await _db.insertLines();
      await _db.insertStops();
      await _db.insertRoutes();
      await preferences.setBool('isFirstRun', false);
    }

    final lineas = await _db.lines();
    add(OnLineaInitializedEvent(lineas));
  }

  Future<LineaRecorrido> getRecorrido(Linea linea) async {
    final recorrido = await _db.route(linea.lineaID);
    final points = recorrido.map((e) => e.paradaIni.coordenadas).toList();
    add(OnGetLineEvent(points, linea));
    add(OnShowingLineInformationEvent());
    return LineaRecorrido(points: points, duration: 0.0, distance: 0.0);
  }
}
