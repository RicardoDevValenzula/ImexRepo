import 'package:data_entry_app/controllers/DBDataEntry.dart';

import '../controllers/GeneralController.dart';

class AlterationMinsModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double geolFrom = 0.0;
  double geolTo = 0.0;
  double chk = 0.0;

  dynamic altMineral1 = 0;
  dynamic altMineral1Intensity = 0;
  dynamic altMineral2 = 0;
  dynamic altMineral2Intensity = 0;
  dynamic altMineral3 = 0;
  dynamic altMineral3Intensity = 0;

  int status = 0;
  // #CAMPOS RELACION A OTRAS TABLAS.
  String altMineral1Name = '';
  String altMin1IntensityName = '';
  String altMineral2Name = '';
  String altMin2IntensityName = '';
  String altMineral3Name = '';
  String altMin3IntensityName = '';

  String tbName = 'tb_alterationmins';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'AltMineral1': altMineral1,
      'AltMin1_Intensity': altMineral1Intensity,
      'AltMineral2': altMineral2,
      'AltMin2_Intensity': altMineral2Intensity,
      'AltMineral3': altMineral3,
      'AltMin3_Intensity': altMineral3Intensity,
      'status': status,
      // #CAMPOS RELACION A OTRAS TABLAS.
      'altMineral1Name': altMineral1Name,
      'AltMin1_IntensityName': altMin1IntensityName,
      'altMineral2Name': altMineral2Name,
      'AltMin2_IntensityName': altMin2IntensityName,
      'altMineral3Name': altMineral3Name,
      'AltMin3_IntensityName': altMin3IntensityName
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.altMineral1 = map['AltMineral1'] ?? '';
    this.altMineral1Intensity = map['AltMin1Intensity'] ?? '';
    this.altMineral2 = map['AltMineral2'] ?? '';
    this.altMineral2Intensity = map['AltMin2Intensity'] ?? '';
    this.altMineral2 = map['AltMineral2'] ?? '';
    this.altMineral2Intensity = map['AltMin2Intensity'] ?? '';

    this.status = map['status'] ?? 0;
    // #CAMPOS RELACION A OTRAS TABLAS.
    this.altMineral1Name = map['altMineral1Name'] ?? '';
    this.altMin1IntensityName = map['AltMin1IntensityName'] ?? '';
    this.altMineral2Name = map['altMineral2Name'] ?? '';
    this.altMin2IntensityName = map['AltMin2IntensityName'] ?? '';
    this.altMineral3Name = map['altMineral3Name'] ?? '';
    this.altMin3IntensityName = map['AltMin3IntensityName'] ?? '';
  }

  Future<int> insertarModelo() async {
    int result = 0;
    int newId = await fnObtnerNuevoId(this.tbName);
    await database.then((db) async {
      this.id = newId;
      result = await db.insert(this.tbName, toMap());
    });
    return result;
  }

  Future<List<AlterationMinsModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        /*
        maps = await db.query(this.tbName,
            where: 'IdCollar = ?',
            whereArgs: [collarId],
            orderBy: orderByCampo);
        */
        maps = await db.rawQuery("SELECT " +
            "	IFNULL(am1.AltMineral, '') AS altMineral1Name, " +
            "	IFNULL(am2.AltMineral, '') AS altMineral2Name, " +
            "	IFNULL(am3.AltMineral, '') AS altMineral3Name, " +
            "	IFNULL(ai1.AltMin_Intensity, '') AS AltMin1IntensityName, " +
            "	IFNULL(ai2.AltMin_Intensity, '') AS AltMin2IntensityName, " +
            "	IFNULL(ai3.AltMin_Intensity, '') AS AltMin3IntensityName, " +
            "	L.* " +
            "FROM $tbName AS L " +
            "	LEFT JOIN cat_altmineral AS am1 ON am1.Id = L.AltMineral1 " +
            "	LEFT JOIN cat_altmineral AS am2 ON am2.Id = L.AltMineral2 " +
            "	LEFT JOIN cat_altmineral AS am3 ON am3.Id = L.AltMineral3 " +
            "	LEFT JOIN cat_altmin_intensity AS ai1 ON ai1.Id = L.AltMin1_Intensity " +
            "	LEFT JOIN cat_altmin_intensity AS ai2 ON ai2.Id = L.AltMin2_Intensity " +
            "	LEFT JOIN cat_altmin_intensity AS ai3 ON ai3.Id = L.AltMin3_Intensity " +
            "WHERE L.IdCollar = $collarId AND L.status = 1 " +
            "ORDER BY GeolFrom ASC"
        );
      });
    }
    AlterationMinsModel item;
    return List.generate(maps.length, (i) {
      item = new AlterationMinsModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<dynamic> fnEliminarRegistro(
      {required String campo, required dynamic valor}) async {
    int count = 0;
    await database.then((value) async {
      Map<String, dynamic> valores = Map();
      Map<String, dynamic> statusSycnc = await fnObtenerStatusSincro(campo, valor, this.tbName, Enum_Acciones.eliminado);
      if (statusSycnc['respuesta']) {
        valores['status_sync'] = statusSycnc['status_sync'];
      }
      valores['status'] = 0;
      count = await value.update(this.tbName, valores,
          where: '$campo = ?', whereArgs: [valor]);
      return id;
      //assert(count == 1);
    }, onError: (error) {
      return false;
    });
    return count;
  }
}
