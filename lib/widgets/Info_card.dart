import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:insisi/screens/area_screen.dart';
import 'package:insisi/screens/incidencia_estado_screen.dart';
import 'package:insisi/screens/incidencia_screen.dart';
import 'package:insisi/screens/institucion_screen.dart';
import 'package:insisi/screens/prioridad_screen.dart';
import 'package:insisi/screens/tipo_incidencia_screen.dart';
import 'package:insisi/screens/tipo_usuario_screen.dart';
import 'package:insisi/screens/usuario_screen.dart';
import '../screens/home_screen_details.dart';
import '../screens/aplicacion_screen.dart';


class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final String id;

  InfoCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color = Colors.blue,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              //builder: (context) => DetailScreen(title: title, value: value,id:id,color:color),
              //builder: (context) => AplicacionesScreen(), // Pasa el id a AplicacionesScreen
             builder: (context) {
              
                switch (id) {
                  case '1':
                    return IncidenciasScreen();
                  case '2':
                    return UsuariosScreen(); 
                  case '3':
                    return AplicacionesScreen(); 
                  case '4':
                    return AreaesScreen(); 
                  case '5':
                    return InstitucionesScreen();
                  case '6':
                    return PrioridadesScreen(); 
                  case '7':
                    return TipoIncidenciaesScreen();  
                  case '8':
                    return TipoUsuarioesScreen();   
                  case '9':
                    return IncidenciaEstadoesScreen();   
                  default:
                    return AplicacionesScreen(); // En caso de que id no coincida con ningún caso, puedes retornar una pantalla vacía o manejarlo como prefieras
                }
              },

            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
