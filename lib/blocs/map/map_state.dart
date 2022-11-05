part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialize;
  final bool isFollowingUser;
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;
/*   final bool showMyRoute; */
/*
Polilineas
mi_ruta:{
  id: polyLineID Google,
  points:[[lat,long],[212,121],[121,212]],
  width:3,
  color:black.87
}
 */
  const MapState(
      {this.isMapInitialize = false,
      this.isFollowingUser = true,
      Map<String, Polyline>? polylines,
      Map<String, Marker>? markers})
      : polylines = polylines ?? const {},
        markers = markers ?? const {};

  MapState copyWith(
          {bool? isMapInitialize,
          bool? isFollowingUser,
          Map<String, Polyline>? polylines,
          Map<String, Marker>? markers}) =>
      MapState(
        isMapInitialize: isMapInitialize ?? this.isMapInitialize,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        polylines: polylines ?? this.polylines,
        markers: markers ?? this.markers,
      );
  @override
  List<Object> get props =>
      [isMapInitialize, isFollowingUser, polylines, markers];
}
