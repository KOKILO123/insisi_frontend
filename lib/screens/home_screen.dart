import 'package:flutter/material.dart';
import 'package:insisi/providers/dashboard_provider.dart';
import 'package:insisi/providers/usuario_provider.dart';
import 'package:insisi/util/colors.dart';
import 'package:insisi/widgets/Info_card.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final dashBoardProvider=Provider.of<DashboardProvider>(context); 

    // Definir variables para almacenar los valores de cada tabla
    int incidenciaCount = 0;
    int incidenciaIdx = 0;
    int usuarioCount = 0;
    int usuarioIdx = 0;
    int aplicacionCount = 0;
    int aplicacionIdx = 0;
    int areaCount = 0;
    int areaIdx = 0;
    int institucionCount = 0;
    int institucionIdx = 0;
    int prioridadCount = 0;
    int prioridadIdx = 0;
    int tipoIncidenciaCount = 0;
    int tipoIncidenciaIdx= 0;
    int tipoUsuarioCount = 0;
    int tipoUsuarioIdx = 0;

     for (var item in dashBoardProvider.dashBoard) {
      switch (item.tabla) {
        case 'INCIDENCIA':
          incidenciaCount = item.cantidad;
          incidenciaIdx = item.id;
          break;
        case 'USUARIO':
          usuarioCount = item.cantidad;
          usuarioIdx = item.id;
          break;
        case 'APLICACION':
          aplicacionCount = item.cantidad;
          aplicacionIdx = item.id;
          break;
        case 'AREA':
          areaCount = item.cantidad;
          areaIdx = item.id;
          break;
        case 'INSTITUCION':
          institucionCount = item.cantidad;
          institucionIdx = item.id;
          break;
        case 'PRIORIDAD':
          prioridadCount = item.cantidad;
          prioridadIdx = item.id;
          break;
        case 'TIPO_INCIDENCIA':
          tipoIncidenciaCount = item.cantidad;
          tipoIncidenciaIdx = item.id;
          break;
        case 'TIPO_USUARIO':
          tipoUsuarioCount = item.cantidad;
          tipoUsuarioIdx = item.id;
          break;
      }
    }


    String usuario = usuarioProvider.usuarios.first.usuario;
    int usuarioId = usuarioProvider.usuarios.first.usuarioId;
    int areId = usuarioProvider.usuarios.first.areaId;
    String usuarioNombre = usuarioProvider.usuarios.first.nombre;


  String? selectedUsuario;
  final TextEditingController txtClave = TextEditingController();
  final TextEditingController txtIncidencia = TextEditingController();

     return Scaffold(
      backgroundColor: miColors.colorMaestroFondo,
      appBar: CustomAppBar(
        title: 'Dashboard',
        onLogout: () {
          Navigator.pushReplacementNamed(context, 'login');
        },
      ),
     body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: [
                  InfoCard(title: 'Incidencia', value: incidenciaCount.toString(), icon: Icons.add_call, color: Colors.blue, id: institucionIdx.toString()),
                  InfoCard(title: 'Usuarios', value: usuarioCount.toString(), icon: Icons.people, color: Colors.green, id: usuarioIdx.toString()),
                  InfoCard(title: 'Aplicacion', value: aplicacionCount.toString(), icon: Icons.add_moderator, color: Color.fromARGB(255, 147, 175, 76), id: aplicacionIdx.toString()),
                  InfoCard(title: 'Area', value: areaCount.toString(), icon: Icons.app_registration_sharp, color: Colors.orange, id: areaIdx.toString()),
                  InfoCard(title: 'Institucion', value: institucionCount.toString(), icon: Icons.house_sharp, color: Color.fromARGB(255, 92, 39, 176), id: institucionIdx.toString()),
                  InfoCard(title: 'Prioridad', value: prioridadCount.toString(), icon: Icons.low_priority, color: Color.fromARGB(255, 176, 39, 123), id: prioridadIdx.toString()),
                  InfoCard(title: 'Tipo Incidencia', value: tipoIncidenciaCount.toString(), icon: Icons.add_link_outlined, color: Colors.purple, id: tipoIncidenciaIdx.toString()),
                  InfoCard(title: 'Tipo Usuario', value: tipoUsuarioCount.toString(), icon: Icons.switch_account_rounded, color: Color.fromARGB(255, 39, 94, 176), id: tipoUsuarioIdx.toString()),
                ],
        ),
      ),
    );
  }
}
