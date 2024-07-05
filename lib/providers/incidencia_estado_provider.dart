import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/incidenciaEstado.dart';
import 'package:insisi/constanst.dart';

const String baseUrl = '$url/insisi/api/incidenciaEstado';
const urlApi = url;

class IncidenciaEstadoProvider with ChangeNotifier {
  List<IncidenciaEstado> _incidenciaEstadoes = [];

  List<IncidenciaEstado> get incidenciaEstadoes => _incidenciaEstadoes;

  Future<void> fetchIncidenciaEstadoes() async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/incidenciaEstado/list');
      final response = await http.get(urlA);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        _incidenciaEstadoes = list.map((model) => IncidenciaEstado.fromJson(model)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load incidenciaEstadoes');
      }
    } catch (e) {
      print('Error en getIncidenciaEstadoes: $e');
      _incidenciaEstadoes = [];
      notifyListeners();
    }
  }

  Future<bool> createIncidenciaEstado(IncidenciaEstado incidenciaEstado) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/incidenciaEstado/create');
      final response = await http.post(
        urlA,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(incidenciaEstado.toJson()),
      );

      if (response.statusCode == 201) {
        // Llamada síncrona para actualizar la lista de incidenciaEstadoes
        await fetchIncidenciaEstadoes();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en createIncidenciaEstado: $e');
      return false;
    }
  }

  Future<bool> deleteIncidenciaEstado(int incidenciaEstadoId) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/incidenciaEstado/delete/$incidenciaEstadoId');
      final response = await http.delete(urlA);

      if (response.statusCode == 200) {
        _incidenciaEstadoes.removeWhere((incidenciaEstado) => incidenciaEstado.incidenciaEstadoId == incidenciaEstadoId);
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
