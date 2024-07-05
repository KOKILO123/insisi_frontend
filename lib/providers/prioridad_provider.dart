import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/prioridad.dart';
import 'package:insisi/constanst.dart';

const String baseUrl = '$url/insisi/api/prioridad';
const urlApi = url;

class PrioridadProvider with ChangeNotifier {
  List<Prioridad> _prioridades = [];

  List<Prioridad> get prioridades => _prioridades;

  Future<void> fetchPrioridades() async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/prioridad/list');
      final response = await http.get(urlA);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        _prioridades = list.map((model) => Prioridad.fromJson(model)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load prioridades');
      }
    } catch (e) {
      print('Error en getPrioridades: $e');
      _prioridades = [];
      notifyListeners();
    }
  }

  Future<bool> createPrioridad(Prioridad prioridad) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/prioridad/create');
      final response = await http.post(
        urlA,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(prioridad.toJson()),
      );

      if (response.statusCode == 201) {
        // Llamada síncrona para actualizar la lista de prioridades
        await fetchPrioridades();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en createPrioridad: $e');
      return false;
    }
  }

  Future<bool> deletePrioridad(int prioridadId) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/prioridad/delete/$prioridadId');
      final response = await http.delete(urlA);

      if (response.statusCode == 200) {
        _prioridades.removeWhere((prioridad) => prioridad.prioridadId == prioridadId);
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
