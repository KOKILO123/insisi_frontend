class TipoUsuarioMenu {
  final int menuId;
  final int tipoUsuarioId;
  final int tipoUsuarioMenuId;
  final String menu;
  final String tipoUsuario;

  TipoUsuarioMenu({
    required this.menuId,
    required this.tipoUsuarioId,
    required this.tipoUsuarioMenuId,
    required this.menu,
    required this.tipoUsuario,
  });

  factory TipoUsuarioMenu.fromJson(Map<String, dynamic> json) {
    return TipoUsuarioMenu(
      menuId: json['menuId'],
      tipoUsuarioId: json['tipoUsuarioId'],
      tipoUsuarioMenuId: json['tipoUsuarioMenuId'],
      menu: json['menu'],
      tipoUsuario: json['tipoUsuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'tipoUsuarioId': tipoUsuarioId,
      'tipoUsuarioMenuId': tipoUsuarioMenuId,
      'menu': menu,
      'tipoUsuario': tipoUsuario,
    };
  }
}