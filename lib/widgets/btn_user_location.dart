import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planificador_buses/blocs/blocs.dart';

class BtnCurrentUserLocation extends StatelessWidget {
  const BtnCurrentUserLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: FloatingActionButton(
          backgroundColor: Colors.green[600],
          heroTag: "btnUserLocation",
          //backgroundColor: Colors.green,
          elevation: 2,
          onPressed: () {
            final userLocation = locationBloc.state.lastKnowLocation;

            if (userLocation == null) return;
            mapBloc.moveCamera(userLocation);
          },
          child: const Icon(
            Icons.my_location_outlined,
            color: Colors.white,
          )),
    );
  }
}
