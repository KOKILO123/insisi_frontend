class Aplicacion {
  final int aplicacionId;
  final String nombre;
  final String descripcion;
  final int estado;

  Aplicacion({
    required this.aplicacionId,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  factory Aplicacion.fromJson(Map<String, dynamic> json) {
    return Aplicacion(
      aplicacionId: json['aplicacionId'],
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
