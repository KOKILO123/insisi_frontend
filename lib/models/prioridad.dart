class Prioridad {
  final int prioridadId;
  final String nombre;
  final String descripcion;
  final int estado;

  Prioridad({
    required this.prioridadId,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  factory Prioridad.fromJson(Map<String, dynamic> json) {
    return Prioridad(
      prioridadId: json['prioridadId'],
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
