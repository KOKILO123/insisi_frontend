import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/aplicacion.dart';
import 'package:insisi/constanst.dart';

const urlApi = url;

const String baseUrl = urlApi+'/insisi/api/aplicacion';

class AplicacionProvider with ChangeNotifier {
  Future<List<Aplicacion>> getAplicaciones() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list'));

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        List<Aplicacion> aplicaciones = list.map((model) => Aplicacion.fromJson(model)).toList();
        return aplicaciones;
      } else {
        throw Exception('Failed to load aplicaciones');
      }
    } catch (e) {
      print('Error en getAplicaciones: $e');
      return [];
    }
  }

  Future<bool> createAplicacion(Aplicacion aplicacion) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(aplicacion.toJson()),
      );

      if (response.statusCode == 201) {
        // Aplicación creada exitosamente
        return true;
      } else {
        // Error al crear la aplicación
        return false;
      }
    } catch (e) {
      print('Error en createAplicacion: $e');
      return false;
    }
  }
}
