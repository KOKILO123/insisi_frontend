import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:insisi/constanst.dart';
import 'package:insisi/models/usuario.dart';
import 'package:http/http.dart' as http;

const urlApi = url;

class UsuarioProvider with ChangeNotifier {
  List<Usuario> usuarios = [];

  UsuarioProvider();

  Future<List<Usuario>> getUsuario(String usuario, String password) async {
    final urlA = Uri.http(urlApi, 'insisi/api/usuario/login');

    var headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    var body = jsonEncode({
      'usuario': usuario,
      'clave': password
    });

    try {
      final resp = await http.post(
        urlA,
        headers: headers,
        body: body,
      );

      if (resp.statusCode == 200) {
        final List<Usuario> response = usuarioFromJson(resp.body).cast<Usuario>();
        usuarios = response;
        notifyListeners();
        return usuarios; // Devuelve la lista de usuarios
      } else {
        print('Error: ${resp.statusCode} - ${resp.reasonPhrase}');
        return [];
        // Manejo de errores adicional, como notificar al usuario de un fallo de autenticación
      }
    } catch (e) {
      print('Error de red: $e');
      return [];
      // Manejo de errores adicional, como notificar al usuario de un fallo de red
    }
  }


  /* ---------------------------- */
  List<Usuario> _usuarios = [];

  List<Usuario> get usuariosx => _usuarios;

  Future<void> fetchUsuarios() async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/usuario/list');
      final response = await http.get(urlA);

      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        _usuarios = list.map((model) => Usuario.fromJson(model)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load usuarios');
      }
    } catch (e) {
      print('Error en getusuarios: $e');
      _usuarios = [];
      notifyListeners();
    }
  }

  Future<bool> createUsuario(Usuario usuario) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/usuario/create');
      final response = await http.post(
        urlA,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(usuario.toJson()),
      );

      if (response.statusCode == 201) {
        // Llamada síncrona para actualizar la lista de usuarios
        await fetchUsuarios();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en createAplicacion: $e');
      return false;
    }
  }

  Future<bool> deleteUsuario(int usuarioId) async {
    try {
      final urlA = Uri.http(urlApi, 'insisi/api/usuario/delete/$usuarioId');
      final response = await http.delete(urlA);

      if (response.statusCode == 200) {
        _usuarios.removeWhere((aplicacion) => aplicacion.usuarioId == usuarioId);
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
