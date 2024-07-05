import 'package:flutter/material.dart';
import 'package:insisi/providers/dashboard_provider.dart';
import 'package:insisi/providers/menus_provider.dart';
import 'package:insisi/providers/usuario_provider.dart';
import 'package:insisi/util/colors.dart';
import 'package:insisi/widgets/Info_card.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Map<String, String?>> _getSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    String? tipoUsuarioid = prefs.getString('tipoUsuarioid');
    String? usuarioNombre = prefs.getString('usuarioNombre');
    return {'tipoUsuarioid': tipoUsuarioid, 'usuarioNombre': usuarioNombre};
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final dashBoardProvider = Provider.of<DashboardProvider>(context, listen: false);
    final menuProvider = Provider.of<MenusProvider>(context, listen: false);

    return FutureBuilder<Map<String, String?>>(
      future: _getSessionData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final sessionData = snapshot.data!;
        dashBoardProvider.fetchDashboardItems();
        final int tipoUsuarioid = int.parse(sessionData['tipoUsuarioid']!);
        menuProvider.fetchMenusItems();

        int incidenciaCount = 0;
        int incidenciaIdx = 1;
        int usuarioCount = 0;
        int usuarioIdx = 2;
        int aplicacionCount = 0;
        int aplicacionIdx = 3;
        int areaCount = 0;
        int areaIdx = 4;
        int institucionCount = 0;
        int institucionIdx = 5;
        int prioridadCount = 0;
        int prioridadIdx = 6;
        int tipoIncidenciaCount = 0;
        int tipoIncidenciaIdx = 7;
        int tipoUsuarioCount = 0;
        int tipoUsuarioIdx = 8;
        int incidenciaEstadoCount = 0;
        int incidenciaEstadoIdx = 9;

        return Scaffold(
          backgroundColor: miColors.colorMaestroFondo,
          appBar: CustomAppBar(
            title: 'Dashboard',
            onLogout: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  accountName: Text("Jaks4n"),
                  accountEmail: Text("+51 968 094 974"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 172, 177, 181),
                    child: Text(
                      "J",
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Mi perfil'),
                  onTap: () {
                    // Acción para "Mi perfil"
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('DashBoard'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'home');
                    // Acción para "DashBoard"
                  },
                ),
                // Agrega más ListTile según sea necesario
              ],
            ),
          ),
          body: Consumer<DashboardProvider>(
            builder: (context, dashBoardProvider, child) {
              if (dashBoardProvider.dashBoard.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

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
                  case 'INCIDENCIA_ESTADO':
                    incidenciaEstadoCount = item.cantidad;
                    incidenciaEstadoIdx = item.id;
                    break;
                }
              }

              List<Widget> childrens = [];

              for (var item in menuProvider.menus) {
                switch (item.menuId) {
                  case 1:
                    childrens.add(
                      InfoCard(
                        title: 'Incidencia',
                        value: incidenciaCount.toString(),
                        icon: Icons.add_call,
                        color: Colors.blue,
                        id: incidenciaIdx.toString(),
                      ),
                    );
                    break;
                  case 2:
                    childrens.add(
                      InfoCard(
                        title: 'Usuarios',
                        value: usuarioCount.toString(),
                        icon: Icons.people,
                        color: Colors.green,
                        id: usuarioIdx.toString(),
                      )
                    );
                    break;
                  case 3:
                    childrens.add(
                     InfoCard(
                        title: 'Aplicacion',
                        value: aplicacionCount.toString(),
                        icon: Icons.add_moderator,
                        color: const Color.fromARGB(255, 147, 175, 76),
                        id: aplicacionIdx.toString(),
                      )
                    );
                    break;
                  case 4:
                    childrens.add(
                     InfoCard(
                        title: 'Area',
                        value: areaCount.toString(),
                        icon: Icons.app_registration_sharp,
                        color: Colors.orange,
                        id: areaIdx.toString(),
                      )
                    );
                    break;
                  case 5:
                    childrens.add(
                     InfoCard(
                        title: 'Institucion',
                        value: institucionCount.toString(),
                        icon: Icons.house_sharp,
                        color: const Color.fromARGB(255, 92, 39, 176),
                        id: institucionIdx.toString(),
                      )
                    );
                    break;
                  case 6:
                    childrens.add(
                     InfoCard(
                        title: 'Prioridad',
                        value: prioridadCount.toString(),
                        icon: Icons.low_priority,
                        color: const Color.fromARGB(255, 176, 39, 123),
                        id: prioridadIdx.toString(),
                      )
                    );
                    break;
                  case 7:
                    childrens.add(
                     InfoCard(
                        title: 'Tipo Incidencia',
                        value: tipoIncidenciaCount.toString(),
                        icon: Icons.add_link_outlined,
                        color: Colors.purple,
                        id: tipoIncidenciaIdx.toString(),
                      )
                    );
                    break;
                  case 8:
                    childrens.add(
                     InfoCard(
                        title: 'Tipo Usuario',
                        value: tipoUsuarioCount.toString(),
                        icon: Icons.switch_account_rounded,
                        color: const Color.fromARGB(255, 39, 94, 176),
                        id: tipoUsuarioIdx.toString(),
                      )
                    );
                    break;
                  case 9:
                    childrens.add(
                     InfoCard(
                        title: 'Incidencia Estado',
                        value: incidenciaEstadoCount.toString(),
                        icon: Icons.settings_input_component,
                        color: const Color.fromARGB(255, 94, 94, 90),
                        id: incidenciaEstadoIdx.toString(),
                      )
                    );
                    break;
                }
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  children: childrens,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
