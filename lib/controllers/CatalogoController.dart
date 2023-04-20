import 'dart:isolate';

import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';
import 'package:data_entry_app/controllers/SincronizarController.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/models/TablaSincroLocalModel.dart';

class CatalogoController {
  // #VARIABLES.
  final _dbDataEntry = DBDataEntry();
  final _sincronizarController = SincronizarController();

  static int _catalogo = 0;
  static Isolate? _isolateCatalogo;
  static ReceivePort _receivePortCatalogo = ReceivePort();

  // #PROPIEDADES.
  static Isolate? get isolateCatalogo => _isolateCatalogo;
  static ReceivePort get receivePortCatalogo => _receivePortCatalogo;
  static int get catalogo => _catalogo;
  static set catalogo(int value) {
    _catalogo = value;
  }

  // #METODOS O FUNCIONES.
  Future<bool> fnSincronizarCatalogos(
      Map<String, bool> _catalogosSincronizar) async {
    bool respuesta = false;
    bool isConnected = false;
    //Map<String, bool> _catalogosSincronizar = Map();
    List<Map<String, dynamic>> _tablasOnline = [];

    try {
      // #SI NO HAY CONEXION TERMINAR.
      isConnected = await GeneralController.hayConexionInternet();
      if (isConnected) {
        if (_catalogosSincronizar.isEmpty) {
          // #OBTENER LISTADO DE CATALOGOS ONLINE.
          ResultModel tablas =
              await _sincronizarController.listaTablasPorTipo(1);
          if (tablas.status) {
            _tablasOnline = (tablas.data["tablas"] as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();

          } else {
            _tablasOnline = [];
          }
          await _dbDataEntry.database.then((db) async {
            for (int i = 0; i < _tablasOnline.length; i++) {
              //_tablasOnline.forEach((table) async {
              // #VALIDAR CON EL LISTADO SI HAY CATALOGOS VACIOS Y SI HAY DESCARGARLOS.
              String tableName = _tablasOnline[i]["nombre_tabla"];
              DateTime ultimaActualizacion =
                  DateTime.parse(_tablasOnline[i]['ultima_actualizacion']);
              List<dynamic> registros = [];
              registros = await db
                  .rawQuery("SELECT COUNT(*) AS result FROM $tableName")
                  .onError((error, stackTrace) => [
                        {'result': 0}
                      ])
                  .catchError((error) {
                print("Tabla aun no creada. error:  $error.");
              });
              if (registros.first['result'] == 0) {
                _catalogosSincronizar.addEntries([MapEntry(tableName, true)]);
              } else {
                // #OBTENER ULTIMA ACTUALIZACION DEL TABLA.
                List<dynamic> uSincro = [];
                uSincro = await db
                    .query('tb_sincronizacion_local_app',
                        columns: ['updated_at'],
                        where: 'nombre_tabla = ?',
                        whereArgs: [tableName],
                        orderBy: 'updated_at DESC',
                        limit: 1)
                    .onError((error, stackTrace) => []);
                if (uSincro.isNotEmpty) {
                  DateTime updatedAt = DateTime.parse(uSincro[0]['updated_at']);
                  // #VALIDAR SI HAY CAMBIOS DE CATALOGOS ONLINE Y SI HAY DESCARGARLOS.
                  int respCompFechas = ultimaActualizacion.compareTo(updatedAt);
                  print(respCompFechas);
                  print(updatedAt);
                  print(ultimaActualizacion);
                  if (respCompFechas > 0) {
                    _catalogosSincronizar
                        .addEntries([MapEntry(tableName, true)]);
                  }
                }
              }
              //});
            }
          });
        }

        // #RECORERR LISTA DE LAS TABLAS.
        respuesta = await fnProcesarListaParaActualizar(
            _catalogosSincronizar, _tablasOnline);
        print('OK');
      } else {
        print('Conexión: $isConnected');
      }
    } catch (ex) {
      print(ex.toString());
      respuesta = false;
      print('CATCH');
    }
    return respuesta;
  }

  Future<bool> fnProcesarListaParaActualizar(
      Map<String, bool> _catalogosSincronizar,
      List<Map<String, dynamic>> _tablasOnline) async {
    bool respuesta = false;
    int contador = 0;
    try {
      // #RECORERR LISTA DE LAS TABLAS.
      for (var entry in _catalogosSincronizar.entries) {
        //_selectedTables.forEach((nombreTabla, valor) async {
        ResultModel registrosTabla;
        // #VALIDAR SI ESTA SELECCIONADA.
        if (entry.value) {
          // #OBTENER LA PRIMERA PAGINA DE LOS REGISTROS.
          registrosTabla = await _sincronizarController.obtenerInfoDatosTabla(
              entry.key, 1, 500);
          if (registrosTabla.status) {
            // #OBTENER CREATE DE LA TABLA.
            Map<String, dynamic> itemTabla = await _tablasOnline
                .where((element) =>
                    element['nombre_tabla'].toString().toLowerCase().trim() ==
                    entry.key.toLowerCase().trim())
                .first;
            /*
            // #CREAR TABLA.
            String queryCreate = "${itemTabla['create_tabla_sqllite']}";
            await _dbDataEntry
                .fnCrearTabla(queryCreate)
                .onError((error, stackTrace) {
              print(error);
              return false;
            });
             */
            // #OBTENER NUMERO TOTAL DE PAGINAS.
            int paginasTotales =
                int.tryParse(registrosTabla.data['informacion']['paginas']) ??
                    0;
            // #BORRAR DATOS ANTERIORES.
            await _dbDataEntry
                .fnBorrarTabla(entry.key)
                .onError((error, stackTrace) {
              print(error);
              return false;
            });
            // #RECORRER TOTAL DE PAGINAS.
            for (int i = 1; i <= paginasTotales; i++) {
              if (i != 1) {
                registrosTabla = await _sincronizarController
                    .obtenerInfoDatosTabla(entry.key, i, 500);
              }
              // #RECORRER REGISTROS DE LA PAGINA.
              for (Map<String, dynamic> registro
                  in registrosTabla.data['registros']) {
                // #INSERTAR REGISTROS EN LA TABLA LOCAL.
                await _sincronizarController.fnInsertarRegistroTabla(
                    entry.key, registro);
                //print("Insertado: $id - $registro.");
              }
            }
            // #ACTUALIZAR REGISTRO DE SINCRONIZACION.
            int idActualizado = await fnActualizarRegistroSincronizacion(
                int.tryParse(itemTabla['id']) ?? 0,
                int.tryParse(itemTabla['id']) ?? 0,
                int.tryParse(itemTabla['tipo_tabla_id']) ?? 0,
                itemTabla['nombre_tabla'],
                int.tryParse(itemTabla['order_table']) ?? 0,
                1);
            contador = (contador + (idActualizado > 0 ? 1 : 0));
          } else {
            print("Error: $entry.key");
          }
        }
      }
    } catch (ex) {
      print("Error: $ex");
      respuesta = false;
    }
    if (_catalogosSincronizar.length == contador) {
      respuesta = true;
    }
    return respuesta;
  }

  Future<int> fnActualizarRegistroSincronizacion(
      int id,
      int tbSincronizacionAppId,
      int tipoTablaId,
      String nombreTabla,
      int orderTable,
      int estatusId) async {
    int idInsertado = 0;
    try {
      // #OBTENER FECHA ACTUAL DEL DISPOSITIVO.
      String dtnow = DateTime.now().toIso8601String();
      // #ASIGNAR DATOS AL MODELO.
      Map<String, dynamic> valores = {
        'id': id,
        'tb_sincronizacion_app_id': tbSincronizacionAppId,
        'tipo_tabla_id': tipoTablaId,
        'nombre_tabla': nombreTabla,
        'estatus_id': estatusId,
        'order_table': orderTable,
        'created_at': dtnow,
        'updated_at': dtnow
      };
      TablaSincroLocalModel tablaSincroLocalModel = new TablaSincroLocalModel();
      tablaSincroLocalModel.fromMap(valores);
      // #ELIMINAR SI EXISTE YA EL REGISTRO.
      await tablaSincroLocalModel.fnEliminarRegistro(tablaSincroLocalModel.id);
      // #VALIDAR SI EXISTE EL EL REGISTRO.
      idInsertado = await tablaSincroLocalModel.insert();
    } catch (ex) {
      print('fnActualizarRegistroSincronizacion: $ex');
    }
    return idInsertado;
  }

  static Future<void> initCatalogo(Map<String, bool> listaCatalogsIds) async {
    try {
      _isolateCatalogo?.kill();
      var param = new ParametroCatalogo(
          listaCatalogsIds, _receivePortCatalogo.sendPort);
      _isolateCatalogo =
          await Isolate.spawn<ParametroCatalogo>(_checkCatalog, param);
    } on IsolateSpawnException catch (e) {
      print(e);
    }
  }

  static void _checkCatalog(ParametroCatalogo param) async {
    param.sendPort.send(param.lstCatalogIds);
  }
}

class ParametroCatalogo {
  Map<String, bool> lstCatalogIds = Map();
  late SendPort sendPort;

  ParametroCatalogo(this.lstCatalogIds, this.sendPort);
}
