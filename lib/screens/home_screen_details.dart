import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:insisi/util/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../screens/aplicacion_screen.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String value;
  final String id;
  final Color color;

  DetailScreen({required this.title, required this.value, required this.id,required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: CustomAppBar(
        title: 'Dashboard',
        onLogout: () {
          Navigator.pushReplacementNamed(context, 'home');
        },
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navegar a AplicacionesScreen con el id específico
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AplicacionesScreen(), // Pasa el id a AplicacionesScreen
              ),
            );
          },
          child: Text(
            value,
            style: TextStyle(fontSize: 48),
          ),
        ),
      ),
    );
  }
}
