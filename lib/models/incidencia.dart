// To parse this JSON data, do
//
//     final incidencia = incidenciaFromJson(jsonString);

import 'dart:convert';

List<Incidencia> incidenciaFromJson(String str) => List<Incidencia>.from(json.decode(str).map((x) => Incidencia.fromJson(x)));

String incidenciaToJson(List<Incidencia> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Incidencia {
    int incidenciaId;
    int tipoIncidenciaId;    
    int areaId;
    int prioridadId;
    int usuarioId;
    //DateTime fechaSolicitado;
    String descripcion;
    int estado;
   

    Incidencia({
        required this.incidenciaId,
        required this.tipoIncidenciaId,
        required this.areaId,
        required this.prioridadId,
        required this.usuarioId,
       // required this.fechaSolicitado,
        required this.descripcion,
        required this.estado,

    });

    factory Incidencia.fromJson(Map<String, dynamic> json) => Incidencia(
        incidenciaId: json["incidenciaId"],
        tipoIncidenciaId: json["tipoIncidenciaId"],
        areaId: json["areaId"],
        prioridadId: json["prioridadId"],
        usuarioId: json["usuarioId"],
        //fechaSolicitado: json["fechaSolicitado"],
         /*fechaSolicitado: DateTime(
          json['fechaSolicitado'][0],
          json['fechaSolicitado'][1],
          json['fechaSolicitado'][2],
          json['fechaSolicitado'][3],
          json['fechaSolicitado'][4],
          json['fechaSolicitado'][5],
          json['fechaSolicitado'][6] ~/ 1000, // microseconds to milliseconds
        ),*/
        descripcion: json["descripcion"],
        estado: json["estado"],

    );

    Map<String, dynamic> toJson() => {
        "incidenciaId": incidenciaId,
        "tipoIncidenciaId": tipoIncidenciaId,
        "areaId": areaId,
        "prioridadId": prioridadId,
        "usuarioId": usuarioId,
        //"fechaSolicitado": fechaSolicitado,
        /* 'fechaSolicitado': [
        fechaSolicitado.year,
        fechaSolicitado.month,
        fechaSolicitado.day,
        fechaSolicitado.hour,
        fechaSolicitado.minute,
        fechaSolicitado.second,
        fechaSolicitado.millisecond * 1000, // milliseconds to microseconds
      ],*/
        "descripcion": descripcion,
        "estado": estado,

    };
}
