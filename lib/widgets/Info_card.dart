import 'dart:ffi';

import 'package:flutter/material.dart';
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
              builder: (context) => AplicacionesScreen(), // Pasa el id a AplicacionesScreen
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
                  SizedBox(width: 16),
                  Text(
                    value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
