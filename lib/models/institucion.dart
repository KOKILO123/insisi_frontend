class Institucion {
  final int institucionId;
  final String nombre;
  final String descripcion;
  final String sigla;
  final int estado;

  Institucion({
    required this.institucionId,
    required this.nombre,
    required this.descripcion,
    required this.sigla,
    required this.estado,
  });

  factory Institucion.fromJson(Map<String, dynamic> json) {
    return Institucion(
      institucionId: json['institucionId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      sigla: json['sigla'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'sigla': sigla,
      'estado': estado,
    };
  }
}
