import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/tipoUsuario.dart';
import 'package:insisi/constanst.dart';

const String baseUrl = '$url/insisi/api/tipoUsuario';
const urlApi = url;

class TipoUsuarioProvider with ChangeNotifier {
  List<TipoUsuario> _tipoUsuarioes = [];

  List<TipoUsuario> get tipoUsuarioes => _tipoUsuarioes;

  Future<void> fetchTipoUsuarioes() async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/tipoUsuario/list');
      final response = await http.get(urlA);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        _tipoUsuarioes = list.map((model) => TipoUsuario.fromJson(model)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load tipoUsuarioes');
      }
    } catch (e) {
      print('Error en getTipoUsuarioes: $e');
      _tipoUsuarioes = [];
      notifyListeners();
    }
  }

  Future<bool> createTipoUsuario(TipoUsuario tipoUsuario) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/tipoUsuario/create');
      final response = await http.post(
        urlA,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(tipoUsuario.toJson()),
      );

      if (response.statusCode == 201) {
        // Llamada síncrona para actualizar la lista de tipoUsuarioes
        await fetchTipoUsuarioes();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en createTipoUsuario: $e');
      return false;
    }
  }

  Future<bool> deleteTipoUsuario(int tipoUsuarioId) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/tipoUsuario/delete/$tipoUsuarioId');
      final response = await http.delete(urlA);

      if (response.statusCode == 200) {
        _tipoUsuarioes.removeWhere((tipoUsuario) => tipoUsuario.tipoUsuarioId == tipoUsuarioId);
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
