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
}
