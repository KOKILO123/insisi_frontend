class TipoIncidencia {
  final int tipoIncidenciaId;
  final int aplicacionId;
  final String nombre;
  final String descripcion;
  final int estado;

  TipoIncidencia({
    required this.tipoIncidenciaId,
    required this.aplicacionId,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  factory TipoIncidencia.fromJson(Map<String, dynamic> json) {
    return TipoIncidencia(
      tipoIncidenciaId: json['tipoIncidenciaId'],
      aplicacionId: json['aplicacionId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aplicacionId': aplicacionId,
      'nombre': nombre,
      'descripcion': descripcion,
      'estado': estado,
    };
  }
}
