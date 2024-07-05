import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/aplicacion.dart';
import 'package:insisi/constanst.dart';

const String baseUrl = '$url/insisi/api/aplicacion';
const urlApi = url;

class AplicacionProvider with ChangeNotifier {
  List<Aplicacion> _aplicaciones = [];

  List<Aplicacion> get aplicaciones => _aplicaciones;

  Future<void> fetchAplicaciones() async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/aplicacion/list');
      final response = await http.get(urlA);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        _aplicaciones = list.map((model) => Aplicacion.fromJson(model)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load aplicaciones');
      }
    } catch (e) {
      print('Error en getAplicaciones: $e');
      _aplicaciones = [];
      notifyListeners();
    }
  }

  Future<bool> createAplicacion(Aplicacion aplicacion) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/aplicacion/create');
      final response = await http.post(
        urlA,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(aplicacion.toJson()),
      );

      if (response.statusCode == 201) {
        // Llamada síncrona para actualizar la lista de aplicaciones
        await fetchAplicaciones();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en createAplicacion: $e');
      return false;
    }
  }

  Future<bool> deleteAplicacion(int aplicacionId) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/aplicacion/delete/$aplicacionId');
      final response = await http.delete(urlA);

      if (response.statusCode == 200) {
        _aplicaciones.removeWhere((aplicacion) => aplicacion.aplicacionId == aplicacionId);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en Eliminar: $e');
      return false;
    }
  }
}
