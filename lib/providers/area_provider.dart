import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/area.dart';
import 'package:insisi/constanst.dart';

const String baseUrl = '$url/insisi/api/area';
const urlApi = url;

class AreaProvider with ChangeNotifier {
  List<Area> _areaes = [];

  List<Area> get areaes => _areaes;

  Future<void> fetchAreaes() async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/area/list');
      final response = await http.get(urlA);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        _areaes = list.map((model) => Area.fromJson(model)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load areaes');
      }
    } catch (e) {
      print('Error en getAreaes: $e');
      _areaes = [];
      notifyListeners();
    }
  }

  Future<bool> createArea(Area area) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/area/create');
      final response = await http.post(
        urlA,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(area.toJson()),
      );

      if (response.statusCode == 201) {
        // Llamada síncrona para actualizar la lista de areaes
        await fetchAreaes();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en createArea: $e');
      return false;
    }
  }

  Future<bool> deleteArea(int areaId) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/area/delete/$areaId');
      final response = await http.delete(urlA);

      if (response.statusCode == 200) {
        _areaes.removeWhere((area) => area.areaId == areaId);
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
