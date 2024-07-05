// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

List<Usuario> usuarioFromJson(String str) => List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String usuarioToJson(List<Usuario> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Usuario {
    int usuarioId;
    int institucionId;
    int areaId;
    int tipoUsuarioid;
    String nombre;
    String usuario;
    String clave;
    int estado;
    /*dynamic token;
    int createdAt;
    dynamic updatedAt;
    dynamic createdBy;
    dynamic updatedBy;
    dynamic deletedBy;*/

    Usuario({
        required this.usuarioId,
        required this.institucionId,
        required this.areaId,
        required this.tipoUsuarioid,
        required this.nombre,
        required this.usuario,
        required this.clave,
        required this.estado,
         /*this.token,
        required this.createdAt,
         this.updatedAt,
         this.createdBy,
         this.updatedBy,
         this.deletedBy,*/
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        usuarioId: json["usuarioId"],
        institucionId: json["institucionId"],
        areaId: json["areaId"],
        tipoUsuarioid: json["tipoUsuarioid"],
        nombre: json["nombre"],
        usuario: json["usuario"],
        clave: json["clave"],
        estado: json["estado"],
        /*token: json["token"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        deletedBy: json["deletedBy"],*/
    );

    Map<String, dynamic> toJson() => {
        "usuarioId": usuarioId,
        "institucionId": institucionId,
        "areaId": areaId,
        "tipoUsuarioid": tipoUsuarioid,
        "nombre": nombre,
        "usuario": usuario,
        "clave": clave,
        "estado": estado,
        /*"token": token,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "deletedBy": deletedBy,*/
    };
}
