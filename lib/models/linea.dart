class Linea {
  final String nombre;
  final String cod;
  final String? direccion;
  final String? telefono;
  final String? email;
  final String? foto;
  final String? descripcion;

  const Linea(
      {required this.nombre,
      required this.cod,
      this.direccion,
      this.telefono,
      this.email,
      this.foto,
      this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'cod': cod,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'foto': foto,
      'descripcion': descripcion
    };
  }

  // Implement toString to make it easier to see information about
  // each property when using the print statement.
  @override
  String toString() {
    return 'Linea{cod: $cod, nombre: $nombre,  direccion: $direccion, telefono: $telefono, email: $email, foto: $foto, descripcion: $descripcion}';
  }
}
