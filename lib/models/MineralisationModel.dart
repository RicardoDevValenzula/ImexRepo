import 'package:data_entry_app/controllers/DBDataEntry.dart';

import '../controllers/GeneralController.dart';

class MineralisationModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double geolFrom = 0.0;
  double geolTo = 0.0;
  double chk = 0.0;
  String mineralComments = '';
  dynamic noQtzVeins = '';
  dynamic mineral1 = 0;
  dynamic mineral1Style = 0;
  dynamic mineral1Percent = '';
  dynamic mineral2 = 0;
  dynamic mineral2Style = 0;
  dynamic mineral2Percent = '';
  dynamic mineral3 = 0;
  dynamic mineral3Style = 0;
  dynamic mineral3Percent = '';
  dynamic mineral4 = 0;
  dynamic mineral4Style = 0;
  dynamic mineral4Percent = '';
  dynamic mineral5 = 0;
  dynamic mineral5Style = 0;
  dynamic mineral5Percent = '';
  dynamic mineral6 = 0;
  dynamic mineral6Style = 0;
  dynamic mineral6Percent = '';
  dynamic mineral7 = 0;
  dynamic mineral7Style = 0;
  dynamic mineral7Percent = '';
  dynamic mineral8 = 0;
  dynamic mineral8Style = 0;
  dynamic mineral8Percent = '';
  dynamic mineral9 = 0;
  dynamic mineral9Style = 0;
  dynamic mineral9Percent = '';
  dynamic mineral10 = 0;
  dynamic mineral10Style = 0;
  dynamic mineral10Percent = '';
  dynamic mineral11 = 0;
  dynamic mineral11Style = 0;
  dynamic mineral11Percent = '';
  dynamic mineral12 = 0;
  dynamic mineral12Style = 0;
  dynamic mineral12Percent = '';
  int status = 0;
  // #CAMPOS RELACION A OTRAS TABLAS.
  String mineral1Name = '';
  String mineral1StyleName = '';
  String mineral2Name = '';
  String mineral2StyleName = '';
  String mineral3Name = '';
  String mineral3StyleName = '';
  String mineral4Name = '';
  String mineral4StyleName = '';
  String mineral5Name = '';
  String mineral5StyleName = '';
  String mineral6Name = '';
  String mineral6StyleName = '';
  String mineral7Name = '';
  String mineral7StyleName = '';
  String mineral8Name = '';
  String mineral8StyleName = '';
  String mineral9Name = '';
  String mineral9StyleName = '';
  String mineral10Name = '';
  String mineral10StyleName = '';
  String mineral11Name = '';
  String mineral11StyleName = '';
  String mineral12Name = '';
  String mineral12StyleName = '';

  String tbName = 'tb_mineralisation';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'Mineral_Comment': mineralComments,
      'No_Qtz_Veins': noQtzVeins,
      'Mineral1': mineral1,
      'MineralStyle1': mineral1Style,
      'Mineral1_Percent': mineral1Percent,
      'Mineral2': mineral2,
      'MineralStyle2': mineral2Style,
      'Mineral2_Percent': mineral2Percent,
      'Mineral3': mineral3,
      'MineralStyle3': mineral3Style,
      'Mineral3_Percent': mineral3Percent,
      'Mineral4': mineral4,
      'MineralStyle4': mineral4Style,
      'Mineral4_Percent': mineral4Percent,
      'Mineral5': mineral5,
      'MineralStyle5': mineral5Style,
      'Mineral5_Percent': mineral5Percent,
      'Mineral6': mineral6,
      'MineralStyle6': mineral6Style,
      'Mineral6_Percent': mineral6Percent,
      'Mineral7': mineral7,
      'MineralStyle7': mineral7Style,
      'Mineral7_Percent': mineral7Percent,
      'Mineral8': mineral8,
      'MineralStyle8': mineral8Style,
      'Mineral8_Percent': mineral8Percent,
      'Mineral9': mineral9,
      'MineralStyle9': mineral9Style,
      'Mineral9_Percent': mineral9Percent,
      'Mineral10': mineral10,
      'MineralStyle10': mineral10Style,
      'Mineral10_Percent': mineral10Percent,
      'Mineral11': mineral11,
      'MineralStyle11': mineral11Style,
      'Mineral11_Percent': mineral11Percent,
      'Mineral12': mineral12,
      'MineralStyle12': mineral12Style,
      'Mineral12_Percent': mineral12Percent,

      'status': status,
      // #CAMPOS RELACION A OTRAS TABLAS.
      'mineral1Name': mineral1Name,
      'mineral1StyleName': mineral1StyleName,
      'mineral2Name': mineral2Name,
      'mineral2StyleName': mineral2StyleName,
      'mineral3Name': mineral3Name,
      'mineral3StyleName': mineral3StyleName,
      'mineral4Name': mineral4Name,
      'mineral4StyleName': mineral4StyleName,
      'mineral5Name': mineral5Name,
      'mineral5StyleName': mineral5StyleName,
      'mineral6Name': mineral6Name,
      'mineral6StyleName': mineral6StyleName,
      'mineral7Name': mineral7Name,
      'mineral7StyleName': mineral7StyleName,
      'mineral8Name': mineral8Name,
      'mineral8StyleName': mineral8StyleName,
      'mineral9Name': mineral9Name,
      'mineral9StyleName': mineral9StyleName,
      'mineral10Name': mineral10Name,
      'mineral10StyleName': mineral10StyleName,
      'mineral11Name': mineral11Name,
      'mineral11StyleName': mineral11StyleName,
      'mineral12Name': mineral12Name,
      'mineral12StyleName': mineral12StyleName,
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.mineralComments = map['Mineral_Comment'] ?? '';
    this.mineral1 = map['Lithology_Local'] ?? 0;
    this.noQtzVeins = map['No_Qtz_Veins'] ?? '';
    this.mineral1 = map['Mineral1'] ?? 0;
    this.mineral1Style = map['MineralStyle1'] ?? 0;
    this.mineral1Percent = map['Mineral1_Percent'] ?? '';
    this.mineral2 = map['Mineral2'] ?? 0;
    this.mineral2Style = map['MineralStyle2'] ?? 0;
    this.mineral2Percent = map['Mineral2_Percent'] ?? '';
    this.mineral3 = map['Mineral3'] ?? 0;
    this.mineral3Style = map['MineralStyle3'] ?? 0;
    this.mineral3Percent = map['Mineral3_Percent'] ?? '';
    this.mineral4 = map['Mineral4'] ?? 0;
    this.mineral4Style = map['MineralStyle4'] ?? 0;
    this.mineral4Percent = map['Mineral4_Percent'] ?? '';
    this.mineral5 = map['Mineral5'] ?? 0;
    this.mineral5Style = map['MineralStyle5'] ?? 0;
    this.mineral5Percent = map['Mineral5_Percent'] ?? '';
    this.mineral6 = map['Mineral6'] ?? 0;
    this.mineral6Style = map['MineralStyle6'] ?? 0;
    this.mineral6Percent = map['Mineral6_Percent'] ?? '';
    this.mineral7 = map['Mineral7'] ?? 0;
    this.mineral7Style = map['MineralStyle7'] ?? 0;
    this.mineral7Percent = map['Mineral7_Percent'] ?? '';
    this.mineral8 = map['Mineral8'] ?? 0;
    this.mineral8Style = map['MineralStyle8'] ?? 0;
    this.mineral8Percent = map['Mineral8_Percent'] ?? '';
    this.mineral9 = map['Mineral9'] ?? 0;
    this.mineral9Style = map['MineralStyle9'] ?? 0;
    this.mineral9Percent = map['Mineral9_Percent'] ?? '';
    this.mineral10 = map['Mineral10'] ?? 0;
    this.mineral10Style = map['MineralStyle10'] ?? 0;
    this.mineral10Percent = map['Mineral10_Percent'] ?? '';
    this.mineral11 = map['Mineral11'] ?? 0;
    this.mineral11Style = map['MineralStyle11'] ?? 0;
    this.mineral11Percent = map['Mineral11_Percent'] ?? '';
    this.mineral12 = map['Mineral12'] ?? 0;
    this.mineral12Style = map['MineralStyle12'] ?? 0;
    this.mineral12Percent = map['Mineral12_Percent'] ?? '';
    this.status = map['status'] ?? 0;
    // #CAMPOS RELACION A OTRAS TABLAS.
    this.mineral1Name = map['Mineral1Name'] ?? '';
    this.mineral1StyleName = map['Mineral1StyleName'] ?? '';
    this.mineral2Name = map['Mineral2Name'] ?? '';
    this.mineral2StyleName = map['Mineral2StyleName'] ?? '';
    this.mineral3Name = map['Mineral3Name'] ?? '';
    this.mineral3StyleName = map['Mineral3StyleName'] ?? '';
    this.mineral4Name = map['Mineral4Name'] ?? '';
    this.mineral4StyleName = map['Mineral4StyleName'] ?? '';
    this.mineral5Name = map['Mineral5Name'] ?? '';
    this.mineral5StyleName = map['Mineral5StyleName'] ?? '';
    this.mineral6Name = map['Mineral6Name'] ?? '';
    this.mineral6StyleName = map['Mineral6StyleName'] ?? '';
    this.mineral7Name = map['Mineral7Name'] ?? '';
    this.mineral7StyleName = map['Mineral7StyleName'] ?? '';
    this.mineral8Name = map['Mineral8Name'] ?? '';
    this.mineral8StyleName = map['Mineral8StyleName'] ?? '';
    this.mineral9Name = map['Mineral9Name'] ?? '';
    this.mineral9StyleName = map['Mineral9StyleName'] ?? '';
    this.mineral10Name = map['Mineral10Name'] ?? '';
    this.mineral10StyleName = map['Mineral10StyleName'] ?? '';
    this.mineral11Name = map['Mineral11Name'] ?? '';
    this.mineral11StyleName = map['Mineral11StyleName'] ?? '';
    this.mineral12Name = map['Mineral12Name'] ?? '';
    this.mineral12StyleName = map['Mineral12StyleName'] ?? '';
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

  Future<List<MineralisationModel>> fnObtenerRegistrosPorCollarId(
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
            "	IFNULL(m1.Mineral, '') AS Mineral1Name, " +
            "	IFNULL(ms1.MineralStyle, '') AS Mineral1StyleName, " +
            "	IFNULL(m2.Mineral, '') AS Mineral2Name, " +
            "	IFNULL(ms2.MineralStyle, '') AS Mineral2StyleName, " +
            "	IFNULL(m3.Mineral, '') AS Mineral3Name, " +
            "	IFNULL(ms3.MineralStyle, '') AS Mineral3StyleName, " +
            "	IFNULL(m4.Mineral, '') AS Mineral4Name, " +
            "	IFNULL(ms4.MineralStyle, '') AS Mineral4StyleName, " +
            "	IFNULL(m5.Mineral, '') AS Mineral5Name, " +
            "	IFNULL(ms5.MineralStyle, '') AS Mineral5StyleName, " +
            "	IFNULL(m6.Mineral, '') AS Mineral6Name, " +
            "	IFNULL(ms6.MineralStyle, '') AS Mineral6StyleName, " +
            "	IFNULL(m7.Mineral, '') AS Mineral7Name, " +
            "	IFNULL(ms7.MineralStyle, '') AS Mineral7StyleName, " +
            "	IFNULL(m8.Mineral, '') AS Mineral8Name, " +
            "	IFNULL(ms8.MineralStyle, '') AS Mineral8StyleName, " +
            "	IFNULL(m9.Mineral, '') AS Mineral9Name, " +
            "	IFNULL(ms9.MineralStyle, '') AS Mineral9StyleName, " +
            "	IFNULL(m10.Mineral, '') AS Mineral10Name, " +
            "	IFNULL(ms10.MineralStyle, '') AS Mineral10StyleName, " +
            "	IFNULL(m11.Mineral, '') AS Mineral11Name, " +
            "	IFNULL(ms11.MineralStyle, '') AS Mineral11StyleName, " +
            "	IFNULL(m12.Mineral, '') AS Mineral12Name, " +
            "	IFNULL(ms12.MineralStyle, '') AS Mineral12StyleName, " +
            "	L.* " +
            "FROM $tbName AS L " +
            "	LEFT JOIN cat_mineral AS m1 ON m1.Id = L.Mineral1 " +
            "	LEFT JOIN cat_mineral AS m2 ON m2.Id = L.Mineral2 " +
            "	LEFT JOIN cat_mineral AS m3 ON m3.Id = L.Mineral3 " +
            "	LEFT JOIN cat_mineral AS m4 ON m4.Id = L.Mineral4 " +
            "	LEFT JOIN cat_mineral AS m5 ON m5.Id = L.Mineral5 " +
            "	LEFT JOIN cat_mineral AS m6 ON m6.Id = L.Mineral6 " +
            "	LEFT JOIN cat_mineral AS m7 ON m7.Id = L.Mineral7 " +
            "	LEFT JOIN cat_mineral AS m8 ON m8.Id = L.Mineral8 " +
            "	LEFT JOIN cat_mineral AS m9 ON m9.Id = L.Mineral9 " +
            "	LEFT JOIN cat_mineral AS m10 ON m10.Id = L.Mineral10 " +
            "	LEFT JOIN cat_mineral AS m11 ON m11.Id = L.Mineral11 " +
            "	LEFT JOIN cat_mineral AS m12 ON m12.Id = L.Mineral12 " +
            "	LEFT JOIN cat_mineralstyle AS ms1 ON ms1.Id = L.MineralStyle1 " +
            "	LEFT JOIN cat_mineralstyle AS ms2 ON ms2.Id = L.MineralStyle2 " +
            "	LEFT JOIN cat_mineralstyle AS ms3 ON ms3.Id = L.MineralStyle3 " +
            "	LEFT JOIN cat_mineralstyle AS ms4 ON ms4.Id = L.MineralStyle4 " +
            "	LEFT JOIN cat_mineralstyle AS ms5 ON ms5.Id = L.MineralStyle5 " +
            "	LEFT JOIN cat_mineralstyle AS ms6 ON ms6.Id = L.MineralStyle6 " +
            "	LEFT JOIN cat_mineralstyle AS ms7 ON ms7.Id = L.MineralStyle7 " +
            "	LEFT JOIN cat_mineralstyle AS ms8 ON ms8.Id = L.MineralStyle8 " +
            "	LEFT JOIN cat_mineralstyle AS ms9 ON ms9.Id = L.MineralStyle9 " +
            "	LEFT JOIN cat_mineralstyle AS ms10 ON ms10.Id = L.MineralStyle10 " +
            "	LEFT JOIN cat_mineralstyle AS ms11 ON ms11.Id = L.MineralStyle11 " +
            "	LEFT JOIN cat_mineralstyle AS ms12 ON ms12.Id = L.MineralStyle12 " +
            "WHERE L.IdCollar = $collarId  AND L.status = 1 " +
            "ORDER BY GeolFrom ASC "
        );
      });
    }
    MineralisationModel item;
    return List.generate(maps.length, (i) {
      item = new MineralisationModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<dynamic> fnEliminarRegistro(
      {required String nombreTabla,
      required String campo,
      required dynamic valor}) async {
    int count = 0;
    await database.then((value) async {
      Map<String, dynamic> valores = Map();
      Map<String, dynamic> statusSycnc = await fnObtenerStatusSincro(campo, valor, nombreTabla, Enum_Acciones.eliminado);
      if (statusSycnc['respuesta']) {
        valores['status_sync'] = statusSycnc['status_sync'];
      }
      valores['status'] = 0;
      count = await value.update(nombreTabla, valores,
          where: '$campo = ?', whereArgs: [valor]);
      return id;
      //assert(count == 1);
    }, onError: (error) {
      return false;
    });
    return count;
  }
}
