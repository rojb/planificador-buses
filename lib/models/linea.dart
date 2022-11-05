class Linea {
  final String lineaID;
  final String nombre;
  final String? imagen;

  const Linea({required this.lineaID, required this.nombre, this.imagen});

  Map<String, dynamic> toMap() {
    return {
      'lineaID': lineaID,
      'nombre': nombre,
      'imagen': imagen,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Linea{lineaID: $lineaID, nombre: $nombre, imagen: $imagen}';
  }
}
