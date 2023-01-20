part of 'planificador_bloc.dart';

class PlanificadorState extends Equatable {
  final bool displayManualMarker;
  final bool displayPlanificador;
  final String? tipoSeleccion;
  final LatLng? inicio;
  final LatLng? destino;
  final RutasTransbordo? rutas;
  final Map<String, String>? error;

  /*  final List<Feature> places; */
  const PlanificadorState({
    this.displayManualMarker = false,
    this.displayPlanificador = false,
    this.tipoSeleccion,
    this.inicio,
    this.destino,
    this.rutas,
    error,
  }) : error = error ?? const {};

  PlanificadorState copyWith({
    bool? displayManualMarker,
    bool? displayPlanificador,
    String? tipoSeleccion,
    LatLng? inicio,
    LatLng? destino,
    Map<String, String>? error,
    RutasTransbordo? rutas,
  }) =>
      PlanificadorState(
          displayManualMarker: displayManualMarker ?? this.displayManualMarker,
          displayPlanificador: displayPlanificador ?? this.displayPlanificador,
          tipoSeleccion: tipoSeleccion ?? this.tipoSeleccion,
          inicio: inicio ?? this.inicio,
          destino: destino ?? this.destino,
          error: error ?? this.error,
          rutas: rutas ?? this.rutas);

  @override
  List<Object?> get props => [
        displayManualMarker,
        inicio,
        destino,
        rutas,
        error,
        displayPlanificador,
        tipoSeleccion
      ];
}
