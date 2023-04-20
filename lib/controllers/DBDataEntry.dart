import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'GeneralController.dart';

class DBDataEntry {
  static const databaseName = 'dataEntry_db.db';

  Future<Database> get database async => await initDB();

  Future<Database> initDB() async {
    // A LA CUARTA VEZ QUE CAE VIENE UN VALOR NULO
    Database db = await openDatabase(
        join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      // #CREACION DE TABLAS LOCALES.
      await db.execute(dotenv.env['CREATE_TB_SINCRO_LOCAL_APP'] ?? '');
    });
    return db;
  }

  Future<Database> initDBAll() async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      // #CREAR BASE DE DATOS LOCALES.
      await db.execute(dotenv.env['CREATE_TB_SINCRO_LOCAL_APP'] ?? '');
      await db
          .execute(dotenv.env['CREATE_TB_PROFILE_TABS_FIELDS_LOCAL_APP'] ?? '');
      await db.execute(
          dotenv.env['CREATE_REL_PROFILE_TABS_FIELDS_LOCAL_APP'] ?? '');
      await db.execute(dotenv.env['CREATE_REL_PROFILE_COLLAR'] ?? '');
      await db.execute(dotenv.env['CREATE_CAT_STATUS_SYNC'] ?? '');
      //await db.delete('evidencias_local');
      await db.execute(dotenv.env['CREATE_EVIDENCIAS_LOCAL'] ?? '');
      // #CREAR NUEVOS REGISTROS.
      await db.delete('cat_status_sync');
      await db.insert(
          'cat_status_sync', {'id': 1, 'status_sync': 'Download', 'status': 1},
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert('cat_status_sync',
          {'id': 2, 'status_sync': 'Download-Update', 'status': 1},
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert('cat_status_sync',
          {'id': 3, 'status_sync': 'Download-Delete', 'status': 1},
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert(
          'cat_status_sync', {'id': 4, 'status_sync': 'Local-New', 'status': 1},
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert('cat_status_sync',
          {'id': 5, 'status_sync': 'Local-Update', 'status': 1},
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert('cat_status_sync',
          {'id': 6, 'status_sync': 'Local-Delete', 'status': 1},
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
    return db;
  }

  Future<bool> fnExiste(String nombreTabla) async {
    bool respuesta = await database.then((value) async {
      List<Map<String, Object?>> resultado = await value.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='$nombreTabla'");
      return (resultado.length > 0 ? true : false);
    }, onError: (error) {
      return false;
    });
    return respuesta;
  }

  Future<bool> deleteDB() async {
    await (await openDatabase(join(await getDatabasesPath(), databaseName)))
        .close();
    await deleteDatabase(join(await getDatabasesPath(), databaseName));
    return true;
  }

  Future<bool> fnCrearTabla(String queryCreate) async {
    bool resultado = await database.then((value) {
      value.execute(queryCreate);
      return true;
    }, onError: (error) {
      return false;
    });
    return resultado;
  }

  Future<bool> fnBorrarTabla(String nombreTabla) async {
    bool resultado = await database.then((value) async {
      int borrados = await value.delete(nombreTabla);
      return (borrados > 0 ? true : false);
    }, onError: (error) {
      return false;
    });
    return resultado;
  }

  Future<bool> fnExisteElRegistro(
      String nombreTabla, String campo, dynamic valor) async {
    bool respuesta = await database.then((value) async {
      List<Map<String, Object?>> resultado = await value.rawQuery(
          'SELECT COUNT($campo) FROM $nombreTabla WHERE $campo = $valor');
      return (resultado.length > 0 ? true : false);
    }, onError: (error) {
      return false;
    });
    return respuesta;
  }

  // #OBTENER TODOS LOS REGISTROS DE UNA TABLA.
  Future<List<Map<String, dynamic>>> fnObtenerTodosLosRegistros(
      {required String tbName, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.query(tbName,
            orderBy: '${orderByCampo} DESC', groupBy: 'id');
      });
    }
    return maps;
  }

  Future<List<Map<String, dynamic>>> fnObtenerTodosLosRegistrosStandard(
      {required String tbName, int? holeid}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery('SELECT cat_standarid.* FROM tb_collar' +
            ' INNER JOIN tb_projects ON tb_projects.id = tb_collar.project' +
            ' INNER JOIN cat_standarid WHERE cat_standarid.id_company = tb_projects.id_company AND tb_collar.id = $holeid GROUP BY cat_standarid.StandarId');
      });
    }
    return maps;
  }

  Future<List<Map<String, dynamic>>> fnObtenerTodosLosRegistrosGeolog(
      {required String tbName, int? holeid}) async {
    List<Map<String, dynamic>> maps = [];
    int idCompany = 0;
    bool existe = await fnExiste(tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery(
            'SELECT id_company FROM tb_projects INNER JOIN tb_collar ON tb_projects.id = tb_collar.project WHERE tb_collar.id = $holeid ');
        print(maps[0]['id_company'].toString());
        idCompany = maps[0]['id_company'];
        print(idCompany);
      });
      await database.then((db) async {
        maps = await db.rawQuery('SELECT cat_geologist.* FROM cat_geologist' +
            ' INNER JOIN tb_company_geologist ON cat_geologist.Id = tb_company_geologist.id_geologist' +
            ' WHERE tb_company_geologist.id_company = $idCompany ');
        print(maps);
      });
    }
    return maps;
  }

  Future<List<Map<String, dynamic>>> fnObtenerFechaCollar(
      {required int? id}) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.rawQuery("SELECT DateEnd FROM tb_collar where id = $id");
    });
    return maps;
  }

  Future<List<Map<String, dynamic>>> fnObtenerDepthCollar(
      {required int? id}) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.rawQuery("SELECT Depth FROM tb_collar where id = $id");
    });
    return maps;
  }

  Future<List<Map<String, dynamic>>> fnObtenerTodosLosRegistrosASC(
      {required String tbName, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.query(tbName,
            orderBy: '${orderByCampo} ASC', groupBy: 'id');
      });
    }
    return maps;
  }

  // #INSERTAR UN REGISTRO A UNA TABLA.
  Future<int> fnInsertarRegistro(
      String tbName, Map<String, dynamic> values) async {
    int result = 0;
    bool existe = await fnExiste(tbName);
    if (existe) {
      await database.then((db) async {
        // #DEFINIR TIPO REGISTRO NUEVO LOCAL.
        values['status_sync'] = 4;
        //values['']
        int newId = await fnObtnerNuevoId(tbName);
        values['Id'] = newId;
        result = await db.insert(
          tbName,
          values,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    }
    return result;
  }

  // #ACTUALIZAR UN REGISTRO A UNA TABLA.
  Future<int> fnActualizarRegistro(
      String nombreTabla,
      Map<String, Object?> valores,
      String whereCampo,
      dynamic whereValor) async {
    int id = 0;
    bool existe = await fnExiste(nombreTabla);
    if (existe) {
      // #DEFINIR COMO UNA DESCARGA ACTUALIZADA.
      Map<String, dynamic> statusSycnc = await fnObtenerStatusSincro(
          whereCampo, whereValor, nombreTabla, Enum_Acciones.actualizado);
      if (statusSycnc['respuesta']) {
        valores['status_sync'] = statusSycnc['status_sync'];
      }
      await database.then((db) async {
        id = await db.update(nombreTabla, valores,
            where: '$whereCampo = ?', whereArgs: [whereValor]);
        return id;
      });
    }
    return id;
  }

  Future<int> fnObtnerNuevoId(String nombreTabla) async {
    int id = 0;
    List<Map<String, dynamic>> map;
    bool existe = await fnExiste(nombreTabla);
    if (existe) {
      await database.then((db) async {
        map = await db.rawQuery(
            "SELECT (IFNULL(MAX(id),0)+1) AS NEWID FROM $nombreTabla");
        if (map.isNotEmpty) {
          id = map.first['NEWID'];
        }
      });
    }
    return id;
  }

  Future<dynamic> fnObtenerRegistro(
      {required String nombreTabla,
      required String campo,
      required dynamic valor}) async {
    Map<String, dynamic> record = await database.then((value) async {
      List<Map<String, Object?>> resultado = await value
          .rawQuery('SELECT * FROM $nombreTabla WHERE $campo = $valor');
      return resultado.first;
    }, onError: (error) {
      return false;
    });
    return record;
  }

  Future<List<Map<String, dynamic>>> fnRegistrosValueLabelIcon(
      {required String tbName, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = await fnObtenerTodosLosRegistros(
        tbName: tbName, orderByCampo: orderByCampo);
    List<Map<String, dynamic>> mapsCustom = [];

    for (var item in maps) {
      mapsCustom.add({
        'value': item.values.elementAt(0),
        'label': item.values.elementAt(1),
        'icon': Icon(Icons.filter_list_rounded)
      });
    }
    return mapsCustom;
  }

  Future<List<Map<String, dynamic>>> fnRegistrosValueGeolog(
      {required String tbName, int? holeid}) async {
    List<Map<String, dynamic>> maps =
        await fnObtenerTodosLosRegistrosGeolog(tbName: tbName, holeid: holeid);
    List<Map<String, dynamic>> mapsCustom = [];

    for (var item in maps) {
      mapsCustom.add({
        'value': item.values.elementAt(0),
        'label': item.values.elementAt(1),
        'icon': Icon(Icons.filter_list_rounded)
      });
    }
    return mapsCustom;
  }

  Future<List<Map<String, dynamic>>> fnRegistrosValueLabelIconRockStrength(
      {required String tbName, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = await fnObtenerTodosLosRegistrosASC(
        tbName: tbName, orderByCampo: orderByCampo);
    List<Map<String, dynamic>> mapsCustom = [];

    for (var item in maps) {
      mapsCustom.add({
        'value': item.values.elementAt(0),
        'label': item.values.elementAt(1),
        'icon': Icon(Icons.filter_list_rounded)
      });
    }
    return mapsCustom;
  }

/*
  Future<List<RelProfileTabsFieldsModal>> fnObtenerCamposActivas(
      int colladId) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.rawQuery('SELECT RPTF.* ' +
          'FROM tb_rel_profile_tabs_fields AS RPTF ' +
          '   INNER JOIN tb_rel_profile_collars AS RPC ON RPC.profileId = RPTF.profileId ' +
          '   INNER JOIN tb_collar AS C ON c.id = RPC.collarId ' +
          '   INNER JOIN tb_sincronizacion_local_app AS SLA ON SLA.nombre_tabla =  RPTF.tabName ' +
          'WHERE RPC.collarId = $colladId ' +
          //'WHERE RPTF.tabName = tb_loggedby'+
          'GROUP BY RPTF.fieldName ' +
          'ORDER BY  SLA.order_table ASC');
    });
    RelProfileTabsFieldsModal item;
    return List.generate(maps.length, (i) {
      item = new RelProfileTabsFieldsModal();
      item.fromMap(maps[i]);
      return item;
    });
  }

 */

  Future<List<Map<String, dynamic>>> fnObtenerDatosCatalogo(
      {required String tbName, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = await fnObtenerTodosLosRegistros(
        tbName: tbName, orderByCampo: orderByCampo);
    List<Map<String, dynamic>> mapsCustom = [];

    for (var item in maps) {
      mapsCustom.add({
        'id': item.values.elementAt(0),
        'valor': item.values.elementAt(1),
        'repetitions': item.values.elementAt(2)
      });
    }
    return mapsCustom;
  }

  Future<void> fnInitDataBaseLocal() async {
    try {
      await database.then((db) async {
        // #CREAR BASE DE DATOS LOCALES.
        await db.execute(dotenv.env['CREATE_TB_SINCRO_LOCAL_APP'] ?? '');
        await db.execute(
            dotenv.env['CREATE_TB_PROFILE_TABS_FIELDS_LOCAL_APP'] ?? '');
        await db.execute(
            dotenv.env['CREATE_REL_PROFILE_TABS_FIELDS_LOCAL_APP'] ?? '');
        await db.execute(dotenv.env['CREATE_REL_PROFILE_COLLAR'] ?? '');
        await db.execute(dotenv.env['CREATE_CAT_STATUS_SYNC'] ?? '');
        //await db.delete('evidencias_local');
        await db.execute(dotenv.env['CREATE_EVIDENCIAS_LOCAL'] ?? '');

        // #CREAR NUEVOS REGISTROS.
        await db.delete('cat_status_sync');
        await db.insert('cat_status_sync',
            {'id': 1, 'status_sync': 'Download', 'status': 1},
            conflictAlgorithm: ConflictAlgorithm.replace);
        await db.insert('cat_status_sync',
            {'id': 2, 'status_sync': 'Download-Update', 'status': 1},
            conflictAlgorithm: ConflictAlgorithm.replace);
        await db.insert('cat_status_sync',
            {'id': 3, 'status_sync': 'Download-Delete', 'status': 1},
            conflictAlgorithm: ConflictAlgorithm.replace);
        await db.insert('cat_status_sync',
            {'id': 4, 'status_sync': 'Local-New', 'status': 1},
            conflictAlgorithm: ConflictAlgorithm.replace);
        await db.insert('cat_status_sync',
            {'id': 5, 'status_sync': 'Local-Update', 'status': 1},
            conflictAlgorithm: ConflictAlgorithm.replace);
        await db.insert('cat_status_sync',
            {'id': 6, 'status_sync': 'Local-Delete', 'status': 1},
            conflictAlgorithm: ConflictAlgorithm.replace);
        // #OBTENER LISTADO DE TABLAS Y CREARLAS AL INICIO.
      });
    } catch (ex) {
      print(ex);
    }
  }

  Future<List<Map<String, dynamic>>> fnRegistrosValueLabelIcon2(
      {required String tbName, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = await fnObtenerTodosLosRegistros(
        tbName: tbName, orderByCampo: orderByCampo);
    List<Map<String, dynamic>> mapsCustom = [];

    for (var item in maps) {
      mapsCustom.add({
        'value': item.values.elementAt(0),
        'label': item.values.elementAt(1),
        'icon': Icon(Icons.filter_list_rounded)
      });
    }
    return mapsCustom;
  }

  Future<List<Map<String, dynamic>>> fnRegistrosValueLabelIcon3(
      {required String tbName, int? holeid}) async {
    List<Map<String, dynamic>> maps = await fnObtenerTodosLosRegistrosStandard(
        tbName: tbName, holeid: holeid);
    List<Map<String, dynamic>> mapsCustom = [];
    for (var item in maps) {
      mapsCustom.add({
        'value': item.values.elementAt(0),
        'label': item.values.elementAt(2),
        'icon': Icon(Icons.filter_list_rounded)
      });
    }
    return mapsCustom;
  }

  Future<Map<String, dynamic>> fnObtenerStatusSincro(
      String fielId, int id, String tabla, Enum_Acciones accion) async {
    Map<String, dynamic> estatus = Map();
    List<Map<String, dynamic>> resultado = [];
    int status_sync = 0;

    try {
      estatus['respuesta'] = false;
      estatus['status_sync'] = 0;

      if (accion != Enum_Acciones.nuevo) {
        // #OBTENER EL REGISTRO.
        await database.then((db) async {
          resultado = await db.query(tabla,
              where: '$fielId = ?',
              whereArgs: [id]).onError((error, stackTrace) => []);
        });
        // #VALIDAR SI EXISTE.
        if (resultado.isNotEmpty) {
          // #OBTENER STATUS_SYNC.
          status_sync = resultado.first['status_sync'];
          if (status_sync > 0) {}
        }

        // #DEVOLVER STATUS_SYNC FINAL.
        if (status_sync >= 1 && status_sync <= 3) {
          switch (accion) {
            case Enum_Acciones.actualizado:
              estatus['status_sync'] = 2;
              estatus['respuesta'] = true;
              break;
            case Enum_Acciones.eliminado:
              estatus['status_sync'] = 3;
              estatus['respuesta'] = true;
              break;
            default:
              break;
          }
        } else {
          switch (accion) {
            case Enum_Acciones.actualizado:
              estatus['status_sync'] = 5;
              estatus['respuesta'] = true;
              break;
            case Enum_Acciones.eliminado:
              estatus['status_sync'] = 6;
              estatus['respuesta'] = true;
              break;
            default:
              break;
          }
        }
      } else {
        // #NUEVO REGISTRO LOCAL.
        estatus['status_sync'] = 4;
        estatus['respuesta'] = true;
      }
    } catch (ex) {
      estatus['status_sync'] = 0;
      estatus['respuesta'] = false;
      print(ex);
    }
    return estatus;
  }
}
