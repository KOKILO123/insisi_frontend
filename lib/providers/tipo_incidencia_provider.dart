import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/tipoIncidencia.dart';
import 'package:insisi/constanst.dart';

const String baseUrl = '$url/insisi/api/tipoIncidencia';
const urlApi = url;

class TipoIncidenciaProvider with ChangeNotifier {
  List<TipoIncidencia> _tipoIncidenciaes = [];

  List<TipoIncidencia> get tipoIncidenciaes => _tipoIncidenciaes;

  Future<void> fetchTipoIncidenciaes() async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/tipoIncidencia/list');
      final response = await http.get(urlA);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        _tipoIncidenciaes = list.map((model) => TipoIncidencia.fromJson(model)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load tipoIncidenciaes');
      }
    } catch (e) {
      print('Error en getTipoIncidenciaes: $e');
      _tipoIncidenciaes = [];
      notifyListeners();
    }
  }

  Future<bool> createTipoIncidencia(TipoIncidencia tipoIncidencia) async {
    try {
      print(tipoIncidencia.aplicacionId);
      final urlA = Uri.http(urlApi, 'insisi/api/tipoIncidencia/create');
      final response = await http.post(
        urlA,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(tipoIncidencia.toJson()),
      );

      if (response.statusCode == 201) {
        // Llamada síncrona para actualizar la lista de tipoIncidenciaes
        await fetchTipoIncidenciaes();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en createTipoIncidencia: $e');
      return false;
    }
  }

  Future<bool> deleteTipoIncidencia(int tipoIncidenciaId) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/tipoIncidencia/delete/$tipoIncidenciaId');
      final response = await http.delete(urlA);

      if (response.statusCode == 200) {
        _tipoIncidenciaes.removeWhere((tipoIncidencia) => tipoIncidencia.tipoIncidenciaId == tipoIncidenciaId);
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
