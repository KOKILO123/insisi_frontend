import 'package:flutter/material.dart';
import 'package:insisi/models/prioridad.dart';
import 'package:insisi/models/tipoIncidencia.dart';
import 'package:insisi/providers/aplicacion_provider.dart';
import 'package:insisi/providers/area_provider.dart';
import 'package:insisi/providers/incidencia_estado_provider.dart';
import 'package:insisi/providers/incidencia_provider.dart';
import 'package:insisi/providers/institucion_provider.dart';
import 'package:insisi/providers/menus_provider.dart';
import 'package:insisi/providers/prioridad_provider.dart';
import 'package:insisi/providers/tipo_incidencia_provider.dart';
import 'package:insisi/providers/tipo_usuario_provider.dart';
import 'package:insisi/providers/usuario_provider.dart';
import 'package:insisi/providers/dashboard_provider.dart';
import 'package:insisi/screens/home_screen.dart';
import 'package:insisi/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => AplicacionProvider()),
        ChangeNotifierProvider(create: (_) => AreaProvider()),
        ChangeNotifierProvider(create: (_) => InstitucionProvider()),
        ChangeNotifierProvider(create: (_) => PrioridadProvider()),
        ChangeNotifierProvider(create: (_) => TipoIncidenciaProvider()),
        ChangeNotifierProvider(create: (_) => TipoUsuarioProvider()),
        ChangeNotifierProvider(create: (_) => IncidenciaEstadoProvider()),
        ChangeNotifierProvider(create: (_) => MenusProvider()),
        ChangeNotifierProvider(create: (_) => IncidenciaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sistema de Incidencias ',
        routes: {
          'login' : (_) => LoginScreen(),
          'home' : (_) => HomeScreen(),
        },
        initialRoute: 'login',
      ),
    );
  }
}