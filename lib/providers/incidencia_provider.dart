import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:insisi/constanst.dart';
import 'package:insisi/models/incidencia.dart';
import 'package:http/http.dart' as http;

//const urlApi = url;
const String baseUrl = '$url/insisi/api/tipoIncidencia';
const urlApi = url;

class IncidenciaProvider with ChangeNotifier {
  //List<Incidencia> incidencias = [];

  //IncidenciaProvider();


  /* ---------------------------- */
  List<Incidencia> _incidencias = [];

  List<Incidencia> get incidenciasx => _incidencias;

  Future<void> fetchIncidencias() async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/incidencia/list');
      final response = await http.get(urlA);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        _incidencias = list.map((model) => Incidencia.fromJson(model)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load incidencias');
      }
    } catch (e) {
      print('Error en getincidencias: $e');
      _incidencias = [];
      notifyListeners();
    }
  }

  Future<bool> createIncidencia(Incidencia incidencia) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/incidencia/create');
      final response = await http.post(
        urlA,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(incidencia.toJson()),
      );

      if (response.statusCode == 201) {
        // Llamada síncrona para actualizar la lista de incidencias
        await fetchIncidencias();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en createAplicacion: $e');
      return false;
    }
  }

  Future<bool> deleteIncidencia(int incidenciaId) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/incidencia/delete/$incidenciaId');
      final response = await http.delete(urlA);

      if (response.statusCode == 200) {
        _incidencias.removeWhere((aplicacion) => aplicacion.incidenciaId == incidenciaId);
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
