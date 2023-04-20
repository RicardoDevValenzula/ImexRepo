
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/TablaSincroLocalModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'RelProfileTabsFieldsModal.dart';

class ProfileTabsFieldsModel extends DBDataEntry {
  int id = 0;
  int userId = 0;
  String profileName = '';
  int status = 0;

  String tbName = 'tb_profile_tabs_fields';
  // #tb_rel_profile_tabs_fields

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'userId': this.userId,
      'profileName': this.profileName,
      'status': this.status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.userId = map['userId'] ?? 0;
    this.profileName = map['profileName'] ?? '';
    this.status = map['status'] ?? 0;
  }

  fnCreateTable() async {
    await database.then((db) async {
      await db
          .execute(dotenv.env['CREATE_TB_PROFILE_TABS_FIELDS_LOCAL_APP'] ?? '');
      return true;
    }, onError: (error) {
      return false;
    });
  }

  Future<List<ProfileTabsFieldsModel>> selectActivos() async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.query(this.tbName, where: 'status = ?', whereArgs: [1]);
    });
    ProfileTabsFieldsModel item;
    return List.generate(maps.length, (i) {
      item = new ProfileTabsFieldsModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<int> insertarModel() async {
    int result = 0;
    await database.then((db) async {
      result = await db.insert(this.tbName, toMap());
    });
    return result;
  }

  Future<bool> fnEliminarPerfilCompleto(int id) async {
    bool respuesta = false;
    respuesta = await database.then((db) async {
      bool resp = await db.transaction((txn) async {
        await txn.delete('tb_rel_profile_tabs_fields',
            where: 'profileId = ?', whereArgs: [id]);
        int del_profile =
            await txn.delete(this.tbName, where: 'id = ?', whereArgs: [id]);
        return (del_profile > 0 ? true : false);
      });
      return resp;
    }, onError: (error) {
      return false;
    });
    return respuesta;
  }

  Future<bool> fnInsertarPerfilConRelacion(ProfileTabsFieldsModel perfil,
      List<RelProfileTabsFieldsModal> relaciones) async {
    bool respuesta = false;

    respuesta = await database.then((db) async {
      bool resp = await db.transaction((txn) async {
        //int perfilId = await txn.insert(this.tbName, perfil.toMap());
        int perfilId = await txn.rawInsert(
            'INSERT INTO ${this.tbName}(userId, profileName, status) VALUES(?, ?, ?)',
            [perfil.userId, perfil.profileName, status]);
        relaciones.forEach((rel) async {
          rel.profileId = perfilId;
          //print();
          txn.rawInsert(
              'INSERT INTO ${rel.tbName}(profileId, tabName, fieldName, status) VALUES(?, ?, ?, ?)',
              [rel.profileId, rel.tabName, rel.fieldName, rel.status]);

        });
        return (perfilId > 0 ? true : false);
      });
      return resp;
    }, onError: (error) {
      return false;
    });
    return respuesta;
  }

  Future<bool> fnYaExisteElPerfil(String nombrePerfil, int userId) async {
    bool respuesta = false;
    List<Map<String, dynamic>> maps = [];
    respuesta = await database.then((db) async {
      maps = await db.query(this.tbName,
          where: 'profileName = ? AND userId = ?',
          whereArgs: [nombrePerfil, userId]);
      return (maps.length > 0 ? true : false);
    });
    return respuesta;
  }

  Future<bool> fnCrearPerfilDefault(int idUser) async {
    String nombrePerfil = 'Default';
    bool resultado = false;
    ProfileTabsFieldsModel perfil = new ProfileTabsFieldsModel();
    bool existe = false;
    try {
      existe = await perfil.fnYaExisteElPerfil(nombrePerfil, idUser);
      if (!existe) {
        perfil.id = 1;
        perfil.userId = idUser;
        perfil.profileName = nombrePerfil;
        perfil.status = 1;

        RelProfileTabsFieldsModal item;
        List<RelProfileTabsFieldsModal> relaciones = [];

        // #OBTENER LISTA DE TABS.
        TablaSincroLocalModel tbSincroLocalModel = new TablaSincroLocalModel();
        List<TablaSincroLocalModel> tablas =
            await tbSincroLocalModel.fnObtenerTablasTipoPestanas();
        for (TablaSincroLocalModel tabla in tablas) {
          // #OBTENER CAMPOS DE LAS TABS.
          List<Map<String, dynamic>> campos = await tbSincroLocalModel
              .fnObtenerCamposPorTabla(tabla.nombreTabla);
          for (Map<String, dynamic> campo in campos) {
            String field = campo['name'].toString().toLowerCase().trim();
            if (field.contains('id') == false &&
                field.contains('geolfrom') == false &&
                field.contains('geolto') == false &&
                field.contains('status') == false) {
              item = new RelProfileTabsFieldsModal();
              item.profileId = perfil.id;
              item.tabName = tabla.nombreTabla;
              item.fieldName = field;
              item.status = 1;
              relaciones.add(item);
            }
          }
        }
        //resultado = true;
        resultado =
            await perfil.fnInsertarPerfilConRelacion(perfil, relaciones);

        print("Profile created successfully.");
      } else {
        print("This profile name already exists.");
      }
    } catch (ex) {
      print("fnCrearPerfilDefault: $ex");
    }
    return resultado;
  }
}
