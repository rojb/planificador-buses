part of 'planificador_bloc.dart';

abstract class PlanificadorEvent extends Equatable {
  const PlanificadorEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarketEvent extends PlanificadorEvent {}

class OnCancelManualMarketEvent extends PlanificadorEvent {}

class OnAddStartEvent extends PlanificadorEvent {
  final LatLng inicio;
  const OnAddStartEvent(this.inicio);
}

class OnAddDestinationEvent extends PlanificadorEvent {
  final LatLng destino;
  const OnAddDestinationEvent(this.destino);
}

class OnAddRoutesEvent extends PlanificadorEvent {
  final RutasTransbordo rutas;
  const OnAddRoutesEvent(this.rutas);
}

class OnAddRoutesErrorEvent extends PlanificadorEvent {
  final Map<String, String> error;

  const OnAddRoutesErrorEvent(this.error);
}

class OnActivatePlanificadorEvent extends PlanificadorEvent {}

class OnCancelPlanificadorEvent extends PlanificadorEvent {}

class OnAddTipoSeleccionEvent extends PlanificadorEvent {
  final String tipoSeleccion;
  const OnAddTipoSeleccionEvent(this.tipoSeleccion);
}

class OnRemoveRoutesErrorEvent extends PlanificadorEvent {}
