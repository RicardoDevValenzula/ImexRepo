import 'dart:io';
//import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GeneralController {
  static Future<bool> hayConexionInternet() async {
    bool respuesta = false;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.ethernet ||
          connectivityResult == ConnectivityResult.wifi
      ) {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          respuesta = true;
        }
      }
    } on SocketException catch (_) {
      respuesta = false;
    }
    return respuesta;
  }

  static dynamic fnValEmptyOrZero(dynamic value) {
    var result = value;
    if (value.toString().isEmpty || value.toString().trim() == '0') {
      result = null;
    }
    return result;
  }

  static bool fnValidarPorcenaje(String valor) {
    bool respuesta = false;
    if (valor.isEmpty) {
      return false;
    }
    final n = num.tryParse(valor);
    if (n == null) {
      return false;
    }
    if (n >= 0 && n <= 100) {
      respuesta = true;
    } else {
      return false;
    }
    return respuesta;
  }
}

enum Enum_Acciones { nuevo, actualizado, eliminado }

enum EnumPages { dashboard, project_List, sync_up, evidence, setting }
