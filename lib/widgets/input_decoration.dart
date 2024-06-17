import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration inputDecoration(
    {
    required String hinttext,
    required String labeltext,
    required Icon icono
    }){
      return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: 
            BorderSide(color: Color.fromARGB(255, 196, 37, 37))
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 58, 91, 183),width: 2)),
            hintText: hinttext,
            labelText: labeltext,
            prefixIcon: icono
        );
    }
 }
