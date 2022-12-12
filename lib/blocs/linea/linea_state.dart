part of 'linea_bloc.dart';

class LineaState extends Equatable {
  final List<Linea> lineas;
  final List<LatLng> recorridoActual;
  final Linea? lineaActual;
  final bool mostrandoLinea;
  final DatosRecorridoActual? datosRecorridoActual;

  const LineaState({
    List<Linea>? lineas,
    List<LatLng>? recorridoActual,
    this.lineaActual,
    this.mostrandoLinea = false,
    this.datosRecorridoActual,
  })  : lineas = lineas ?? const [],
        recorridoActual = recorridoActual ?? const [];

  LineaState copyWith(
          {List<Linea>? lineas,
          List<LatLng>? recorridoActual,
          Linea? lineaActual,
          bool? mostrandoLinea,
          DatosRecorridoActual? datosRecorridoActual}) =>
      LineaState(
          lineas: lineas ?? this.lineas,
          recorridoActual: recorridoActual ?? this.recorridoActual,
          lineaActual: lineaActual ?? this.lineaActual,
          mostrandoLinea: mostrandoLinea ?? this.mostrandoLinea,
          datosRecorridoActual:
              datosRecorridoActual ?? this.datosRecorridoActual);
  @override
  List<Object?> get props => [
        lineas,
        recorridoActual,
        lineaActual,
        mostrandoLinea,
        datosRecorridoActual
      ];
}
