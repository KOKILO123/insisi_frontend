import 'dart:convert';

List<Menus> menusFromJson(String str) =>
    List<Menus>.from(json.decode(str).map((x) => Menus.fromJson(x)));

String menusToJson(List<Menus> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Menus {
  Menus({
    required this.menuId,
    required this.tipoUsuarioId,
    required this.menu,
    required this.tipoUsuario,
  });

  int menuId;
  int tipoUsuarioId;
  String menu;
  String tipoUsuario;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        menuId: json["menuId"],
        tipoUsuarioId: json["tipoUsuarioId"],
        menu: json["menu"],
        tipoUsuario: json["tipoUsuario"],
      );

  Map<String, dynamic> toJson() => {
        "menuId": menuId,
        "tipoUsuarioId": tipoUsuarioId,
        "menu": menu,
        "tipoUsuario": tipoUsuario,
      };
}
