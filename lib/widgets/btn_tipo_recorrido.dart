import 'package:flutter/material.dart';

class BtnTipoRecorrido extends StatelessWidget {
  final String tipo;
  final ValueSetter<String> setTipo;
  const BtnTipoRecorrido({Key? key, required this.tipo, required this.setTipo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue;
          }
          return const Color.fromARGB(255, 52, 75, 52);
        })),
        onPressed: () {
          setTipo(tipo);
          Navigator.pop(context);
        },
        child: Text(
          tipo.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ));
  }
}
