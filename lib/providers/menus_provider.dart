import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:insisi/constanst.dart';
import 'package:http/http.dart' as http;
import 'package:insisi/models/menus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const urlApi = url;

class MenusProvider with ChangeNotifier {
  List<Menus> menus = [];

  MenusProvider() {
    fetchMenusItems();
  }

  Future<Map<String, String?>> _getSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    String? tipoUsuarioid = prefs.getString('tipoUsuarioid');
    String? usuarioNombre = prefs.getString('usuarioNombre');
    return {'tipoUsuarioid': tipoUsuarioid, 'usuarioNombre': usuarioNombre};
  }

  Future<void> fetchMenusItems() async {
    try {
      final sessionData = await _getSessionData();
      if (sessionData['tipoUsuarioid'] == null) {
        print('tipoUsuarioid is null');
        return;
      }

      final int tipoUsuarioid = int.parse(sessionData['tipoUsuarioid']!);
      final urlA = Uri.http(urlApi, '/insisi/api/tipoUsuarioMenu/listMenu/$tipoUsuarioid');

      final resp = await http.get(urlA);
      if (resp.statusCode == 200) {
        final List<Menus> response = menusFromJson(resp.body).cast<Menus>();
        menus = response;
        notifyListeners();
      } else {
        print('Failed to load menu items');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
    }
  }
}
