class Aplicacion {
  final int aplicacionId;
  final String nombre;
  final String descripcion;
  final int estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic createdBy;
  final dynamic updatedBy;
  final dynamic deletedBy;

  Aplicacion({
    required this.aplicacionId,
    required this.nombre,
    required this.descripcion,
    required this.estado,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  factory Aplicacion.fromJson(Map<String, dynamic> json) {
    return Aplicacion(
      aplicacionId: json['aplicacionId'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedBy: json['deletedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
