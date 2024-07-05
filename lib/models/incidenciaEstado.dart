class IncidenciaEstado {
  final int incidenciaEstadoId;
  final String nombre;
  final String descripcion;
  final int estado;

  IncidenciaEstado({
    required this.incidenciaEstadoId,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  factory IncidenciaEstado.fromJson(Map<String, dynamic> json) {
    return IncidenciaEstado(
      incidenciaEstadoId: json['incidenciaEstadoId'],
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
