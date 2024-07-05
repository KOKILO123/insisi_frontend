import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/institucion.dart';
import 'package:insisi/constanst.dart';

const String baseUrl = '$url/insisi/api/institucion';
const urlApi = url;

class InstitucionProvider with ChangeNotifier {
  List<Institucion> _instituciones = [];

  List<Institucion> get instituciones => _instituciones;

  Future<void> fetchInstituciones() async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/institucion/list');
      final response = await http.get(urlA);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        _instituciones = list.map((model) => Institucion.fromJson(model)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load instituciones');
      }
    } catch (e) {
      print('Error en getInstituciones: $e');
      _instituciones = [];
      notifyListeners();
    }
  }

  Future<bool> createInstitucion(Institucion institucion) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/institucion/create');
      final response = await http.post(
        urlA,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(institucion.toJson()),
      );

      if (response.statusCode == 201) {
        // Llamada síncrona para actualizar la lista de instituciones
        await fetchInstituciones();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en createInstitucion: $e');
      return false;
    }
  }

  Future<bool> deleteInstitucion(int institucionId) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/institucion/delete/$institucionId');
      final response = await http.delete(urlA);

      if (response.statusCode == 200) {
        _instituciones.removeWhere((institucion) => institucion.institucionId == institucionId);
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
