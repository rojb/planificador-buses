import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/models/models.dart';
import 'package:planificador_buses/models/polyline_result.dart';
import 'package:planificador_buses/utils/constants.dart' as constants;
part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  LatLng? mapCenter;
  GoogleMapController? _mapController;
  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);

    on<OnStartFollowingUserEvent>(_onStartFollowingUser);

    on<OnStopFollowingUserEvent>(
      (event, emit) => emit(state.copyWith(isFollowingUser: false)),
    );

    on<OnDisplayPolylinesEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));
    on<OnHidePolylinesEvent>((event, emit) => emit(
          state.copyWith(polylines: {}, markers: {}),
        ));
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    emit(state.copyWith(isMapInitialize: true));
  }

  void moveCamera(LatLng newLocation, {double zoom = 15.0}) {
    final cameraUpdate = CameraUpdate.newLatLngZoom(newLocation, zoom);
    _mapController?.animateCamera(cameraUpdate);
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKnowLocation == null) return;
    moveCamera(locationBloc.state.lastKnowLocation!);
  }

  PolylineResult drawPolylineRoute(String id, List<LatLng> puntos, Color color,
      List<LatLng> transbordos, List<String> lineas) {
    final Map<String, Polyline> currentPolylines = {};
    final Map<String, Marker> currentMarkers = {};
    final miRuta = Polyline(
      polylineId: PolylineId('route-$id'),
      color: color,
      width: 3,
      points: puntos,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    final startMarker = Marker(
        markerId: MarkerId('start-$id'),
        position: puntos.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Inicio ${lineas.first}', onTap: () {}));
    final endMarker = Marker(
      markerId: MarkerId('end-$id'),
      infoWindow: InfoWindow(title: 'Fin ${lineas.last}', onTap: () {}),
      position: puntos.last,
    );
    currentMarkers['start-$id'] = startMarker;
    for (int i = 1; i < transbordos.length - 1; i++) {
      final myMarker = Marker(
          markerId: MarkerId('marker-$i'),
          infoWindow: InfoWindow(
              title: 'Transbordo a línea ${lineas[i]}', onTap: () {}),
          position: transbordos[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange));
      currentMarkers['marker-$i'] = myMarker;
    }
    currentMarkers['end-$id'] = endMarker;
    currentPolylines['route-$id'] = miRuta;

    return PolylineResult(
        currentMarkers: currentMarkers, currentPolylines: currentPolylines);
  }

  PolylineResult drawPolyline(String id, List<LatLng> puntos, Color color) {
    final Map<String, Polyline> currentPolylines = {};
    final Map<String, Marker> currentMarkers = {};
    final miRuta = Polyline(
      polylineId: PolylineId('route-$id'),
      color: color,
      width: 3,
      points: puntos,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    final startMarker = Marker(
        markerId: MarkerId('start-$id'),
        position: puntos.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
    final endMarker = Marker(
      markerId: MarkerId('end-$id'),
      position: puntos.last,
    );

    currentMarkers['start-$id'] = startMarker;
    currentMarkers['end-$id'] = endMarker;
    currentPolylines['route-$id'] = miRuta;

    return PolylineResult(
        currentMarkers: currentMarkers, currentPolylines: currentPolylines);
  }

  void drawRoutePolyline(LineaRecorrido destination) {
    PolylineResult result;
    if (destination.tipoRecorridoSeleccionado == constants.TIPO_RECORRIDO) {}

    switch (destination.tipoRecorridoSeleccionado) {
      case constants.TIPO_IDA:
        result =
            drawPolyline(constants.TIPO_IDA, destination.puntosIda, Colors.red);
        add(OnDisplayPolylinesEvent(
            result.currentPolylines, result.currentMarkers));
        break;
      case constants.TIPO_VUELTA:
        result = drawPolyline(
            constants.TIPO_VUELTA, destination.puntosVuelta, Colors.green);
        add(OnDisplayPolylinesEvent(
            result.currentPolylines, result.currentMarkers));

        break;
      case constants.TIPO_RECORRIDO:
        result = drawPolylineRoute(
            constants.TIPO_RECORRIDO,
            destination.puntosIda,
            Colors.green,
            destination.transbordo!,
            destination.listaLineas!);
        add(OnDisplayPolylinesEvent(
            result.currentPolylines, result.currentMarkers));
        break;
      default:
        final ida =
            drawPolyline(constants.TIPO_IDA, destination.puntosIda, Colors.red);
        final vuelta = drawPolyline(
            constants.TIPO_VUELTA, destination.puntosVuelta, Colors.green);
        final newPolylines = {
          ...ida.currentPolylines,
          ...vuelta.currentPolylines
        };
        final newMarkers = {...ida.currentMarkers, ...vuelta.currentMarkers};
        add(OnDisplayPolylinesEvent(newPolylines, newMarkers));
    }
  }

  void startFollowingUser() {
    add(OnStartFollowingUserEvent());
  }

  void stopFollowingUser() {
    add(OnStopFollowingUserEvent());
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
