class TipoUsuario {
  final int tipoUsuarioId;
  final String nombre;
  final String descripcion;
  final int estado;

  TipoUsuario({
    required this.tipoUsuarioId,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  factory TipoUsuario.fromJson(Map<String, dynamic> json) {
    return TipoUsuario(
      tipoUsuarioId: json['tipoUsuarioId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'estado': estado,
    };
  }
}
