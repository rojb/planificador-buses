import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planificador_buses/blocs/blocs.dart';
import 'package:planificador_buses/models/models.dart';

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
/*     _mapController!.setMapStyle(jsonEncode(gtaTheme)); */
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

  Future drawRoutePolyline(LineaRecorrido destination) async {
    final miRutaIda = Polyline(
      polylineId: const PolylineId('route-ida'),
      color: Colors.red,
      width: 5,
      points: destination.puntosIda,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
    final miRutaVuelta = Polyline(
      polylineId: const PolylineId('route-vuelta'),
      color: const Color.fromARGB(255, 31, 112, 35),
      width: 5,
      points: destination.puntosVuelta,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    final startMarkerIda = Marker(
      markerId: const MarkerId('start-ida'),
      position: destination.puntosIda.first,
    );
    final endMarkerIda = Marker(
        markerId: const MarkerId('end-ida'),
        position: destination.puntosIda.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

    final startMarkerVuelta = Marker(
      markerId: const MarkerId('start-vuelta'),
      position: destination.puntosVuelta.first,
    );
    final endMarkerVuelta = Marker(
        markerId: const MarkerId('end-vuelta'),
        position: destination.puntosVuelta.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start-ida'] = startMarkerIda;
    currentMarkers['end-ida'] = endMarkerIda;
    currentMarkers['start-vuelta'] = startMarkerVuelta;
    currentMarkers['end-vuelta'] = endMarkerVuelta;

    currentPolylines['route-ida'] = miRutaIda;
    currentPolylines['route-vuelta'] = miRutaVuelta;
    add(OnDisplayPolylinesEvent(currentPolylines, currentMarkers));
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
