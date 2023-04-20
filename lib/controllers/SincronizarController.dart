import 'dart:convert';

import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/models/TablaSincroLocalModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'APIController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SincronizarController extends DBDataEntry {
  APIController _apiController = new APIController();

  Future<ResultModel> listaTablas() async {
    ResultModel result = new ResultModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpPostMultipart(
          dotenv.env['URL_BASE'] ?? '', 'sincronizar/lista_tablas',
          parameters: {}, ssl: ssl, headers: {'Authorization': '$token'});
      if (response['result']) {
        result = ResultModel.fromJson(response['body']);
      } else {
        result = ResultModel.fromJson(response);
      }
    } on Exception catch (ex) {
      result.init(false, "Error: $ex", null);
    }
    return result;
  }

  Future<ResultModel> listaTablasPorTipo(int tipoTabla) async {
    ResultModel result = new ResultModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      print(dotenv.env['URL_BASE']);
      Map<String, dynamic> response = await _apiController.httpPostMultipart(
          dotenv.env['URL_BASE'] ?? '', 'sincronizar/obtener_tablas',
          parameters: {'tipo_tabla': '$tipoTabla'},
          ssl: ssl,
          headers: {'Authorization': '$token'});

      if (response['result']) {
        result = ResultModel.fromJson(response['body']);
      } else {
        result = ResultModel.fromJson(response);
      }
    } on Exception catch (ex) {
      result.init(false, "Error: $ex", null);
    }
    return result;
  }

  Future<ResultModel> datosDeTabla(String nombreTabla) async {
    ResultModel result = new ResultModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpPostMultipart(
          dotenv.env['URL_BASE'] ?? '', 'sincronizar/obtener_datos_tabla',
          parameters: {'nombre_tabla': '$nombreTabla'},
          ssl: ssl,
          headers: {'Authorization': '$token'});
      if (response['result']) {
        print(response);
        result = ResultModel.fromJson(response['body']);
      } else {
        result = ResultModel.fromJson(response);
      }
    } on Exception catch (ex) {
      result.init(false, "Error: $ex", null);
    }
    return result;
  }

  Future<ResultModel> obtenerInfoDatosTabla(
      String nombreTabla, int pagina, int registros) async {
    ResultModel result = new ResultModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpPostMultipart(
          dotenv.env['URL_BASE'] ?? '', 'sincronizar/registros_datos_tabla',
          parameters: {
            'nombre_tabla': nombreTabla,
            'pagina': '$pagina',
            'registros': '$registros'
          },
          ssl: ssl,
          headers: {'Authorization': '$token'});
      //print('Estos son los parametros  ${response}');
      if (response['result']) {
        result = ResultModel.fromJson(response['body']);
      } else {
        result = ResultModel.fromJson(response);
      }
    } on Exception catch (ex) {
      result.init(false, "Error: $ex", null);
    }
    return result;
  }

  Future<int> fnInsertarRegistroTabla(
      String tbName, Map<String, dynamic> values) async {
    int result = 0;
    bool existe = await fnExiste(tbName);
    if (existe) {
      database.then((db) async {
        result = await db.insert(tbName, values,
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
    }
    return result;
  }

  Future<void> fnActualizarRegistroSincronizacion(
      int id,
      int tbSincronizacionAppId,
      int tipoTablaId,
      String nombreTabla,
      int estatusId) async {
    // #OBTENER FECHA ACTUAL DEL DISPOSITIVO.
    String dtnow = DateTime.now().toIso8601String();
    // #ASIGNAR DATOS AL MODELO.
    Map<String, dynamic> valores = {
      'id': id,
      'tb_sincronizacion_app_id': tbSincronizacionAppId,
      'tipo_tabla_id': tipoTablaId,
      'nombre_tabla': nombreTabla,
      'estatus_id': estatusId,
      'created_at': dtnow,
      'updated_at': dtnow
    };
    TablaSincroLocalModel tablaSincroLocalModel = new TablaSincroLocalModel();
    tablaSincroLocalModel.fromMap(valores);
    // #ELIMINAR SI EXISTE YA EL REGISTRO.
    await tablaSincroLocalModel.fnEliminarRegistro(tablaSincroLocalModel.id);
    // #VALIDAR SI EXISTE EL EL REGISTRO.
    await tablaSincroLocalModel.insert();
  }

  Future<ResultModel> subirDatosSincro(List<dynamic> arregloDatosSincro) async {
    ResultModel result = new ResultModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpPostMultipart(
          dotenv.env['URL_BASE'] ?? '', 'sincronizar/subir_datos_sincro',
          parameters: {'arreglo_datos_sincro': jsonEncode(arregloDatosSincro)},
          ssl: ssl,
          headers: {'Authorization': '$token'}
      );
      //log(' fuera del if ${response}');
      //debugPrint(response['result']);
      if (response['result']) {
        result = ResultModel.fromJson(response['body']);

      } else {
        result = ResultModel.fromJson(response);
        //log('Dentro del if  ${response}');
      }

    } on Exception catch (ex) {
      result.init(false, "Error: $ex", null);
    }
    return result;
  }

  Future<int> fnDescargarYCrearTablaLocal() async {
    var dbDataEntry = new DBDataEntry();
    int countInsert = 0;
    try {
      // #OBTENER LISTA DE TABLAS.
      List<Map<String, dynamic>> _tablasOnline = [];
      ResultModel tablas = await listaTablas();
      if (tablas.status) {
        _tablasOnline = (tablas.data["tablas"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      } else {
        _tablasOnline = [];
      }
      // #CREAR TABLAS EN BASE DE DATOS LOCAL
      for (int i = 0; i < _tablasOnline.length; i++) {
        await dbDataEntry.database.then((db) async {
          await db.execute(_tablasOnline[i]['create_tabla_sqllite']);
          // #INSERTAR EN EL REGISTRO.
          String dtnow = DateTime.now().toIso8601String();
          if (int.parse(_tablasOnline[i]['tipo_tabla_id']) == 2) {
            await db.insert(TablaSincroLocalModel().tbName, {
              'id': _tablasOnline[i]['id'],
              'tb_sincronizacion_app_id': _tablasOnline[i]['id'],
              'tipo_tabla_id': _tablasOnline[i]['tipo_tabla_id'],
              'nombre_tabla': _tablasOnline[i]['nombre_tabla'],
              'estatus_id': 1,
              'order_table': _tablasOnline[i]['order_table'],
              'created_at': dtnow,
              'updated_at': dtnow
            });
          }
          countInsert++;
        });
      }
    } catch (ex) {
      print('fnDescargarYCrearTablaLocal[error]: $ex.');
    }
    return countInsert;
  }
}
