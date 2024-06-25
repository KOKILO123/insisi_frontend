import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:insisi/constanst.dart';
import 'package:http/http.dart' as http;
import '../models/dashBoard.dart';

const urlApi = url;

class DashboardProvider with ChangeNotifier {
  List<DashBoard> dashBoard = [];

  DashboardProvider();

  Future<List<DashBoard>> fetchDashboardItems() async {
    final urlA = Uri.http(urlApi, '/insisi/api/dashboard/list/1');

    try {
      final resp = await http.get(urlA);

      if (resp.statusCode == 200) {
        final List<DashBoard> response = dashBoardFromJson(resp.body).cast<DashBoard>();
        dashBoard = response;
        notifyListeners();
        return dashBoard; // Devuelve la lista de dashboard items
      } else {
        return [];
        // Manejo de errores adicional, como notificar al usuario de un fallo de autenticación
      }
    } catch (e) {
      return [];
      // Manejo de errores adicional, como notificar al usuario de un fallo de red
    }
  }
}
