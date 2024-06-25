import 'dart:convert';

List<DashBoard> dashBoardFromJson(String str) =>
    List<DashBoard>.from(json.decode(str).map((x) => DashBoard.fromJson(x)));

String dashBoardToJson(List<DashBoard> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DashBoard {
  DashBoard({
    required this.id,
    required this.cantidad,
    required this.tabla,
  });

  int id;
  int cantidad;
  String tabla;

  factory DashBoard.fromJson(Map<String, dynamic> json) => DashBoard(
        id: json["id"],
        cantidad: json["cantidad"],
        tabla: json["tabla"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cantidad": cantidad,
        "tabla": tabla,
      };
}
