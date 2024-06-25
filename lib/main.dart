import 'package:flutter/material.dart';
import 'package:insisi/providers/aplicacion_provider.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sistema de Incidencias SIAF - SIGA',
        routes: {
          'login' : (_) => LoginScreen(),
          'home' : (_) => HomeScreen(),
        },
        initialRoute: 'login',
      ),
    );
  }
}