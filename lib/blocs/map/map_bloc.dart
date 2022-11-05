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
    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.red,
      width: 5,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: destination.points.first,
    );
    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
    );
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    currentPolylines['route'] = myRoute;
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
