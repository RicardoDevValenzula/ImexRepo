import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/SincronizarController.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/models/TablaSincroLocalModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'APIController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatosBaseController extends DBDataEntry {
  APIController _apiController = new APIController();

  Future<ResultModel> _baseDataCollar(String holdId) async {
    ResultModel result = new ResultModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpPostMultipart(
          dotenv.env['URL_BASE'] ?? '', 'BaseData/base_data_collar',
          parameters: {'hold_id': '$holdId'},
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

  Future<ResultModel> _projectAndSubProjectCollar() async {
    ResultModel result = new ResultModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpPostMultipart(
          dotenv.env['URL_BASE'] ?? '',
          'BaseData/project_and_subproject_collar',
          parameters: {},
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

  Future<void> fnLimpiarDatosBase() async {
    await this.database.then((db) async {
      await db.delete('tb_collar');
      await db.delete('tb_projects');
      await db.delete('tb_subprojects');
      await db.delete('tb_loggedby');
      await db.delete('tb_lithology');
      await db.delete('tb_alterationtype');
      await db.delete('tb_alterationmins');
      await db.delete('tb_mineralisation');
      await db.delete('tb_structure');
      await db.delete('tb_sample');
      await db.delete('tb_sampqc');
      await db.delete('tb_geotechcorelog');
      await db.delete('tb_geotechcorerun');
      await db.delete('tb_diameter');
      await db.delete('tb_specificgravity');
      await db.delete('tb_downholesurveys');
      await db.delete('tb_pumptest');
    });
  }

  Future<void> fnLimpiarTablasCollar(String holeId) async {
    await this.database.then((db) async {
      List<Map<String, dynamic>> collar = await db.query('tb_collar',
          columns: ['id'], where: 'HoleId = ?', whereArgs: [holeId]);
      if (collar.isNotEmpty) {
        int id = collar.first['id'];
        await db.delete('tb_collar', where: 'HoleId = ?', whereArgs: [holeId]);
        //await db.delete('tb_projects');
        //await db.delete('tb_subprojects');
        await db.delete('tb_loggedby', where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_lithology', where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_alterationtype',
            where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_alterationmins',
            where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_mineralisation',
            where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_structure', where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_sample', where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_sampqc', where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_geotechcorelog',
            where: 'Id_Collar = ?', whereArgs: [id]);
        await db.delete('tb_geotechcorerun',
            where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_diameter', where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_specificgravity',
            where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_downholesurveys',
            where: 'IdCollar = ?', whereArgs: [id]);
        await db.delete('tb_rel_profile_collars',
            where: 'collarId = ?', whereArgs: [id]);
        await db.delete('tb_lostcore', where: 'IdCollar = ?', whereArgs: [id]);
        //await db.delete('tb_pumptest', where: 'id_collar = ?', whereArgs: [id]);
      }
    });
  }

  Future<List<Object?>> fnEliminarCollarCompleto(String holeId) async {
    List<Object?> result = [];
    await this.database.then((db) async {
      List<Map<String, dynamic>> collar = await db.query('tb_collar',
          columns: ['id'], where: 'HoleId = ?', whereArgs: [holeId]);
      if (collar.isNotEmpty) {
        int id = collar.first['id'];
        await db.transaction((txn) async {
          Batch batch = txn.batch();

          await db
              .delete('tb_collar', where: 'HoleId = ?', whereArgs: [holeId]);
          //await db.delete('tb_projects');
          //await db.delete('tb_subprojects');
          await txn
              .delete('tb_loggedby', where: 'IdCollar = ?', whereArgs: [id]);
          await txn
              .delete('tb_lithology', where: 'IdCollar = ?', whereArgs: [id]);
          await txn.delete('tb_alterationtype',
              where: 'IdCollar = ?', whereArgs: [id]);
          await txn.delete('tb_alterationmins',
              where: 'IdCollar = ?', whereArgs: [id]);
          await txn.delete('tb_mineralisation',
              where: 'IdCollar = ?', whereArgs: [id]);
          await txn
              .delete('tb_structure', where: 'IdCollar = ?', whereArgs: [id]);
          await txn.delete('tb_sample', where: 'IdCollar = ?', whereArgs: [id]);
          await txn.delete('tb_sampqc', where: 'IdCollar = ?', whereArgs: [id]);
          await txn.delete('tb_geotechcorelog',
              where: 'Id_Collar = ?', whereArgs: [id]);
          await txn.delete('tb_geotechcorerun',
              where: 'IdCollar = ?', whereArgs: [id]);
          await txn
              .delete('tb_diameter', where: 'IdCollar = ?', whereArgs: [id]);
          await txn.delete('tb_specificgravity',
              where: 'IdCollar = ?', whereArgs: [id]);
          await txn.delete('tb_downholesurveys',
              where: 'IdCollar = ?', whereArgs: [id]);
          await txn
              .delete('tb_pumptest', where: 'id_collar = ?', whereArgs: [id]);

          result = await batch.commit();
        });
      }
    });
    print(result);
    return result;
  }

  final _syncroController = SincronizarController();

  Future<bool> fnDescargaDatos(Map<String, bool> mapIds) async {
    bool respuesta = false;
    try {
      for (var entryId in mapIds.entries) {
        // #OBTENER DE LA BASE DE DATOS LOS DATOS DE ESE BARRENO.
        ResultModel model = await this._baseDataCollar(entryId.key);
        // #VALIDAR SI LA RESPUESTA DE LA BASE DE DATOS ES CORRECTA.
        if (model.status) {
          // #INICAR TRANSACCION DE BASE DE DATOS.
          await this.database.then((db) async {
            await db.transaction((txn) async {
              // #CREAR CONTENDOR DE QUERYS.
              Batch batch = txn.batch();
              // #SETTIAR LOS VALORES OBTENIDOS.
              Map<String, dynamic> tablas = model.data;
              // #RECORRER LAS LISTA DE TABLAS OBTENIDAS DEL BARRENO.
              for (var entryTable in tablas.entries) {
                // #SETTEAR LA LISTA DE REGISTROS POR TABLA.
                List<dynamic> datos = entryTable.value;
                // #CREAR TABLA.
                ResultModel datosTabla =
                    await _syncroController.datosDeTabla(entryTable.key);
                if (datosTabla.status) {
                  await txn.execute(datosTabla.data['create_tabla_sqllite']);

                  String dtnow = DateTime.now().toIso8601String();

                  await txn.delete(TablaSincroLocalModel().tbName,
                      where: 'id = ?', whereArgs: [datosTabla.data['id']]);

                  await txn.insert(TablaSincroLocalModel().tbName, {
                    'id': datosTabla.data['id'],
                    'tb_sincronizacion_app_id': datosTabla.data['id'],
                    'tipo_tabla_id': datosTabla.data['tipo_tabla_id'],
                    'nombre_tabla': datosTabla.data['nombre_tabla'],
                    'estatus_id': 1,
                    'order_table': datosTabla.data['order_table'],
                    'created_at': dtnow,
                    'updated_at': dtnow
                  });
                }
                //txn. datosDeTabla
                // #RECORRER LOS REGISTROS A INSERTAR.
                for (var valueDatos in datos) {
                  // #PREPARAR INSERCION DE LOS REGISTROS.
                  Map<String, dynamic> data = valueDatos;
                  String where = '';
                  dynamic whereArg = null;
                  List<dynamic> existe = [];
                  // #ASIGNAR FILTRO.
                  switch (entryTable.key.toLowerCase().trim()) {
                    case 'tb_collar':
                      where = 'HoleId = ?';
                      whereArg = [data['HoleId']];
                      break;
                    case 'tb_subprojects':
                    case 'tb_projects':
                    case 'tb_asignedproject':
                      where = 'id = ?';
                      whereArg = [data['id']];
                      break;
                    default:
                      where = 'Id = ?';
                      whereArg = [data['Id']];
                      break;
                  }

                  existe = await txn.query(entryTable.key,
                      where: where, whereArgs: whereArg);
                  if (existe.isEmpty) {
                    // #AGREGAR ESTATUS DE
                    data['status_sync'] = 1;
                    batch.insert(entryTable.key, data,
                        conflictAlgorithm: ConflictAlgorithm.replace);
                  }
                }
              }
              // #EJECUTAR INSERTS.
              await batch.commit();
            });
          });
        }
      }
      respuesta = true;
    } on Exception catch (ex) {
      print(ex);
      respuesta = false;
    }
    return respuesta;
  }

  Future<bool> fnDescargaDatosProjectosSubProyetos() async {
    bool respuesta = false;
    ResultModel crearTabla;
    List<dynamic> existe = [];
    try {
      // #SINCRONIZAR CATALOG DE COMPAÑIAS.
      //await new  CatalogoController().fnSincronizarCatalogos({'cat_company': true});
      // #OBTENER DATOS DE PROYECTOS, SUBPROYECTOS Y ASIGNADOS.
      ResultModel rmProjectSubProject =
          await this._projectAndSubProjectCollar();
      // #VALIDAR SI HAY RESULTADOS.
      if (rmProjectSubProject.status) {
        // #INICAR TRANSACCION DE BASE DE DATOS.
        await this.database.then((db) async {
          await db.transaction((txn) async {
            // #CREAR CONTENDOR DE QUERYS.
            Batch batch = txn.batch();
            // #RECORER RESULTADOS.
            Map<String, dynamic> tablas = rmProjectSubProject.data;
            for (var entryTabla in tablas.entries) {
              // #CREAR LA TABLA.
              crearTabla = await _syncroController.datosDeTabla(entryTabla.key);
              if (crearTabla.status) {
                await txn.execute(crearTabla.data['create_tabla_sqllite']);
              }
              // #RECORER DATOS.
              List<dynamic> datosTabla = entryTabla.value;
              for (var values in datosTabla) {
                // #PREPARAR INSERCION DE LOS REGISTROS.
                existe = await txn.query(entryTabla.key,
                    where: 'id = ?', whereArgs: [values['id']]);
                if (existe.isEmpty) {
                  // #AGREGAR ESTATUS DE
                  values['status_sync'] = 1;
                  batch.insert(entryTabla.key, values,
                      conflictAlgorithm: ConflictAlgorithm.replace);
                }
              }
              // #ACTUALIZAR PARA.
              await txn.insert(TablaSincroLocalModel().tbName, {
                'id': crearTabla.data['id'],
                'tb_sincronizacion_app_id': crearTabla.data['id'],
                'tipo_tabla_id': crearTabla.data['tipo_tabla_id'],
                'nombre_tabla': crearTabla.data['nombre_tabla'],
                'estatus_id': 1,
                'order_table': crearTabla.data['order_table'],
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String()
              });
            }
            // #EJECUTAR INSERTS.
            await batch.commit();
          });
        });
      }
      respuesta = true;
    } on Exception catch (ex) {
      print(ex);
      respuesta = false;
    }
    return respuesta;
  }
}
