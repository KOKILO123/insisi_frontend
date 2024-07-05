class Area {
  final int areaId;
  final String nombre;
  final String descripcion;
  final int estado;

  Area({
    required this.areaId,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      areaId: json['areaId'],
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
