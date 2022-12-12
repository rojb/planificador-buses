part of 'linea_bloc.dart';

abstract class LineaEvent extends Equatable {
  const LineaEvent();

  @override
  List<Object> get props => [];
}

class OnLineaInitializedEvent extends LineaEvent {
  final List<Linea> lineas;

  const OnLineaInitializedEvent(this.lineas);
}

class OnGetLineEvent extends LineaEvent {
  final List<LatLng> recorridoActual;
  final Linea lineaActual;
  const OnGetLineEvent(this.recorridoActual, this.lineaActual);
}

class OnSearchLineEvent extends LineaEvent {
  final List<Linea> lineasFiltradas;
  const OnSearchLineEvent(this.lineasFiltradas);
}

class OnShowingLineInformationEvent extends LineaEvent {}

class OnHidingLineInformationEvent extends LineaEvent {}

class OnAddingRouteEvent extends LineaEvent {
  final DatosRecorridoActual datosRecorridoActual;
  const OnAddingRouteEvent(this.datosRecorridoActual);
}
