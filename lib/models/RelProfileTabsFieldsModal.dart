
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RelProfileTabsFieldsModal extends DBDataEntry {
  int id = 0;
  int profileId = 0;
  String tabName = '';
  String fieldName = '';
  int status = 0;

  String tbName = 'tb_rel_profile_tabs_fields';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'tabName': tabName,
      'fieldName': fieldName,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.profileId = map['profileId'] ?? 0;
    this.tabName = map['tabName'] ?? '';
    this.fieldName = map['fieldName'] ?? '';
    this.status = map['status'] ?? 0;
  }

  fnCreateTable() async {
    await database.then((db) async {
      await db.execute(
          dotenv.env['CREATE_REL_PROFILE_TABS_FIELDS_LOCAL_APP'] ?? '');
      return true;
    }, onError: (error) {
      return false;
    });
  }

  Future<List<RelProfileTabsFieldsModal>> fnObtenerTodos() async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.query(this.tbName);
    });
    RelProfileTabsFieldsModal item;
    return List.generate(maps.length, (i) {
      item = new RelProfileTabsFieldsModal();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<List<RelProfileTabsFieldsModal>> fnObtenerFiltradoPorPerfil(
      int perfilId) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db
          .query(this.tbName, where: 'profileId = ?', whereArgs: [perfilId]);
    });
    RelProfileTabsFieldsModal item;
    return List.generate(maps.length, (i) {
      item = new RelProfileTabsFieldsModal();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<List<RelProfileTabsFieldsModal>> fnObtenerPestanasActivas(
      int colladId) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      /*maps = await db
          .rawQuery("SELECT tabName FROM ${this.tbName} Group by tabName");*/
      maps = await db.rawQuery('SELECT RPTF.* ' +
          'FROM tb_rel_profile_tabs_fields AS RPTF ' +
          '   INNER JOIN tb_rel_profile_collars AS RPC ON RPC.profileId = RPTF.profileId ' +
          '   INNER JOIN tb_collar AS C ON c.id = RPC.collarId ' +
          '   INNER JOIN tb_sincronizacion_local_app AS SLA ON SLA.nombre_tabla =  RPTF.tabName ' +
          'WHERE RPC.collarId = $colladId ' +
          'GROUP BY RPTF.tabName ' +
          'ORDER BY  SLA.order_table ASC');
    });
    RelProfileTabsFieldsModal item;
    return List.generate(maps.length, (i) {
      item = new RelProfileTabsFieldsModal();
      item.fromMap(maps[i]);
     // log('Dentro del query DE  LAS PESTA $maps');
      return item;
    });
  }

  Future<List<RelProfileTabsFieldsModal>> fnObtenerCamposActivas(
      int colladId, String tabName) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.rawQuery('SELECT RPTF.fieldName ' +
          'FROM tb_rel_profile_tabs_fields AS RPTF ' +
          'INNER JOIN tb_rel_profile_collars AS RPC ON RPC.profileId = RPTF.profileId ' +
          'INNER JOIN tb_collar AS C ON c.id = RPC.collarId ' +
          'INNER JOIN tb_sincronizacion_local_app AS SLA ON SLA.nombre_tabla =  RPTF.tabName ' +
          'WHERE RPC.collarId = $colladId ' +
          'AND RPTF.tabName =  "$tabName" '+
          'GROUP BY RPTF.fieldName ' +
          'ORDER BY  SLA.order_table ASC');
    });
    RelProfileTabsFieldsModal item;
    return List.generate(maps.length, (i) {
      item = new RelProfileTabsFieldsModal();
      item.fromMap(maps[i]);
      //log('Dentro del query $maps');
      return item;
    });
  }

  Future<bool> fnActualizarRelacion(
      int perfilId, List<RelProfileTabsFieldsModal> relaciones) async {
    bool respuesta = false;
    respuesta = await database.then((db) async {
      bool resp = await db.transaction((txn) async {
        //int perfilId = await txn.insert(this.tbName, perfil.toMap());
        int elimiados = await txn
            .delete(this.tbName, where: 'profileId = ?', whereArgs: [perfilId]);
        relaciones.forEach((rel) async {
          rel.profileId = perfilId;
          txn.rawInsert(
              'INSERT INTO ${rel.tbName}(profileId, tabName, fieldName, status) VALUES(?, ?, ?, ?)',
              [rel.profileId, rel.tabName, rel.fieldName, rel.status]);
        });
        return (elimiados > 0 ? true : false);
      });
      return resp;
    }, onError: (error) {
      return false;
    });
    return respuesta;
  }
}
