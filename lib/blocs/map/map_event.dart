part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  final GoogleMapController controller;

  const OnMapInitializedEvent(this.controller);
}

class OnStartFollowingUserEvent extends MapEvent {}

class OnStopFollowingUserEvent extends MapEvent {}

class OnUpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userLocations;

  const OnUpdateUserPolylineEvent(this.userLocations);
}

class OnToggleUserRouteEvent extends MapEvent {}

class OnDisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  const OnDisplayPolylinesEvent(this.polylines, this.markers);
}

class OnHidePolylinesEvent extends MapEvent {}
