import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insisi/providers/usuario_provider.dart';
import 'package:insisi/util/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onLogout;

  CustomAppBar({required this.title, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    String usuarioNombre = usuarioProvider.usuarios.first.nombre;

    return AppBar(
      backgroundColor: miColors.colorMaestro,
      title: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16.0,
            color: miColors.colorTexto,
            fontWeight: FontWeight.bold,
          ),
          children: [
            const TextSpan(text: 'Usuario: '),
            TextSpan(
              text: usuarioNombre ?? '',
            ),
          ],
        ),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              size: 30.0,
              color: miColors.colorLogo,
            ),
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            onLogout();
          },
          icon: const Icon(
            Icons.exit_to_app,
            size: 30.0,
            color: miColors.colorLogo,
          ),
        ),
      ],
      
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
